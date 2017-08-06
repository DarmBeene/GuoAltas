//
//  MaiinLifeController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/27/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

private let cellIdeitifier = "cellIdeitifier"
class MainServiceController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    
    var services = ServiceConstants.services

    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        label.textAlignment = .left
        label.text = "选择所在州"
        label.textColor = self.view.tintColor
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.isUserInteractionEnabled = true
        return label
    }()
    let publishButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.setTitle("发布", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: GlobalConstants.ButtonFontSize)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(ServiceCell.self, forCellWithReuseIdentifier: cellIdeitifier)
        collectionView?.backgroundColor = GlobalConstants.CollectionViewBGC
        collectionView?.alwaysBounceVertical = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleChoose), name: Notification.Name(NotificationNameConstants.ChangeStateNotification), object: nil)
        
        setupNaviBarAndViews()
    }
    func handleChoose() {
        let chineseName = ServiceConstants.states[DeviceLocation.shared.state!]
        locationLabel.text = chineseName
    }
    
    func setupNaviBarAndViews() {
        if let state = UserDefaults.standard.object(forKey: UserDefaultsKey.State) as? String {
            let chineseName = ServiceConstants.states[state]
            locationLabel.text = chineseName
            DeviceLocation.shared.state = state
        }
        
        publishButton.addTarget(self, action: #selector(handlePublish), for: .touchUpInside)
        locationLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseState)))
        navigationItem.title = "选择类别浏览"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: locationLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: publishButton)
    }
    func chooseState() {
        let chooseController = UINavigationController(rootViewController: ChooseStateController())
        self.present(chooseController, animated: true, completion: nil)
    }
    func handlePublish() {
        if DeviceLocation.shared.state == nil {
            self.showAlertPrompt(message: "请先选择所在州")
            return
        }
        if FIRAuth.auth()?.currentUser?.uid == nil {
            self.showAlertPrompt(message: "请先登录以体验更多功能")
            return
        }
        let mainPublishController = MainPublishController(collectionViewLayout: UICollectionViewFlowLayout())
        let vc = UINavigationController(rootViewController: mainPublishController)
        self.present(vc, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if DeviceLocation.shared.state == nil {
            self.showAlertPrompt(message: "请先选择所在州")
            return
        }
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
        let viewService = ViewServiceSectionController(collectionViewLayout: UICollectionViewFlowLayout())
        viewService.serviceName = serviceName
//        viewService.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewService, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdeitifier, for: indexPath) as! ServiceCell
        let service = services[indexPath.item]
        cell.service = service
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/2 - 1, height: self.view.frame.width/2 - 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}


