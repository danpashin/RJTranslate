//
//  AppCollectionEmptySource.swift
//  RJTranslate-App
//
//  Created by Даниил on 13/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation
import DZNEmptyDataSet

@objc class AppCollectionEmptySource: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, GradientImageRendererDelegate {
    
    @objc public private(set) weak var collectionView: RJTAppCollectionView?
    
    @objc public var type: EmptyViewType = .loading
    
    private var imageRenderer: GradientImageRenderer
    
    private var shouldReloadAfterRendering = false {
        didSet {
            if shouldReloadAfterRendering && !self.imageRenderer.isRendering {
                self.imageRenderer.renderAllImages()
            }
        }
    }
    
    @objc public init(collectionView: RJTAppCollectionView) {
        let buttonSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(44.0))
        self.imageRenderer = GradientImageRenderer(size: buttonSize);
        
        super.init()
        
        self.imageRenderer.delegate = self
        
        self.collectionView = collectionView
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }
    
    
    // MARK: -
    // MARK: GradientImageRendererDelegate
    
    public func renderer(_ renderer: GradientImageRenderer, didEndRenderingNormalImage normalImage: UIImage?, selectedImage: UIImage?) {
        
        if self.shouldReloadAfterRendering {
            if normalImage == nil || selectedImage == nil {
                return
            }
            
            self.collectionView?.reloadEmptyDataSet()
        }
    }
    
    // MARK: -
    
    
    // MARK: DZNEmptyDataSetSource
    
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if self.type == .noData {
            return UIImage(named: "translationIcon")
        }
        
        return nil
    }
    
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var titleString = ""
        
        switch self.type {
        case .noSearchResults:
            titleString = NSLocalizedString("cannot_find_any_results", comment: "")
            break
        case .noData:
            titleString = NSLocalizedString("no_translations_downloaded", comment: "")
            break
        default: break
        }
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(UIFont.labelFontSize * 1.5)),
            NSAttributedString.Key.foregroundColor: ColorScheme.default.headerLabelColor
        ]
        
        return NSAttributedString(string: titleString, attributes: attributes)
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var descriptionString = ""
        
        switch self.type {
        case .noSearchResults:
            descriptionString = NSLocalizedString("change_search_request_and_try_again", comment: "")
            break
        case .noData:
            descriptionString = NSLocalizedString("tap_button_to_download_available", comment: "")
            break
        case .loading:
            descriptionString = NSLocalizedString("loading_data...", comment: "")
            break
        }
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.labelFontSize),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        
        return NSAttributedString(string: descriptionString, attributes: attributes)
    }
    
    public func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        if self.type != .noData {
            return nil
        }
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title3),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let title = NSLocalizedString("download", comment: "")
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    public func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> UIImage! {
        let image = (state == .normal) ? self.imageRenderer.normalImage : self.imageRenderer.selectedImage
        if image == nil {
            self.shouldReloadAfterRendering = true
        }
        
        return image
    }
    
    public func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return CGFloat(16.0)
    }
    
    
    // MARK: -
    // MARK: DZNEmptyDataSetDelegate
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        if self.type == .noData {
            self.collectionView?.customDelegate?.collectionViewRequestedDownloadingTranslations(self.collectionView!)
        }
    }
}
