//
//  SearchResultsEmptySource.swift
//  RJTranslate-App
//
//  Created by Даниил on 30/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation
import DZNEmptyDataSet

class SearchResultsEmptySource: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    public weak var tableView: SearchResultsTableView? {
        didSet {
            self.tableView?.emptyDataSetSource = self
            self.tableView?.emptyDataSetDelegate = self
        }
    }
    
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let titleString = NSLocalizedString("Search.Noresults.Title", comment: "This label shows when there are no results for the search")
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.labelFontSize * 1.5, weight: .heavy),
            NSAttributedString.Key.foregroundColor: ColorScheme.default.titleLabel
        ]
        
        return NSAttributedString(string: titleString, attributes: attributes)
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let descriptionString = NSLocalizedString("Search.Noresults.Subtitle", comment: "This sublabel shows when there are no results for the search.")
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title3),
            NSAttributedString.Key.foregroundColor: ColorScheme.default.subtitleLabel
        ]
        
        return NSAttributedString(string: descriptionString, attributes: attributes)
    }
    
    public func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        if self.tableView?.isRefreshing ?? false {
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.startAnimating()
            return activityIndicator
        }
        
        return nil
    }
}
