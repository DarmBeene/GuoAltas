//
//  MyPublishedEntertainController.swift
//  AtalasDream
//
//  Created by Gongbin Guo on 7/31/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

fileprivate let EntertainCellId = "EntertainCellId"
fileprivate let footerCellId = "footerIdentifier"
class MyPublishedEntertainController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var entertainments = [Entertainment]()
    
    let indicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .black
        ai.stopAnimating()
        return ai
    }()
    lazy var infoView: InfoView = {
        let view = InfoView(frame: .zero)
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = GlobalConstants.CollectionViewBGC
        collectionView?.register(EntertainCell.self, forCellWithReuseIdentifier: EntertainCellId)
        collectionView?.register(FooterCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerCellId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReload(notification:)), name: Notification.Name(NotificationNameConstants.ReloadMyEntertainNotification), object: nil)
        
        setupViewsAndNaviBar()
        loadEntertainments()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func handleReload(notification: Notification) {
        if let indexPath = notification.userInfo?[SettingsConstants.IndexPathIdentifier] as? IndexPath {
            self.entertainments.remove(at: indexPath.item)
            self.collectionView?.performBatchUpdates({ 
                self.collectionView?.deleteItems(at: [indexPath])
            }, completion: nil)
        }
    }
    
    func setupViewsAndNaviBar() {
        navigationItem.title = "我发布的工作信息"
        self.view.addSubview(indicator)
        indicator.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(infoView)
        infoView.center = self.view.center
        infoView.alpha = 0
    }
    
    func loadEntertainments() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            self.showAlertPrompt(message: "请先登录")
            return
        }
        
        indicator.startAnimating()
        entertainments.removeAll(keepingCapacity: false)
        FirDatabasePath.UserReference.child(uid).child(EntertainConstants.EntertainIdentifier).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String: String] {
                self.infoView.alpha = 0
                self.indicator.stopAnimating()
                for (entertainmentKey, town) in value {
                    let ref = FIRDatabase.database().reference(withPath: town).child(entertainmentKey)
                    ref.observeSingleEvent(of: .value, with: { (snap) in
                        let entertainment = Entertainment(snapshot: snap)
                        self.entertainments.append(entertainment)
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }, withCancel: nil)
                }
            }else{
                self.infoView.alpha = 1
                self.collectionView?.reloadData()
                self.indicator.stopAnimating()
            }
        }, withCancel: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let showMyEntertainController = ShowMyEntertainController()
        showMyEntertainController.entertainment = entertainments[indexPath.item]
        showMyEntertainController.indexPath = indexPath
        navigationController?.pushViewController(showMyEntertainController, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entertainments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EntertainCellId, for: indexPath) as! EntertainCell
        cell.entertainment = entertainments[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
