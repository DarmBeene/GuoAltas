//
//  PublishView.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/28/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class PublishView: UIView {
    let textFieldHeight: CGFloat = 40
    
    let titleTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "标题"
        return tf
    }()

    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = GlobalConstants.TextFieldBGC
        tv.font = UIFont.systemFont(ofSize: GlobalConstants.TextViewFontSize)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        addSubview(titleTextField)
        titleTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        titleTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        addSubview(textView)
        textView.leftAnchor.constraint(equalTo: titleTextField.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: titleTextField.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 5).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
    
    
}







