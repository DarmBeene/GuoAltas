//
//  ChangeNameController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/18/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//
import Foundation

class ChangeNameController: BaseTableController {
    
    var text: String?
//    var updateUser: (([AnyHashable: Any]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(handleSaveName))
    }
    
    func handleSaveName() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ChangeNameCell
        let newName = cell.textField.text
        
        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
        changeRequest?.displayName = newName
        changeRequest?.commitChanges(completion: { (err) in
            if let err = err {
                self.showAlertPrompt(message: err.localizedDescription)
                return
            }
            self.updateUser(values: ["displayName": newName as Any])
            
            OperationQueue.main.addOperation {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func updateUser(values: [AnyHashable: Any]) {
        if let firUser = FIRAuth.auth()?.currentUser {
            let ref = FIRDatabase.database().reference(withPath: "Users").child(firUser.uid)
            
            ref.updateChildValues(values, withCompletionBlock: { (error, reference) in
                if let error = error {
                    self.showAlertPrompt(message: error.localizedDescription)
                    return
                }
            })
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChangeNameCell()
        cell.textField.text = text
        
        return cell
    }
    
}

class ChangeNameCell: BaseCell {
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .always
        return tf
    }()
    
    override func setupViews() {
        self.addSubview(textField)
        textField.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
