//
//  FeaturedController.swift
//  RJTranslate-App
//
//  Created by Даниил on 19/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation
import UIKit

class FeaturedController: LiveSearchResultsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorScheme.default.background
        self.title = NSLocalizedString("Translations.Featured.Title", comment: "")
    }
}
