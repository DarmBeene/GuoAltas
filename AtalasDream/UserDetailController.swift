//
//  UserDetailController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/17/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class UserDetailController: BaseTableController {
    
    var cellNames = [["头像", "名称", "邮箱"], ["性别", "我的学校", "我的院系"]]
    var text: String?
    var university: University?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: nil, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellNames.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNames[section].count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        let user = FIRAuth.auth()?.currentUser
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell = UserPhotoCell()
                (cell as! UserPhotoCell).nameLabel.text = cellNames[0][0]
                if let urlString = user?.photoURL?.absoluteString {
                    (cell as! UserPhotoCell).profileImageView.loadImageFrom(urlString: urlString)
                }else{
                    (cell as! UserPhotoCell).profileImageView.image = UIImage(named: "anonymous")
                }
            case 1:
                cell = UserDetailCell()
                (cell as! UserDetailCell).nameLabel.text = cellNames[0][1]
                (cell as! UserDetailCell).detailLabel.text = user?.displayName
            case 2:
                cell = UserDetailCell()
                (cell as! UserDetailCell).nameLabel.text = cellNames[0][2]
                (cell as! UserDetailCell).detailLabel.text = user?.email
                cell?.accessoryType = .none
            default:
                break
            }
        }
        if indexPath.section == 1 {
            cell = UserDetailCell()
            switch indexPath.row {
            case 0:
                (cell as! UserDetailCell).nameLabel.text = cellNames[1][0]
            case 1:
                (cell as! UserDetailCell).nameLabel.text = cellNames[1][1]
                if let universityName = UserDefaults.standard.object(forKey: UserDefaultsKey.UniversityName) as? String {
                    (cell as! UserDetailCell).detailLabel.text = universityName
                }
            case 2:
                (cell as! UserDetailCell).nameLabel.text = cellNames[1][2]
                if let departmentName = UserDefaults.standard.value(forKey: UserDefaultsKey.MyDepartment) as? String {
                    (cell as! UserDetailCell).detailLabel.text = departmentName
                    cell?.accessoryType = .none
                }
            default:
                break
            }
        }
        
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                changeProfileImage()
            case 1:
                changeDisplayName()
            case 2:
                break
            default:
                break
            }
        }
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                break
            case 1:
                selectUniversity()
            default:
                break
            }
        }
    }

    func changeProfileImage() {
        let alertController = UIAlertController(title: "设置头像", message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "拍照", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
                switch status {
                case .notDetermined:
                    AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (result) in
                        if result {
                            self.presentImagePickerController(sourceType: .camera)
                        }
                    })
                case .denied:
                    let alertController = UIAlertController(title: "无法使用你的照相机", message: "没有获得照相机的使用权限，请在设置中开启[照相机]", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    let openAction = UIAlertAction(title: "开启权限", style: .default, handler: { (action) in
                        if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(openAction)
                    self.present(alertController, animated: true, completion: nil)
                case .restricted:
                    self.showAlertPrompt(message: "无法获得照相机使用权限")
                case .authorized:
                    self.presentImagePickerController(sourceType: .camera)
                }
            }
        })
        let selectPhotoAction = UIAlertAction(title: "从相册选择", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                let status1 = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
                let status = PHPhotoLibrary.authorizationStatus()
                switch status {
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization({ (status) in
                        if status == .authorized {
                            self.presentImagePickerController(sourceType: .photoLibrary)
                        }
                    })
                case .denied:
                    let alertController = UIAlertController(title: "无法使用你的照片", message: "没有获得照片的使用权限，请在设置中开启[照片]", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    let openAction = UIAlertAction(title: "开启权限", style: .default, handler: { (action) in
                        if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(openAction)
                    self.present(alertController, animated: true, completion: nil)
                case .restricted:
                    self.showAlertPrompt(message: "无法获得照片使用权限")
                case .authorized:
                    self.presentImagePickerController(sourceType: .photoLibrary)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(takePhotoAction)
        alertController.addAction(selectPhotoAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func presentImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func changeDisplayName() {
        let changeNameController = ChangeNameController(style: .grouped)
        changeNameController.text = FIRAuth.auth()?.currentUser?.displayName
//        changeNameController.updateUser = updateUser(values:)
        navigationController?.pushViewController(changeNameController, animated: true)
    }
    func selectUniversity() {
        let vc = TownsController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 60
        }
        return 40
    }
    
}

extension UserDetailController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = editedImage
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = originalImage
        }
        if image != nil {
            let indexPath = IndexPath(row: 0, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? UserPhotoCell {
                if let imageData = UIImageJPEGRepresentation(image!, 0.1), let smallSizeImage = UIImage(data: imageData) {
                    cell.profileImageView.image = smallSizeImage
                    uploadToFirebaseWith(imageData: imageData)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadToFirebaseWith(imageData: Data) {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            let imagePath = "\(uid).jpg"
            let ref = FIRStorage.storage().reference(withPath: "userProfileImages").child(imagePath)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            ref.put(imageData, metadata: metadata, completion: { (metadata, error) in
                if let error = error {
                    self.showAlertPrompt(message: error.localizedDescription)
                    return
                }
                let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                changeRequest?.photoURL = metadata?.downloadURL()
                changeRequest?.commitChanges(completion: { (err) in
                    if let err = err {
                        self.showAlertPrompt(message: err.localizedDescription)
                        return
                    }
                    let values = ["photoURL": metadata?.downloadURL()?.absoluteString as Any]
                    self.updateUser(values: values)
                })
            })
        }
    }
    
    func updateUser(values: [AnyHashable: Any]) {
        if let firUser = FIRAuth.auth()?.currentUser {
            let ref = FirDatabasePath.UserReference.child(firUser.uid)
            
            ref.updateChildValues(values, withCompletionBlock: { (error, reference) in
                if let error = error {
                    self.showAlertPrompt(message: error.localizedDescription)
                    return
                }
            })
        }
    }
    
    
    
    
}
