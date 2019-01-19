//
//  FeaturedController.swift
//  RJTranslate-App
//
//  Created by Даниил on 19/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation
import UIKit

class FeaturedController: UIViewController, SearchControllerDelegate {
    
    private var searchController: SearchControllerRequired?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Translations.Search.Title", comment: "")
        
        if #available(iOS 11.0, *) {
            self.searchController = ModernSearchController(delegate: self)
            self.navigationItem.searchController = self.searchController as! ModernSearchController
        }
    }
}
