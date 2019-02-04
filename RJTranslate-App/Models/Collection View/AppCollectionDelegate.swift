//
//  AppCollectionDelegate.swift
//  RJTranslate-App
//
//  Created by Даниил on 17/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class AppCollectionDelegate : NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private(set) var collectionView: AppCollectionView?
    
    init(collectionView: AppCollectionView) {
        self.collectionView = collectionView
        
        super.init()
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        collectionView.register(CollectionHeaderLabel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, 
                                withReuseIdentifier: "header")
        
    }
    
    private func update(appCell: AppCollectionCell, selected: Bool) {
        appCell.updateSelection(selected, animated: true)
        if appCell.model != nil {
            appCell.model!.enableTranslation = selected
            self.collectionView?.customDelegate?.collectionView(self.collectionView!, didUpdateModel: appCell.model!)
        }
        
        DispatchQueue.main.async {
            let selectionGenerator = UISelectionFeedbackGenerator()
            selectionGenerator.prepare()
            selectionGenerator.selectionChanged()
        }
    }
    
    
    // MARK: -
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = self.collectionView?.model
        
        switch section {
        case 0:
            return model?.currentDataSource?.installed.count ?? 0
        case 1:
            return model?.currentDataSource?.uninstalled.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "appCell", for: indexPath) as! AppCollectionCell
        
        let collectionModel = self.collectionView?.model
        if indexPath.section == 0 {
            cell.model = collectionModel?.currentDataSource?.installed[indexPath.row]
        } else {
            cell.model = collectionModel?.currentDataSource?.uninstalled[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, 
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: "header", 
                                                                         for: indexPath) as! CollectionHeaderLabel
        
        if indexPath.section == 0 {
            headerView.text = NSLocalizedString("installed", comment: "")
        }
        
        return headerView
    }
    
    
    // MARK: -
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, 
                        forItemAt indexPath: IndexPath) {
        guard let appCell = cell as? AppCollectionCell else { return }
        if appCell.model?.enableTranslation ?? false {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            appCell.updateSelection(true, animated: false)
            appCell.isSelected = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        if let appCell = cell as? AppCollectionCell {
            self.update(appCell: appCell, selected: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        if let appCell = cell as? AppCollectionCell {
            self.update(appCell: appCell, selected: false)
        }
    }
    
    
    // MARK: -
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, 
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let dataSource = self.collectionView?.model?.currentDataSource
        
        if section == 0 && dataSource?.installed.count ?? 0 > 0 {
            return CGSize(width: collectionView.frame.width, height: 52.0)
        }
        
        if section == 1 && dataSource?.installed.count ?? 0 > 0 && dataSource?.uninstalled.count ?? 0 > 0 {
            return CGSize(width: collectionView.frame.width, height: 16.0)
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, 
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let dataSource = self.collectionView?.model?.currentDataSource
        if (section == 0 && dataSource?.installed.count ?? 0 > 0) || section == 1 {
            return UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        } else if section == 1 || section == 2 {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, 
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: collectionView.frame.width - 24.0, height: AppCollectionCell.defaultHeight)
        
        return size
    }
}

