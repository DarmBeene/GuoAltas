//
//  PublishedJobController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/12/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

fileprivate let jobCellId = "jobIdentifier"
fileprivate let footerCellId = "footerIdentifier"

class MyPublishedJobController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var jobs = [Job]()
    
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
        collectionView?.register(JobCell.self, forCellWithReuseIdentifier: jobCellId)
        collectionView?.register(FooterCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerCellId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReload), name: Notification.Name(NotificationNameConstants.ReloadMyJobNotification), object: nil)
        
        setupViewsAndNaviBar()
        loadJobs()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func handleReload(notification: Notification) {
        if let indexPath = notification.userInfo?[SettingsConstants.IndexPathIdentifier] as? IndexPath {
            self.jobs.remove(at: indexPath.item)
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
    //
    
    func loadJobs() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            self.showAlertPrompt(message: "请先登录")
            return
        }
        
        indicator.startAnimating()
        jobs.removeAll(keepingCapacity: false)
        FirDatabasePath.UserReference.child(uid).child(JobConstant.JobIdentifier).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String: String] {
                self.infoView.alpha = 0
                self.indicator.stopAnimating()
                for (serviceKey, _) in value {
                    let ref = FirDatabasePath.JobReference.child(serviceKey)
                    ref.observeSingleEvent(of: .value, with: { (snap) in
                        let job = Job(snapshot: snap)
                        self.jobs.append(job)
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
    // implement this later
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let showMyJobController = ShowMyJobController(collectionViewLayout: UICollectionViewFlowLayout())
        showMyJobController.job = jobs[indexPath.item]
        showMyJobController.indexPath = indexPath
        navigationController?.pushViewController(showMyJobController, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobs.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: jobCellId, for: indexPath) as! JobCell
        cell.job = jobs[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
    
}
