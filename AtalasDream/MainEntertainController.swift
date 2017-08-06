//
//  MainEntertainController.swift
//  AtalasDream
//
//  Created by Gongbin Guo on 7/30/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

fileprivate let EntertainCellId = "EntertainCellId"
fileprivate let footerCellId = "footerIdentifier"
class MainEntertainController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var entertainments = [Entertainment]()
    var currentPage = 0
    let NumberOfEachPage = 15
    var isEnd = false
    var refreshControll: UIRefreshControl?
    
    lazy var townButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("选择所在城市", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: 30)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return button
    }()
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        return label
    }()
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
        collectionView?.register(EntertainCell.self, forCellWithReuseIdentifier: EntertainCellId)
        collectionView?.register(FooterCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerCellId)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleChooseTown(notification:)), name: Notification.Name(NotificationNameConstants.ChangeTownNotification), object: nil)
        
        setupViews()
        loadEntertainments()
    }
    func handleChooseTown(notification: Notification) {
        if let chosenTown = UserDefaults.standard.object(forKey: UserDefaultsKey.Town) as? String{
            townButton.setTitle(chosenTown, for: .normal)
            self.loadEntertainments()
        }
    }
    
    func setupViews() {
        if let town = UserDefaults.standard.object(forKey: UserDefaultsKey.Town) as? String{
            townButton.setTitle(town, for: .normal)
            DeviceLocation.shared.town = town
        }
        townButton.addTarget(self, action: #selector(chooseCity), for: .touchUpInside)
        publishButton.addTarget(self, action: #selector(handlePublish), for: .touchUpInside)
        
        navigationItem.titleView = townButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: publishButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emptyLabel)
        
        refreshControll = UIRefreshControl()
        collectionView?.addSubview(refreshControll!)
        refreshControll?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        self.view.addSubview(infoView)
        infoView.center = self.view.center
        infoView.alpha = 0
    }
    func handleRefresh() {
        loadEntertainments()
        self.refreshControll?.endRefreshing()
    }
    
    func chooseCity() {
        let vc = UINavigationController(rootViewController: ChooseTownController())
        self.present(vc, animated: true, completion: nil)
    }
    func handlePublish() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            self.showAlertPrompt(message: "请先登录以体验更多功能")
            return
        }
        if DeviceLocation.shared.town == nil {
            self.showAlertPrompt(message: "请先选择城市")
            return
        }
        
        let vc = UINavigationController(rootViewController: PublishEntertainController())
        self.present(vc, animated: true, completion: nil)
    }
    
    var ref: FIRDatabaseReference?
    func loadEntertainments() {
        self.entertainments.removeAll(keepingCapacity: false)
        
        if let town = UserDefaults.standard.object(forKey: UserDefaultsKey.Town) as? String {
            ref = FIRDatabase.database().reference(withPath: town)
            let entertainmentQuery = ref?.queryOrderedByKey().queryLimited(toLast: UInt(NumberOfEachPage))
            
            entertainmentQuery?.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChildren() {
                    let loadedEntertainments = snapshot.children.map { Entertainment(snapshot: $0 as! FIRDataSnapshot) }
                    self.entertainments = Array(loadedEntertainments.reversed())
                    
                    if self.entertainments.count < self.NumberOfEachPage {
                        self.isEnd = true
                    }
                    DispatchQueue.main.async {
                        self.infoView.alpha = 0
                        self.collectionView?.reloadData()
                        self.currentPage = 1
                    }
                }else{
                    self.collectionView?.reloadData()
                    self.infoView.alpha = 1
                    self.isEnd = true
                    self.stopFooterIndicator()
                }
            })
        }else{
            stopFooterIndicator()
        }
    }
    func stopFooterIndicator() {
        let indexPath = IndexPath(item: 0, section: 0)
        if let footer = self.collectionView?.supplementaryView(forElementKind: UICollectionElementKindSectionFooter, at: indexPath) as? FooterCell {
            footer.indicator.stopAnimating()
        }
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let showEntertainController = ShowEntertainController()
        showEntertainController.entertainment = entertainments[indexPath.item]
        showEntertainController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(showEntertainController, animated: true)
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
                let keyValue = self.entertainments.last?.entertainmentKey
                let entertainmentQuery = ref?.queryOrderedByKey().queryEnding(atValue: keyValue).queryLimited(toLast: UInt(NumberOfEachPage + 1))
                
                entertainmentQuery?.observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChildren() {
                        
                        var loadedEntertainments = snapshot.children.map { Entertainment(snapshot: $0 as! FIRDataSnapshot) }
                        loadedEntertainments = Array(loadedEntertainments.reversed())
                        
                        if loadedEntertainments.count == 1 {
                            self.isEnd = true
                            view.alpha = 0
                            return
                        }
                        
                        loadedEntertainments.removeFirst()
                        self.entertainments.append(contentsOf: loadedEntertainments)
                        let indexPaths = (0...loadedEntertainments.count - 1).map { IndexPath(item: $0 + self.currentPage * self.NumberOfEachPage, section: 0) }
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
        
//        let town = UserDefaults.standard.object(forKey: UserDefaultsKey.Town) as? String
        
        if DeviceLocation.shared.town != nil && !isEnd {
            footer.indicator.startAnimating()
        }else{
            footer.indicator.stopAnimating()
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
