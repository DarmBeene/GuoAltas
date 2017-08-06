//
//  CourseWebController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/6/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit
import WebKit
//            let urlTest = URL(string: "https://www.dropbox.com/sh/gbhiqdz1he0fu8h/AACCBskWE-w4ZzkYIf6C_a8Ba?dl=0")

class CourseWebController: UIViewController, WKNavigationDelegate {
    
    var course: Course?
    let toolBarHeight: CGFloat = 35
    
    lazy var webView: WKWebView = {
        let wv = WKWebView(frame: .zero)
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.navigationDelegate = self
        
        return wv
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.setImage(UIImage(named: "back_icon"), for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    lazy var forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "forward_icon"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(goForward), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        button.isEnabled = true
        
        return button
    }()
    lazy var toolBar: UIToolbar = {
        let tb = UIToolbar(frame: .zero)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.backgroundColor = .white
        return tb
    }()
    lazy var progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .bar)
        pv.progressTintColor = .orange
        pv.translatesAutoresizingMaskIntoConstraints = false
        
        return pv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        initWebView()
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    }

    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.isLoading))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.isLoading) {
            backButton.isEnabled = webView.canGoBack
            forwardButton.isEnabled = webView.canGoForward
        }
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            progressView.isHidden = webView.estimatedProgress == 1
            if webView.estimatedProgress == 1{
                resetProgressView()
            }
        }
        if keyPath == #keyPath(WKWebView.title) {
            navigationItem.title = webView.title
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        resetProgressView()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alertController = UIAlertController(title: "错误", message: error.localizedDescription, preferredStyle: .alert)
        let alert = UIAlertAction(title: "确认", style: .default, handler: nil)
        alertController.addAction(alert)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resetProgressView() {
        progressView.progress = 0.0
        progressView.setProgress(0.0, animated: false)
    }
    
    func initWebView() {
        guard let course = course else { return }
        if let link = course.link, let url = URL(string: link), let _ = url.scheme{
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }else{
            let pageNotFound = PageNotFound(frame: self.view.frame)
            self.view.addSubview(pageNotFound)
            let reportButton = UIButton(type: .system)
            reportButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            reportButton.setTitle("反馈错误信息", for: .normal)
            reportButton.addTarget(self, action: #selector(handleReport), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: reportButton)
        }
    }
    func handleReport() {
        let ref = FirDatabasePath.FeedbackReference.childByAutoId()
        let data = ["course": course?.courseKey]
        
        ref.setValue(data) { (error, reference) in
            if error != nil {
                self.view.prompt(message: "反馈错误信息失败: \(error!.localizedDescription)")
            }else{
                self.view.prompt(message: "非常感谢您的反馈")
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
    
    func setupViews() {
        self.view.addSubview(progressView)
        progressView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        progressView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        self.view.insertSubview(webView, belowSubview: progressView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        webView.heightAnchor.constraint(equalToConstant: self.view.frame.height - toolBarHeight).isActive = true
//        webView.navigationDelegate = self
        
//        self.view.addSubview(toolBar)
        self.view.insertSubview(toolBar, aboveSubview: webView)
        toolBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        toolBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: toolBarHeight).isActive = true
        
        let flexibileButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpaceButton.width = 50
        let rightSpaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightSpaceButton.width = 20
        toolBar.items = [UIBarButtonItem(customView: backButton),fixedSpaceButton, UIBarButtonItem(customView: forwardButton), flexibileButton, shareButton, rightSpaceButton]
        
    }
    
    func goBack() {
        webView.goBack()
    }
    func goForward() {
        webView.goForward()
    }
    func share() {
        let activity = SafariActivity()
        //        activity.activityTitle = "Open in Safari"
        
        let activityVC = UIActivityViewController(activityItems: [webView.url!], applicationActivities: [activity])
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
}
