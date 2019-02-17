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
    private(set) var currentDataSource = AppCollectionDataSource(models: []) {
        didSet {
            PropertyObserver(name: .translationCollectionReloadData,
                             oldValue: oldValue, newValue: self.currentDataSource).post()
        }
    }
    
    private weak var database: RJTDatabaseAppFacade?
    private weak var collectionView: AppCollectionView?
    
    private var allModelsDataSource: AppCollectionDataSource
    
    private var loadDatabaseOberver: NSObjectProtocol?
    
    /// Выполняет инициализацию модели для конкретной коллекции.
    ///
    /// - Parameter collectionView: Коллекция, для которой выполняется инициализация модели.
    init(collectionView: AppCollectionView) {
        self.database = UIApplication.applicationDelegate.defaultDatabase
        
        self.collectionView = collectionView
        self.allModelsDataSource = self.currentDataSource
        
        let notifCenter = NotificationCenter.default
        self.loadDatabaseOberver = notifCenter.addObserver(forName: .translationCollectionLoadDatabase, object: nil,
                                                           queue: .main, using: { (notification: Notification) in
                                                            self.loadDatabaseModels()
        })
    }
    
    deinit {
        if self.loadDatabaseOberver != nil {
            NotificationCenter.default.removeObserver(self.loadDatabaseOberver!)
        }
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
            self.currentDataSource = AppCollectionDataSource(models: models)
        }
        
        UIApplication.applicationDelegate.tracker?.trackSearchEvent(text)
    }
    
    private func restoreDatasource() {
        self.currentDataSource = self.allModelsDataSource
    }
    
    /// Заканчивает выполнение поиска и сбрасывает коллекцию к тому состоянию, в котором она была перед началом поиска.
    func endSearch() {
        self.restoreDatasource()
    }
    
    /// Выполняет полную перезагрузку коллекции из базы данных
    func loadDatabaseModels() {
        self.collectionView?.updateEmptyView(to: .loading)
        self.database?.fetchAllAppModels { allModels in
            if allModels.count == 0 {
                self.collectionView?.updateEmptyView(to: .noData)
            }
            
            self.allModelsDataSource = AppCollectionDataSource(models: allModels)
            self.currentDataSource = self.allModelsDataSource
            self.checkUpdates(for: allModels)
        }
    }
    
    private func checkUpdates(for models: [TranslationModel]) {
        DispatchQueue.once(token: "ru.danpashin.rjtranslate.updates.check") {
            DispatchQueue.global(qos: .background).async {
//                API.TranslationUpdates.check(for: models, completion: { (toUpdate: [TranslationModel]) in
//
//                })
            }
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5.0, execute: {
                var newModels = models
                newModels.remove(at: 0)
                print("\(newModels)")
                self.allModelsDataSource.moveModelsToUpdatable(newModels)
            })
        }
    }
    
    // MARK: -
    
    /// Выполняет обновление модели в базе данных.
    ///
    /// - Parameter model: Модель для обновления.
    func updateModel(_ appModel: TranslationModel) {
        self.database?.update(appModel)
        if let index = self.allModelsDataSource.allModels.firstIndex(of: appModel) {
            let model = self.allModelsDataSource.allModels[index]
            model.enable = appModel.enable
        }
        
        let executableName = appModel.executableName
        if (executableName?.count ?? 0) > 0 {
            RJTUtilities.executeSystemCommand(["/usr/bin/killall", "-9", executableName!, "2>/dev/null"])
        }
        
        UIApplication.applicationDelegate.tracker?.trackSelectTranslation(name: appModel.displayedName)
    }
}
