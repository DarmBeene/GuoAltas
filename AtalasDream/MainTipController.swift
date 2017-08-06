//
//  MainTipController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/8/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class MainTipController: MainCourseController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ShowTipController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.course = courses[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CourseCell
        let course = courses[indexPath.item]
        cell.course = course
        
        if let content = course.courseDescription {
            let line1 = estimatedLines(text: content)
            let line2 = line1 >= 3 ? 3 : line1
            cell.descriptionHeightConstraint?.isActive = false
            cell.descriptionHeightConstraint?.constant = CourseConstants.LabelHeight * line2
            cell.descriptionHeightConstraint?.isActive = true
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let course = courses[indexPath.item]
        if let content = course.courseDescription {
//            let lines = estimatedLines(text: content)
            let line1 = estimatedLines(text: content)
            let line2 = line1 >= 3 ? 3 : line1
            return CGSize(width: view.frame.width, height: 120 + line2 * CourseConstants.LabelHeight)
        }
        return CGSize(width: view.frame.width, height: 210)
    }
    
    
}
