//
//  AppCollectionDelegate.swift
//  RJTranslate-App
//
//  Created by Даниил on 17/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class AppCollectionDelegate: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private(set) weak var collectionView: AppCollectionView?
    
    var model: AppCollectionModel!
    
    init(collectionView: AppCollectionView, model: AppCollectionModel) {
        self.collectionView = collectionView
        self.model = model
        
        super.init()
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        collectionView.register(CollectionHeaderLabel.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        
        collectionView.register(AppCollectionCell.self, forCellWithReuseIdentifier: "appCell")
        
    }
    
    deinit {
        self.model = nil
    }
    
    private func update(appCell: AppCollectionCell, selected: Bool) {
        appCell.updateSelection(selected, animated: true)
        if appCell.model != nil {
            appCell.model!.enable = selected
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.currentDataSource.numberOfModelsFor(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "appCell",
                                                          for: indexPath) as! AppCollectionCell
            
            let collectionModel = self.collectionView?.model
            cell.model = collectionModel?.currentDataSource.modelFor(indexPath: indexPath)
            
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: "header",
                                                                         for: indexPath) as! CollectionHeaderLabel
        #if DEBUG
        headerView.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        #endif
        
        if indexPath.section == 0 {
            headerView.text = NSLocalizedString("Translations.Updates.Title", comment: "")
        } else if indexPath.section == 1 {
            headerView.text = NSLocalizedString("Translations.Installed.Title", comment: "")
        }
        
        return headerView
    }
    
    // MARK: -
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let appCell = cell as? AppCollectionCell else { return }
        if appCell.model?.enable ?? false {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            appCell.updateSelection(true, animated: false)
            appCell.isSelected = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AppCollectionCell
        self.update(appCell: cell, selected: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AppCollectionCell
        self.update(appCell: cell, selected: false)
    }
    
    // MARK: -
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let dataSource = self.model.currentDataSource
        
        if section == 0 && dataSource.updatableModels.count > 0 {
            return CGSize(width: collectionView.frame.width, height: 32.0)
        }
        
        if section == 1 && dataSource.installed.count > 0 {
            return CGSize(width: collectionView.frame.width, height: 32.0)
        }
        
        if section == 2 && dataSource.installed.count > 0 && dataSource.uninstalled.count > 0 {
            return CGSize(width: collectionView.frame.width, height: 16.0)
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let prevSectionNumber = self.model.currentDataSource.numberOfModelsFor(section: section - 1)
        var fromTop: CGFloat = prevSectionNumber > 0 ? 10.0 : 0.0
        if section == 0 { fromTop = 10.0 }
        
        return UIEdgeInsets(top: fromTop, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 24.0, height: AppCollectionCell.defaultHeight)
    }
}
