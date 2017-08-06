//
//  EntertainCommentsHelper.swift
//  AtalasDream
//
//  Created by Gongbin Guo on 8/2/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation
import CoreData

extension EntertainCommentsController: ActionViewDelegate {
    
    func handleReport() {
        dismissActionView()
        let reportController = UIAlertController(title: "请选择举报理由", message: nil, preferredStyle: .actionSheet)
        
        let fraud = UIAlertAction(title: ReportIdentifier.PromotionFraud, style: .default) { (_) in
            self.reportAction()
        }
        let nudity = UIAlertAction(title: ReportIdentifier.Nudity, style: .default) { (_) in
            self.reportAction()
        }
        let fakeNews = UIAlertAction(title: ReportIdentifier.FakeNews, style: .default) { (_) in
            self.reportAction()
        }
        let others = UIAlertAction(title: ReportIdentifier.Others, style: .default) { (_) in
            self.reportAction()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        reportController.addAction(fraud)
        reportController.addAction(nudity)
        reportController.addAction(fakeNews)
        reportController.addAction(others)
        reportController.addAction(cancel)
        self.present(reportController, animated: true, completion: nil)
    }

    func reportAction() {
        if let indexPath = selectedIndexPath {
            
            storeMessageKey()
            
            self.comments.remove(at: indexPath.item)
            
            self.collectionView?.performBatchUpdates({ 
                self.collectionView?.deleteItems(at: [indexPath])
            }, completion: nil)
        }
    }
    func storeMessageKey() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate,
            let entertainmentKey = entertainmentKey,
            let indexPath = selectedIndexPath {
            
            let context = delegate.persistentContainer.viewContext            
            do{
                let message = NSEntityDescription.insertNewObject(forEntityName: BlackListType.LocalEntertainBlackListMessage, into: context) as! LocalEntertainBlackListMessage
                message.messageKey = comments[indexPath.item].commentKey
                message.entertainmentKey = entertainmentKey
                
                try context.save()
                
            }catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func handleCancel() {
        self.dismissViews()
    }
    func handleCopy() {
        if let indexPath = selectedIndexPath {
            UIPasteboard.general.string = comments[indexPath.item].content
        }
    }
}

extension EntertainCommentsController: CommentToolViewDelegate, CommentViewDelegate, UITextViewDelegate {
    
    func showCommentView() {
        commentView.textView.becomeFirstResponder()
    }
    func showMessages() {
    }
    
    func dismissViews() {
        if self.actionView.alpha == 1 {
            dismissActionView()
        }
        if commentView.textView.isFirstResponder {
            dismissCommentView()
        }
    }
    func dismissActionView() {
        UIView.animate(withDuration: 0.4, animations: {
            self.actionView.transform = .identity
            self.actionView.alpha = 0
            self.blackView.alpha = 0
        })
    }
    func dismissCommentView() {
        commentView.textView.resignFirstResponder()
        let text = commentView.textView.text
        if  text != nil && text != "" {
            let draft = "[草稿] "
            let mainString = draft + text!
            let attributedString = NSMutableAttributedString(string: mainString)
            let range = (mainString as NSString).range(of: draft)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: range)
            commentToolBarView.commentLabel.attributedText = attributedString
        }else{
            commentToolBarView.commentLabel.text = EntertainConstants.LeaveMessageIdentifier
        }
    }
    func sendComment() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid,
            let entertainmentKey = entertainmentKey else {
                self.showAlertPrompt(message: "请先登录，登陆后方可评论")
                return
        }
        
        let content = commentView.textView.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        
        let comment = Comment(content: content, date: date, uid: uid)
        
        let ref = FirDatabasePath.CommentReference.child(entertainmentKey).childByAutoId()
        ref.setValue(comment.toAny()) { (error, reference) in
            if let error = error {
                self.showAlertPrompt(message: "分享失败:\(error.localizedDescription)")
                return
            }
            self.commentView.textView.text = nil
            self.commentView.textView.resignFirstResponder()
            self.view.prompt(message: "评论发布成功", completion: {
                DispatchQueue.main.async {
                    self.refreshControll?.beginRefreshing()
                    self.loadData()
                    self.refreshControll?.endRefreshing()
                }
            })
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text
        if text != nil && text != "" {
            commentView.sendButton.isEnabled = true
        }else{
            commentView.sendButton.isEnabled = false
        }
    }
    
}
