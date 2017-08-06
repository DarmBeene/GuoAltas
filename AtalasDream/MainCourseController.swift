//
//  BaseCourseController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/7/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

import UIKit
import WebKit

private let footerIdentifier = "footerIdentifier"
private let searchButtonColor = UIColor(r: 231, g: 231, b: 231, alpha: 1)

class MainCourseController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let reuseIdentifier = "Cell"
    var courses = [Course]()
    var currentPage = 0
    let NumberOfEachPage = 15
    var isEnd = false
    var refreshControll: UIRefreshControl?
    var courseReference: FIRDatabaseReference?
    var studyType: String?
    
    lazy var infoView: InfoView = {
        let view = InfoView(frame: .zero)
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        return view
    }()
    
    lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(type: .system)
        button.addTarget(self, action: #selector(pop), for: .touchUpInside)
        return button
    }()
    
//    lazy var shareButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
//        button.setTitle("分享", for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
//        button.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
//        return button
//    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("搜索", for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        button.setImage(searchImage, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: 30)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.backgroundColor = searchButtonColor
        button.tintColor = .gray
        button.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.register(CourseCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.register(FooterCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = GlobalConstants.CollectionViewBGC
//        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        setupNaviBarAndViews()
        loadCourses()
    }
    
    //MARK: ui
    func setupNaviBarAndViews() {
        setupTitle()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        refreshControll = UIRefreshControl()
        collectionView?.addSubview(refreshControll!)
        refreshControll?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        self.view.addSubview(infoView)
        infoView.center = self.view.center
        infoView.alpha = 0
    }
    func setupTitle() {
        navigationItem.titleView = searchButton
    }

    /**
     1. only load NumberOfEachPage = 15 courses at first.
     2. swipe down to load more courses(needed to implement later)
     */
    func loadCourses() {
        guard let courseReference = courseReference else { return }
        
        let courseQuery = courseReference.queryOrderedByKey().queryLimited(toLast: UInt(NumberOfEachPage))
        
        courseQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() {
                let loadedCourses = snapshot.children.map { Course(snapshot: $0 as! FIRDataSnapshot)}
                self.courses = Array(loadedCourses.reversed())
                
                if self.courses.count < self.NumberOfEachPage {
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
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let course = courses[indexPath.item]
        let courseWebController = CourseWebController()
        courseWebController.course = course
        navigationController?.pushViewController(courseWebController, animated: true)
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CourseCell
        
        let course = courses[indexPath.item]
        cell.course = course
        if let text = course.courseDescription {
            let lines = estimatedLines(text: text)
            cell.descriptionHeightConstraint?.isActive = false
            cell.descriptionHeightConstraint?.constant = CourseConstants.LabelHeight * lines
            cell.descriptionHeightConstraint?.isActive = true
        }
        
        return cell
    }
    // helper method
    func estimatedLines(text: String) -> CGFloat {
        let width = self.view.frame.width - 70
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: CourseConstants.DescriptionLabelFontSize)]
        let height = text.height(withWidth: width, attributes: attributes)
        let lines = ceil(height / CourseConstants.LabelHeight)
        return lines + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let course = courses[indexPath.item]
        if let text = course.courseDescription {
            let lines = estimatedLines(text: text)
            return CGSize(width: view.frame.width, height: 120 + lines * CourseConstants.LabelHeight)
        }
        return CGSize(width: view.frame.width, height: 210)
    }
    
    //MARK: supplementary view , footer related methods
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isEnd && scrollView.frame.size.height <= scrollView.contentSize.height{ // check isEnd first
            if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
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
                let keyValue = self.courses.last?.courseKey
                let courseQuery = courseReference?.queryOrderedByKey().queryEnding(atValue: keyValue).queryLimited(toLast: UInt(NumberOfEachPage + 1))
                
                courseQuery?.observeSingleEvent(of: .value, with: { (snapshot) in
                    var loadedCourses = [Course]()
                    if snapshot.hasChildren() {
                        for item in snapshot.children {
                            let course = Course(snapshot: item as! FIRDataSnapshot)
                            loadedCourses.insert(course, at: 0)
                        }
                        if loadedCourses.count == 1 {
                            self.isEnd = true
                            view.alpha = 0
                            return
                        }
                        loadedCourses.removeFirst()
                        self.courses.append(contentsOf: loadedCourses)
                        let indexPaths = (0...loadedCourses.count - 1).map { IndexPath(item: $0 + self.currentPage * self.NumberOfEachPage, section: 0) }
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
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! FooterCell
        
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
    
    //MARK: button methods
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    func handleShare() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            self.showAlertPrompt(message: "请先登录，登陆后才可以分享")
            return
        }
        let naviController = UINavigationController(rootViewController: ShareCourseController())
        self.present(naviController, animated: true, completion: nil)
    }
    func handleSearch() {
        let scc = SearchCourseController()
        scc.courseReference = courseReference
        scc.studyType = studyType
        let naviController = UINavigationController(rootViewController: scc)
        self.present(naviController, animated: false, completion: nil)
    }
    func handleRefresh() {
        loadCourses()
        refreshControll?.endRefreshing()
    }
}
