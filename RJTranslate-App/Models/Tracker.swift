//
//  Tracker.swift
//  RJTranslate-App
//
//  Created by Даниил on 01/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import Firebase

class Tracker {
    
    func trackSearchEvent(_ event: String) {
        if event.count == 0 {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            Analytics.logEvent(AnalyticsEventSearch, parameters: [AnalyticsParameterSearchTerm: event])
        }
    }
    
    func trackSelectTranslation(name: String) {
        if name.count == 0 {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [AnalyticsParameterItemName: name])
        }
    }
    
}
