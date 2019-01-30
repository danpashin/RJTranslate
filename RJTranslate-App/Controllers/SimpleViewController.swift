//
//  SimpleViewController.swift
//  RJTranslate-App
//
//  Created by Даниил on 29/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public class SimpleViewController: UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorScheme.default.background
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorScheme.default.statusBarStyle
    }
}
