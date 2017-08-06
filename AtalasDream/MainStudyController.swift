//
//  MainStudyController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/5/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

private let cellID = "cellID"
class MainStudyController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var buttonHeight: CGFloat = 40
    var studyTypes = ["课件", "Lab/Project", "往年考试/心得"]
    var studyTypeImages = ["course_icon", "labProject_icon", "studyTip_icon"]
    
    let uniInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        return label
    }()
    lazy var universityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("选择学校", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setImage(UIImage(named: "university_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(selectUniversity), for: .touchUpInside)
        return button
    }()
    lazy var departmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("选择院系", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setImage(UIImage(named: "department_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(selectDepartment), for: .touchUpInside)
        return button
    }()
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("分享", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setImage(UIImage(named: "share_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(StudyTypeCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.backgroundColor = GlobalConstants.CollectionViewBGC
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: buttonHeight, left: 0, bottom: 0, right: 0)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupNaviBar()
        addButtons()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUniInfo()
    }
    func setupNaviBar() {
        navigationItem.titleView = uniInfoLabel
        let height = navigationController?.navigationBar.frame.height
        uniInfoLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: height!)

        updateUniInfo()
    }
    
    func updateUniInfo() {
        if let universityName = UserDefaults.standard.object(forKey: UserDefaultsKey.UniversityName) as? String,
            let departmentName = UserDefaults.standard.object(forKey: UserDefaultsKey.MyDepartment) as? String {
            uniInfoLabel.text = "\(universityName) \n \(departmentName)"
        } else{
            uniInfoLabel.text = "学习分享"
        }
    }
    //MARK: button methods
    func addButtons() {
        let stack = UIStackView(arrangedSubviews: [universityButton, departmentButton, shareButton])
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 1
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stack)
        stack.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        stack.heightAnchor.constraint(equalToConstant: buttonHeight - 1).isActive = true
    }
    
    func selectUniversity() {
        let vc = UINavigationController(rootViewController: SelectTownController())
        self.present(vc, animated: true, completion: nil)
    }
    func selectDepartment() {
        if let universityData = UserDefaults.standard.object(forKey: UserDefaultsKey.MyUniversity) as? Data,
            let university = NSKeyedUnarchiver.unarchiveObject(with: universityData) as? University {
            
            let vc = ChangeDepartmentController()
            vc.university = university
            let navi = UINavigationController(rootViewController: vc)
            
            self.present(navi, animated: true, completion: nil)
        }else{
            self.showAlertPrompt(message: "请先选择学校")
            return
        }
    }
    func handleShare() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            self.showAlertPrompt(message: "请先登录，登陆后才可以分享")
            return
        }
        if UserDefaults.standard.object(forKey: UserDefaultsKey.MyUniversity) == nil {
            self.showAlertPrompt(message: "请先选择学校信息")
            return
        }
        if UserDefaults.standard.object(forKey: UserDefaultsKey.MyDepartment) == nil {
            self.showAlertPrompt(message: "请先选择学校院系信息")
            return
        }
        let vc = UINavigationController(rootViewController: ChooseShareTypeController())
        self.present(vc, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let universityName = UserDefaults.standard.object(forKey: UserDefaultsKey.UniversityName) as? String,
            let departmentName = UserDefaults.standard.object(forKey: UserDefaultsKey.MyDepartment) as? String else {
                self.showAlertPrompt(message: "请先选择学校信息")
                return
        }

        switch indexPath.item {
        case 0:
            let courseReference = FIRDatabase.database().reference(withPath: universityName).child(departmentName).child(StudyTypeIdentifier.Course)
            let vc = MainCourseController(collectionViewLayout: UICollectionViewFlowLayout())
            vc.courseReference = courseReference
            vc.studyType = StudyTypeIdentifier.Course
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let courseReference = FIRDatabase.database().reference(withPath: universityName).child(departmentName).child(StudyTypeIdentifier.LabProject)
            let vc = MainCourseController(collectionViewLayout: UICollectionViewFlowLayout())
            vc.courseReference = courseReference
            vc.studyType = StudyTypeIdentifier.LabProject
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let courseReference = FIRDatabase.database().reference(withPath: universityName).child(departmentName).child(StudyTypeIdentifier.CourseTip)
            let vc = MainTipController(collectionViewLayout: UICollectionViewFlowLayout())
            vc.courseReference = courseReference
            vc.studyType = StudyTypeIdentifier.CourseTip
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! StudyTypeCell
        cell.titleLabel.text = studyTypes[indexPath.item]
        cell.imageView.image = UIImage(named: studyTypeImages[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.view.frame.height - self.tabBarController!.tabBar.frame.height - UIApplication.shared.statusBarFrame.height - buttonHeight
        return CGSize(width: self.view.frame.width, height: height / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
}

extension MainStudyController: UINavigationControllerDelegate {
    
}


