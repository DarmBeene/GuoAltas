//
//  MainJobConroller.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/23/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

fileprivate let jobCellId = "jobIdentifier"
fileprivate let footerCellId = "footerIdentifier"
class MainJobController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var jobs = [Job]()
    let totalPages = 10
    var currentPage = 0
    let NumberOfEachPage = 15
    var isEnd = false
    var refreshControll: UIRefreshControl?
    
    let publishButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.setTitle("发布", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: GlobalConstants.ButtonFontSize)
        return button
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
//        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        setupViewsAndNaviBar()
        loadJobs()
    }
    
    func setupViewsAndNaviBar() {
        refreshControll = UIRefreshControl()
        collectionView?.addSubview(refreshControll!)
        //        collectionView?.refreshControl = refreshControll
        refreshControll?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        navigationItem.title = "工作信息"
        publishButton.addTarget(self, action: #selector(handlePublish), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: publishButton)
        
        self.view.addSubview(infoView)
        infoView.center = self.view.center
        infoView.alpha = 0
    }
    func handleRefresh() {
        loadJobs()
        self.refreshControll?.endRefreshing()
    }
    func handlePublish() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            self.showAlertPrompt(message: "请先登录，登陆后才可以发布工作信息")
            return
        }
        let naviController = UINavigationController(rootViewController: PublishJobController())
        self.present(naviController, animated: true, completion: nil)
    }
    
    func loadJobs() {
        let ref = FirDatabasePath.JobReference
        let jobQuery = ref.queryOrderedByKey().queryLimited(toLast: UInt(NumberOfEachPage))
        
        jobQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() {
                let loadedJobs = snapshot.children.map { Job(snapshot: $0 as! FIRDataSnapshot) }
                self.jobs = Array(loadedJobs.reversed())
                
                if self.jobs.count < self.NumberOfEachPage {
                    self.isEnd = true
                }
                DispatchQueue.main.async {
                    self.infoView.alpha = 0
                    self.collectionView?.reloadData()
                    self.currentPage = 1
                }
            }else{
                self.infoView.alpha = 1
                self.isEnd = true
                let indexPath = IndexPath(item: 0, section: 0)
                if let footer = self.collectionView?.supplementaryView(forElementKind: UICollectionElementKindSectionFooter, at: indexPath) as? FooterCell {
                    footer.indicator.stopAnimating()
                }
            }
            
        }, withCancel: nil)
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let job = jobs[indexPath.item]
        let showJobController = ShowJobController(collectionViewLayout: UICollectionViewFlowLayout())
        showJobController.job = job
        showJobController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(showJobController, animated: true)
        
    }
    
    //MARK: supplementary view , footer related methods
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isEnd && scrollView.frame.size.height <= scrollView.contentSize.height{ // check isEnd first
            if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
                let indexPath = IndexPath(item: 0, section: 0)
                if let footer = collectionView?.supplementaryView(forElementKind: UICollectionElementKindSectionFooter, at: indexPath) as? FooterCell {
                    footer.indicator.startAnimating()
                    footer.alpha = 0
                    UIView.animate(withDuration: 2, animations: {
                        footer.alpha = 1
                    }, completion: { (completed) in
                        footer.alpha = 0
                    })
                }
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if !isEnd {
            if currentPage > 0 {
                let ref = FirDatabasePath.JobReference
                let keyValue = self.jobs.last?.jobKey
                let jobQuery = ref.queryOrderedByKey().queryEnding(atValue: keyValue).queryLimited(toLast: UInt(NumberOfEachPage + 1))

                jobQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                    var loadedJobs = [Job]()
                    if snapshot.hasChildren() {
                        for item in snapshot.children {
                            let job = Job(snapshot: item as! FIRDataSnapshot)
                            loadedJobs.insert(job, at: 0)
                        }
                        if loadedJobs.count == 1 {
                            self.isEnd = true
                            view.alpha = 0
                            return
                        }
                        
                        loadedJobs.removeFirst()
                        self.jobs.append(contentsOf: loadedJobs)
                        let indexPaths = (0...loadedJobs.count - 1).map { IndexPath(item: $0 + self.currentPage * self.NumberOfEachPage, section: 0) }
                        DispatchQueue.main.async {
                            self.collectionView?.insertItems(at: indexPaths)
                            self.currentPage += 1
                        }
                    }
                }, withCancel: nil)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerCellId, for: indexPath) as! FooterCell
        
        if isEnd {
            footer.indicator.stopAnimating()
        }else{
            footer.indicator.startAnimating()
        }
        
        return footer
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 35)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}




