//
//  PublishServiceController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/28/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

private let cellIdentifier = "cellIdentifier"
class MainPublishController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var services = ServiceConstants.services

    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: GlobalConstants.ButtonFontSize)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(ServiceCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.backgroundColor = GlobalConstants.CollectionViewBGC
        collectionView?.alwaysBounceVertical = true
        
        setupNaviBar()
    }
    
    func setupNaviBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.title = "选择发布类别"
    }
    func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var serviceName = ""
        if indexPath.item == 0 {
            serviceName = ServiceName.SecondHand
        }
        if indexPath.item == 1 {
            serviceName = ServiceName.RentHouse
        }
        if indexPath.item == 2 {
            serviceName = ServiceName.HoldActivity
        }
        if indexPath.item == 3 {
            serviceName = ServiceName.PartTimeJob
        }
        
        switch indexPath.item {
        case 0, 1, 3:
            let chooseServiceState = ChooseServiceStateController()
            chooseServiceState.serviceName = serviceName
            navigationController?.pushViewController(chooseServiceState, animated: true)
        case 2:
            let publishController = PublishServiceController()
            publishController.serviceName = serviceName
            navigationController?.pushViewController(publishController, animated: true)
        default:
            break
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ServiceCell
        let service = services[indexPath.item]
        cell.service = service
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/2 - 1, height: self.view.frame.width/2 - 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}









