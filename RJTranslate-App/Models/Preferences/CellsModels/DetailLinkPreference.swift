//
//  DetailLinkPreference.swift
//  RJTranslate-App
//
//  Created by Даниил on 10/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class DetailLinkPreference: Preference {
    override var category: Preference.Category {
        return .detailLink
    }
    
    private var detail: UIViewController.Type
    
    init(title: String, detail: UIViewController.Type) {
        self.detail = detail
        super.init(title: title)
    }
    
    func createController() -> UIViewController {
        return self.detail.init()
    }
}
