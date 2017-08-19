//
//  ShowMyServiceSectionController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/12/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class MyServiceSectionController: ViewServiceSectionController {

    override func setupNaviBarTitle() {
        if let serviceName = serviceName {
            
            if serviceName == ServiceName.SecondHand {
                navigationItem.title = "我发布的二手信息"
            }else if serviceName == ServiceName.RentHouse {
                navigationItem.title = "我发布的租房信息"
            }else if serviceName == ServiceName.HoldActivity {
                navigationItem.title = "我发布的活动"
            }else if serviceName == ServiceName.PartTimeJob {
                navigationItem.title = "我发布的兼职信息"
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleReload), name: Notification.Name(NotificationNameConstants.ReloadMyPublishedService), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func handleReload(notification: Notification) {
        if let indexPath = notification.userInfo?[SettingsConstants.IndexPathIdentifier] as? IndexPath {
            self.sectionItems.remove(at: indexPath.item)
            self.collectionView?.performBatchUpdates({
                self.collectionView?.deleteItems(at: [indexPath])
            }, completion: nil)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sectionItems[indexPath.item]
        let vc = ShowMyItemController()
        vc.service = item
        vc.serviceName = serviceName
        vc.indexPath = indexPath
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func loadServices() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let serviceName = serviceName else { return }
        indicator.startAnimating()
        sectionItems.removeAll(keepingCapacity: false)
        FirDatabasePath.UserReference.child(uid).child(serviceName).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String: String] {
                self.infoView.alpha = 0
                self.indicator.stopAnimating()
                
                for (serviceKey, location) in value {
                    var ref: FIRDatabaseReference
                    if serviceName == ServiceName.HoldActivity {
                        ref = FIRDatabase.database().reference(withPath: serviceName).child(serviceKey)
                    }else{
                        ref = FIRDatabase.database().reference(withPath: serviceName).child(location).child(serviceKey)
                    }
                    ref.observeSingleEvent(of: .value, with: { (snap) in
                        let service = Service(snapshot: snap)
                        self.sectionItems.insert(service, at: 0)
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
    
}
