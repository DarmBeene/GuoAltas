//
//  GeneralController.swift
//  SanRenXing
//
//  Created by GuoGongbin on 7/15/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit


class GeneralController: UIViewController, GADBannerViewDelegate {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "app_icon")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 3
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isEditable = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    var bannerView: GADBannerView!
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "PS: 对的，下面是Google广告，你都看到这里了，你不点一下么！"
        label.alpha = 0
        return label
    }()
    let margin: CGFloat = 10
    
    func setupViews() {
        self.view.backgroundColor = .white
        navigationItem.title = "关于"
        
        self.view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bannerView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        self.view.addSubview(label)
        label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin).isActive = true
        label.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin).isActive = true
        label.bottomAnchor.constraint(equalTo: bannerView.topAnchor, constant: -5).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10).isActive = true
        textView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin).isActive = true
        textView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin).isActive = true
        textView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -10).isActive = true
        textView.text = "1. 该App旨在大家互相帮助，信息共享 \n\n2. 后台学校信息数据库尚不完整，但我会陆续更新这些信息 \n\n3. 对于要增加的功能，欢迎发邮件给我，我会及时更新 \n\n4. 对于这款App有建议、意见或者批评指正的，也欢迎发邮件给我 \n\n5. 发邮件有啥好处吗？有的，写得好的话，我会给你5-10欧（原谅我是个穷学生😞） \n\n6. 我的邮箱：beenekwok@icloud.com"
        
        bannerView.delegate = self
//        let testAdUnitID = "ca-app-pub-3940256099942544/6300978111"
//        bannerView.adUnitID = testAdUnitID
        bannerView.adUnitID = AdMobConstants.AdUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        label.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
            self.label.alpha = 1
        })
    }
    
}
