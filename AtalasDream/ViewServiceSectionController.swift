//
//  BaseSectionController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/3/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

fileprivate let cellIdentifier = "cellIdentifier"
class ViewServiceSectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var serviceName: String?
    var sectionItems = [Service]()
    var refreshControll: UIRefreshControl?
    
    let backButton: CustomBackButton = {
        let button = CustomBackButton(type: .system)
        return button
    }()
    lazy var infoView: InfoView = {
        let view = InfoView(frame: .zero)
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        return view
    }()
    let indicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .black
        ai.stopAnimating()
        return ai
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(SectionItemCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.backgroundColor = GlobalConstants.CollectionViewBGC
        collectionView?.alwaysBounceVertical = true
        
        setupNaviBarTitle()
        setupNaviBar()
        loadServices()

        self.view.addSubview(indicator)
        indicator.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(infoView)
        infoView.center = self.view.center
        infoView.alpha = 0
        
    }
    
    func setupNaviBarTitle() {
        if let serviceName = serviceName {
            if serviceName == ServiceName.SecondHand {
                navigationItem.title = "二手信息"
            }
            if serviceName == ServiceName.RentHouse {
                navigationItem.title = "房屋信息"
            }
            if serviceName == ServiceName.HoldActivity {
                navigationItem.title = "活动信息"
            }
            if serviceName == ServiceName.PartTimeJob {
                navigationItem.title = "兼职信息"
            }
        }
    }
    func setupNaviBar() {
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        refreshControll = UIRefreshControl()
        collectionView?.addSubview(refreshControll!)
        refreshControll?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    func handleRefresh() {
        loadServices()
        self.refreshControll?.endRefreshing()
    }
    
    func loadServices() {
        guard let location = DeviceLocation.shared.state else {
            self.showAlertPrompt(message: "请先选择所在州")
            return
        }
        indicator.startAnimating()
        sectionItems.removeAll(keepingCapacity: false)

        if let serviceName = serviceName {
            FIRDatabase.database().reference(withPath: serviceName).child(location).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChildren() {
                    let loadedServices = snapshot.children.map { Service(snapshot: $0 as! FIRDataSnapshot) }
                    self.sectionItems = Array(loadedServices.reversed())
                    self.infoView.alpha = 0
                    self.indicator.stopAnimating()
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }else{
                    self.infoView.alpha = 1
                    self.collectionView?.reloadData()
                    self.indicator.stopAnimating()
                }
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sectionItems[indexPath.item]
        let vc = BaseServiceItemController()
        vc.service = item
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionItems.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SectionItemCell
        cell.service = sectionItems[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 45)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
