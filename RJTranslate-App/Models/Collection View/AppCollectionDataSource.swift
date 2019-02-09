//
//  AppCollectionDataSource.swift
//  RJTranslate-App
//
//  Created by Даниил on 13/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class AppCollectionDataSource: CustomStringConvertible {
    
    /// Массив содержит все модели переводов
    private(set) var allModels = [TranslationModel]()
    
    /// Массив содержит модели переводов, которые могут быть обновлены.
    private(set) var updatableModels = [TranslationModel]()
    
    /// Массив содержит модели переводов, приложения которых установлены на устройстве.
    private(set) var installed = [TranslationModel]()
    
    /// Массив содержит модели переводов, приложения которых НЕ установлены на устройстве.
    private(set) var uninstalled = [TranslationModel]()
    
    /// Выполняет инициализацию и разделение моделей в датасорсе.
    ///
    /// - Parameter models:  Модели для датасорса.
    init(models: [TranslationModel]) {
        self.allModels = models
        
        for model in models {
            if model.appInstalled {
                self.installed.append(model)
            } else {
                self.uninstalled.append(model)
            }
        }
    }
    
    func modelFor(indexPath: IndexPath) -> TranslationModel? {
        var modelsArray: [TranslationModel]?
        
        switch indexPath.section {
        case 0: modelsArray = self.updatableModels
        case 1: modelsArray = self.installed
        case 2: modelsArray = self.uninstalled
        default: break
        }
        
        if indexPath.row > modelsArray?.count ?? 0 { return nil }
        return modelsArray![indexPath.row]
    }
    
    func numberOfModelsFor(section: Int) -> Int {
        switch section {
        case 0: return self.updatableModels.count
        case 1: return self.installed.count
        case 2: return self.uninstalled.count
        default: return 0
        }
    }
    
    func moveModelsToUpdatable(_ models: [TranslationModel]) {
        self.updatableModels = models
        
        for model in models {
            if let index = self.installed.firstIndex(of: model) {
                self.installed.remove(at: index)
            } else if let index = self.uninstalled.firstIndex(of: model) {
                self.uninstalled.remove(at: index)
            }
        }
    }
    
    var description: String {
        return String(format: "<%@; installed %@; uninstalled %@>",
                      classInfo(self), self.installed, self.uninstalled)
    }
}
