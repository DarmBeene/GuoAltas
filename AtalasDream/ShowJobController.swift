//
//  ShowJobController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/26/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

private let titleCellIdentifier = "titleCell"
private let companyCellIdentifier = "companyCellIdentifier"
private let detailIdentifier = "detailIdentifier"

class ShowJobController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var job: Job?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBarAndViews()
        setupRightBarButton()
    }
    
    func setupNaviBarAndViews() {
        self.collectionView?.backgroundColor = GlobalConstants.CollectionViewBGC
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(JobTitleCell.self, forCellWithReuseIdentifier: titleCellIdentifier)
        collectionView?.register(JobCompanyCell.self, forCellWithReuseIdentifier: companyCellIdentifier)
        collectionView?.register(JobDetailCell.self, forCellWithReuseIdentifier: detailIdentifier)
    }
    func setupRightBarButton() {
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCellIdentifier, for: indexPath) as! JobTitleCell
            cell.job = job
            return cell
        }else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: companyCellIdentifier, for: indexPath) as! JobCompanyCell
            cell.job = job
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailIdentifier, for: indexPath) as! JobDetailCell
            cell.job = job
            
            if let companyDescription = job?.companyDescription {
                cell.companyHeightAnchor?.isActive = false
                cell.companyHeightAnchor?.constant = estimatedHeight(forText: companyDescription)
                cell.companyHeightAnchor?.isActive = true
            }
            if let position = job?.positionDescription {
                cell.positionHeightAnchor?.isActive = false
                cell.positionHeightAnchor?.constant = estimatedHeight(forText: position)
                cell.positionHeightAnchor?.isActive = true
            }
            if let requirement = job?.requirement {
                cell.requirementHeightAnchor?.isActive = false
                cell.requirementHeightAnchor?.constant = estimatedHeight(forText: requirement)
                cell.requirementHeightAnchor?.isActive = true
            }
            return cell
        }
    }
    
    // helper method
    func estimatedHeight(forText: String) -> CGFloat {
        let width = self.view.frame.width - 40
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: JobConstant.TextViewFontSize)]
        return forText.height(withWidth: width, attributes: attributes) + 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: self.view.frame.width, height: 0)
        switch indexPath.item {
        case 0:
            size.height = 65
        case 1:
            size.height = 115
        case 2:
            if let companyDescription = job?.companyDescription {
                size.height += estimatedHeight(forText: companyDescription)
            }
            if let position = job?.positionDescription {
                size.height += estimatedHeight(forText: position)
            }
            if let requirement = job?.requirement {
                size.height += estimatedHeight(forText: requirement)
            }
            size.height += 120
            
        default:
            break;
        }
        return size
    }
    
    
    
}

