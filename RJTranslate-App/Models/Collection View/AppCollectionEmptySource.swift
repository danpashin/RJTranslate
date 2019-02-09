//
//  AppCollectionEmptySource.swift
//  RJTranslate-App
//
//  Created by Даниил on 13/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation
import DZNEmptyDataSet

enum EmptyViewType: Int {
    case loading
    case noSearchResults
    case noData
}

class AppCollectionEmptySource: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    private(set) weak var collectionView: AppCollectionView?
    
    var type: EmptyViewType = .loading
    
    init(collectionView: AppCollectionView) {
        super.init()
        
        self.collectionView = collectionView
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }
    
    // MARK: -
    // MARK: DZNEmptyDataSetSource
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var titleString = ""
        
        switch self.type {
        case .noSearchResults:
            titleString = NSLocalizedString("Search.Noresults.Title",
                                            comment: "This label shows when there are no results for the search")
        case .noData:
            titleString = NSLocalizedString("Translations.NoInstalled.Title", comment: "")
        default: break
        }
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.labelFontSize * 1.5, weight: .heavy),
            NSAttributedString.Key.foregroundColor: ColorScheme.default.titleLabel
        ]
        
        return NSAttributedString(string: titleString, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var descriptionString = ""
        
        switch self.type {
        case .noSearchResults:
            descriptionString = NSLocalizedString("Search.Noresults.Subtitle",
                                                  comment: "This shows when there're no results for the search.")
        case .noData:
            descriptionString = NSLocalizedString("Translations.NoInstalled.Subtitle", comment: "")
        case .loading:
            descriptionString = NSLocalizedString("loading_data...", comment: "")
        }
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title3),
            NSAttributedString.Key.foregroundColor: ColorScheme.default.subtitleLabel
        ]
        
        return NSAttributedString(string: descriptionString, attributes: attributes)
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 16.0
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return ColorScheme.default.backgroundWhite
    }
}
