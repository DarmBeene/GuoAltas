//
//  HelpController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/19/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class CourseHelpController: UIPageViewController {
    
    var imagesNames = ["step1&2", "step3", "step4", "step5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        let imageViewController = ImageViewController()
        imageViewController.index = 0
        imageViewController.image = UIImage(named: imagesNames[0])
        
        setViewControllers([imageViewController], direction: .forward, animated: true, completion: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(handleDismiss))
    }
    
    func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension CourseHelpController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let vc = viewController as? ImageViewController {
            if vc.index < self.imagesNames.count - 1 {
                let returnedController = ImageViewController()
                returnedController.index = vc.index + 1
                returnedController.image = UIImage(named: imagesNames[vc.index + 1])
                return returnedController
            }else{
                return nil
            }
        }
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? ImageViewController {
            if vc.index > 0 {
                let returnedController = ImageViewController()
                returnedController.index = vc.index - 1
                returnedController.image = UIImage(named: imagesNames[vc.index - 1])
                return returnedController
            }else{
                return nil
            }
        }
        
        return nil
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return imagesNames.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

class ImageViewController: UIViewController {
    
    var index: Int!
    var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupImageView()
    }
    
    func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
//        imageView.frame = self.view.frame
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
//        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true

        imageView.image = image
    }
    
    
    
}
