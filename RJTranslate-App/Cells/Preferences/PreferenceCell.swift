//
//  PreferenceCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 10/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class PreferenceCell: UITableViewCell {
    
    private var _model: Preference
    var model: Preference {
        return _model
    }
    
    init(model: Preference, reuseIdentifier: String?, style: UITableViewCell.CellStyle = .default) {
        self._model = model
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
