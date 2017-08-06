//
//  MyFavoritesController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/9/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

private let cellId = "cellId"
class MyFavoritesController: MainTipController {
    
    override func setupTitle() {
        navigationItem.title = "我的收藏"
        NotificationCenter.default.addObserver(self, selector: #selector(handleReload(notification:)), name: Notification.Name(NotificationNameConstants.ReloadMyFavoritesNotification), object: nil)
    }
    func handleReload(notification: Notification) {
        loadCourses()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ShowMyFavoriteTipItemController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.course = courses[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func loadCourses() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            self.showAlertPrompt(message: "请先登录")
            return
        }
        
        self.courses.removeAll(keepingCapacity: false)
        courseReference = FirDatabasePath.UserReference.child(uid).child(SettingsConstants.favoriteCourseTip)
        let courseQuery = courseReference?.queryOrderedByKey().queryLimited(toLast: UInt(NumberOfEachPage))
        courseQuery?.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() {
                if let values = snapshot.value as? [String: [String]] {
                    self.currentPage = 1
                    self.infoView.alpha = 0
                    if values.count < self.NumberOfEachPage {
                        self.isEnd = true
                    }
                    for (key, paths) in values {
                        let ref = FIRDatabase.database().reference(withPath: paths[0]).child(paths[1]).child(StudyTypeIdentifier.CourseTip).child(key)
                        ref.observeSingleEvent(of: .value, with: { (snap) in
                            let course = Course(snapshot: snap)
                            self.courses.insert(course, at: 0)
                            DispatchQueue.main.async {
                                self.collectionView?.reloadData()
                            }
                        })
                    }
                }
            }else{
                self.infoView.alpha = 1
                self.collectionView?.reloadData()
                self.isEnd = true
                self.stopAnimating()
            }
        })
    }
    func stopAnimating() {
        let indexPath = IndexPath(item: 0, section: 0)
        if let footer = self.collectionView?.supplementaryView(forElementKind: UICollectionElementKindSectionFooter, at: indexPath) as? FooterCell {
            footer.indicator.stopAnimating()
        }
    }
    
    
}



