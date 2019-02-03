//
//  SimpleViewController.swift
//  RJTranslate-App
//
//  Created by Даниил on 29/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class SimpleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorScheme.default.background
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorScheme.default.statusBarStyle
    }
}
