//
//  AppCollectionDataSource.swift
//  RJTranslate-App
//
//  Created by Даниил on 13/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

protocol AppCollectionDataSourceChange : class {
    func dataSourceChanged(from oldDataSource: AppCollectionDataSource?, to newDatasource: AppCollectionDataSource?)
}

class AppCollectionDataSource : CustomStringConvertible {
    
    /// Массив содержит все модели переводов
    public private(set) var rawModels: [RJTApplicationModel]
    
    /// Массив содержит модели переводов, приложения которых установлены на устройстве.
    public private(set) var installed : [RJTApplicationModel] = []
    
    /// Массив содержит модели переводов, приложения которых НЕ установлены на устройстве.
    public private(set) var uninstalled : [RJTApplicationModel] = []
    
    /// Выполняет инициализацию и разделение моделей в датасорсе.
    ///
    /// - Parameter models:  Модели для датасорса.
    public init(models: [RJTApplicationModel]) {
        self.rawModels = models
        
        for model in models {
            if model.appInstalled {
                self.installed.append(model)
            } else {
                self.uninstalled.append(model)
            }
        }
        
    }
    
    public var description: String {
        return String(format: "<%@; installed %@; uninstalled %@>",
                      classInfo(of: self), self.installed, self.uninstalled)
    }
}
