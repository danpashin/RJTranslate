//
//  AppCollectionModel.swift
//  RJTranslate-App
//
//  Created by Даниил on 19/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public class AppCollectionModel {
    
    /// Модел датасорс коллекции.
    public private(set) var currentDataSource: AppCollectionDataSource?
    
    private weak var database: RJTDatabaseFacade?
    private weak var collectionView: AppCollectionView?
    
    private var allModelsDataSource: AppCollectionDataSource?
    
    /// Выполняет инициализацию модели для конкретной коллекции.
    ///
    /// - Parameter collectionView: Коллекция, для которой выполняется инициализация модели.
    public init(collectionView: AppCollectionView) {
        self.database = UIApplication.applicationDelegate.defaultDatabase
        
        self.collectionView = collectionView
        self.collectionView?.model = self
    }
    
    // MARK: -
    // MARK: Search
    
    /// Подготавливает коллекцию к выполнению поиска. Метод должен вызываться всегда перед началом поиска.
    public func beginSearch() {
        self.collectionView?.updateEmptyView(to: .noSearchResults)
        self.allModelsDataSource = self.currentDataSource
    }
    
    /// Выполняет поиск в базе данных по заданному тексту и перезагружает коллекцию.
    ///
    /// - Parameter text: Текст, по которому выполняется поиск.
    public func performSearch(text: String) {
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
    public func endSearch() {
        self.restoreDatasource()
        self.allModelsDataSource = nil
    }
    
    /// Выполняет полную перезагрузку коллекции из базы данных
    public func loadDatabaseModels() {
        self.collectionView?.updateEmptyView(to: .loading)
        self.database?.fetchAllAppModels { allModels in
            if allModels.count == 0 {
                self.collectionView?.updateEmptyView(to: .noData)
            }
            
            self.updateCollection(models: allModels)
        }
    }
    
    private func updateCollection(models: [RJTApplicationModel]) {
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
    func updateModel(_ appModel: RJTApplicationModel) {
        self.database?.update(appModel)
        
        let executableName = appModel.executableName
        if (executableName?.count ?? 0) > 0 {
            RJTPosixWrapper.executeCommand(["/usr/bin/killall", "-9", executableName!])
        }
        
        UIApplication.applicationDelegate.tracker?.trackSelectTranslation(name: appModel.displayedName)
    }
}
