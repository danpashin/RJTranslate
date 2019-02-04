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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.title = NSLocalizedString("Translations.Featured.Title", comment: "")
        self.navigationController?.tabBarItem.title = self.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
