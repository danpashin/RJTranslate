//
//  AppCollectionModel.swift
//  RJTranslate-App
//
//  Created by Даниил on 19/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class AppCollectionModel {
    
    /// Модел датасорс коллекции.
    private(set) var currentDataSource: AppCollectionDataSource?
    
    private weak var database: RJTDatabaseAppFacade?
    private weak var collectionView: AppCollectionView?
    
    private var allModelsDataSource: AppCollectionDataSource?
    
    /// Выполняет инициализацию модели для конкретной коллекции.
    ///
    /// - Parameter collectionView: Коллекция, для которой выполняется инициализация модели.
    init(collectionView: AppCollectionView) {
        self.database = UIApplication.applicationDelegate.defaultDatabase
        
        self.collectionView = collectionView
        self.collectionView?.model = self
    }
    
    // MARK: -
    // MARK: Search
    
    /// Подготавливает коллекцию к выполнению поиска. Метод должен вызываться всегда перед началом поиска.
    func beginSearch() {
        self.collectionView?.updateEmptyView(to: .noSearchResults)
        self.allModelsDataSource = self.currentDataSource
    }
    
    /// Выполняет поиск в базе данных по заданному тексту и перезагружает коллекцию.
    ///
    /// - Parameter text: Текст, по которому выполняется поиск.
    func performSearch(text: String) {
        if text.count == 0 {
            self.restoreDatasource()
            return
        }
        
        self.database?.performModelsSearch(withText: text) { models in
            self.updateCollection(models: models)
        }
        
        UIApplication.applicationDelegate.tracker?.trackSearchEvent(text)
    }
    
    private func restoreDatasource() {
        self.updateDataSourceObject(self.allModelsDataSource)
    }
    
    /// Заканчивает выполнение поиска и сбрасывает коллекцию к тому состоянию, в котором она была перед началом поиска.
    func endSearch() {
        self.restoreDatasource()
        self.allModelsDataSource = nil
    }
    
    /// Выполняет полную перезагрузку коллекции из базы данных
    func loadDatabaseModels() {
        self.collectionView?.updateEmptyView(to: .loading)
        self.database?.fetchAllAppModels { allModels in
            if allModels.count == 0 {
                self.collectionView?.updateEmptyView(to: .noData)
            }
            
            self.updateCollection(models: allModels)
        }
    }
    
    private func updateCollection(models: [TranslationModel]) {
        DispatchQueue(label: "self").sync {
            let modelsSourceObject = AppCollectionDataSource(models: models)
            updateDataSourceObject(modelsSourceObject)
        }
    }
    
    private func updateDataSourceObject(_ dataSourceObject: AppCollectionDataSource?) {
        DispatchQueue.main.async {
            self.collectionView?.layout?.dataSourceChanged(from: self.currentDataSource, to: dataSourceObject)
            self.currentDataSource = dataSourceObject
            self.collectionView?.reload()
        }
    }
    
    
    // MARK: -
    
    /// Выполняет обновление модели в базе данных.
    ///
    /// - Parameter model: Модель для обновления.
    func updateModel(_ appModel: TranslationModel) {
        self.database?.update(appModel)
        if let index = self.allModelsDataSource?.allModels.firstIndex(of: appModel) {
            let model = self.allModelsDataSource!.allModels[index]
            model.enable = appModel.enable
        }
        
        let executableName = appModel.executableName
        if (executableName?.count ?? 0) > 0 {
            RJTUtilities.executeSystemCommand(["/usr/bin/killall", "-9", executableName!, "2>/dev/null"])
        }
        
        UIApplication.applicationDelegate.tracker?.trackSelectTranslation(name: appModel.displayedName)
    }
}
