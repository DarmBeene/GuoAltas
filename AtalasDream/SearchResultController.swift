//
//  SearchResultController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/21/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

fileprivate let cellIdentifier = "cellIdentifier"
fileprivate let footerIdentifier = "footerIdentifier"

class SearchResultController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var courses = [Course]()
    var searchString: String?
    var courseReference: FIRDatabaseReference?
    var studyType: String?
    
    lazy var textField: UITextField = {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width - 30, height: 30)
        let tf = UITextField(frame: rect)
        tf.backgroundColor = CourseConstants.textFieldBackgroundColor
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
//        tf.addTarget(self, action: #selector(handleTextFieldEditingChange(textField:)), for: .editingChanged)
        tf.returnKeyType = .search
        let imageRect = CGRect(x: 0, y: 0, width: 15, height: 15)
        let imageView = UIImageView(frame: imageRect)
        imageView.image = UIImage(named: "search_icon")
        let imageWrapper = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageWrapper.addSubview(imageView)
        imageView.center = imageWrapper.center
        tf.leftView = imageWrapper
        tf.placeholder = "搜索"
        
        return tf
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
        self.view.backgroundColor = .white
        
        collectionView?.register(CourseCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView?.backgroundColor = GlobalConstants.CollectionViewBGC
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView?.alwaysBounceVertical = true
        
        setupNaviBar()
        
        if searchString != nil {
            textField.text = searchString
            loadCourses(searchText: searchString!)
        }
    }
    // the position of the titleView is not corrent!!!!!
    func setupNaviBar() {
        navigationItem.titleView = textField
        textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTextFieldTap)))
        
        let button = CustomBackButton(type: .system)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        self.view.addSubview(infoView)
        infoView.center = self.view.center
        infoView.alpha = 0
    }
    func handleTextFieldTap() {
        let shc = SearchHistoryController()
        shc.searchString = textField.text
        shc.delegate = self
        let naviController = UINavigationController(rootViewController: shc)
        self.present(naviController, animated: false, completion: nil)
    }

    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func loadCourses(searchText: String) {
        
        self.courses.removeAll(keepingCapacity: false)
        self.collectionView?.reloadData()
        
        indicator.startAnimating()
        
        guard let courseReference = courseReference else { return }
        
        let courseQuery = courseReference.queryOrdered(byChild: "name").queryStarting(atValue: "\(searchText.lowercased())").queryEnding(atValue: "\(searchText.lowercased())\u{f8ff}")
        
        courseQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() {
                let loadedCourses = snapshot.children.map { Course(snapshot: $0 as! FIRDataSnapshot) }
                self.courses = Array(loadedCourses.reversed())
                self.indicator.stopAnimating()
                DispatchQueue.main.async {
                    self.infoView.alpha = 0
                    self.collectionView?.reloadData()
                }
            }else{
                self.infoView.alpha = 1
                self.collectionView?.reloadData()
                self.indicator.stopAnimating()
            }
            
        }, withCancel: nil)
    }
    
    //MARK: collection view methods: these methods are the same with the ones in the MainCourseController
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let course = courses[indexPath.item]
        
        if studyType == StudyTypeIdentifier.CourseTip {
            let showTipController = ShowTipController(collectionViewLayout: UICollectionViewFlowLayout())
            showTipController.course = course
            navigationController?.pushViewController(showTipController, animated: true)
        }else{
            let courseWebController = CourseWebController()
            courseWebController.course = course
            navigationController?.pushViewController(courseWebController, animated: true)
        }
        
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CourseCell
        
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
    
    
}

extension SearchResultController: SearchHistoryControllerDelegate {
    func searchFor(text: String) {
        OperationQueue.main.addOperation {
            self.textField.text = text
        }
        loadCourses(searchText: text)
    }
}





