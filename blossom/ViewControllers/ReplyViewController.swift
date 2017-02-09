//
//  ReplyViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 21..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON
import Alamofire
import Mixpanel

protocol ReplyViewControllerOnExitListener{
    func onExit()
}

class ReplyUILongPressGestureRecognizer : UILongPressGestureRecognizer {
    var indexPath: IndexPath?
}

class ReplyUITapGestureRecognizer : UITapGestureRecognizer {
    var indexPath: IndexPath?
    var replyCell: ReplyViewCell?
}

class ReplyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate{
    
    var replies = [Reply]()
    var page = 1
    var isLoading = true
    var isEndOfData = false
    var postId = 0
    var isFirst = true
    var keyboardObserver: KeyboardObserver?
    var exitDelegate: ReplyViewControllerOnExitListener?
    
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func cancelTouched() {
        if let delegate = exitDelegate {
            delegate.onExit()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dissmissKeyboard() {
        self.textField.resignFirstResponder()
    }
    
    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        textField.delegate = self
        tableView.delegate = self
        
        keyboardObserver = KeyboardObserver(tableViewHeightConstraint: tableViewHeightConstraint, tableView: tableView, rootView: self.view)
        keyboardObserver!.startObserving()
        
        fetchRepies()
    }
    
    deinit {
        keyboardObserver!.stopObserving()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyViewCell", for: indexPath) as! ReplyViewCell
        let reply = getReplyWithIndexPath(indexPath: indexPath)
        let profileGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(ReplyViewController.profileTouched(sender:)))
        
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(profileGestureRecognizer)
        cell.profileImageView.af_setImage(withURL: URL(string: reply.user.profileThumbUrl)!)

        cell.profileImageView.makeCircularImageView()
        cell.usernameLabel.text = reply.user.username
        cell.replyLabel.text = reply.text
        let imageName = reply.isLiked ? ImageName.imgHeart : ImageName.imgHeartN
        cell.heartImageView.image = UIImage(named: imageName)
        cell.likesLabel.text = "\(reply.likes)"
        
        let recognizer = ReplyUILongPressGestureRecognizer(target: self, action: #selector(ReplyViewController.longTouched(recognizer:)))
        recognizer.minimumPressDuration = 0.5
        recognizer.indexPath = indexPath
        cell.addGestureRecognizer(recognizer)
        
        let likeGuestureRecognizer = ReplyUITapGestureRecognizer(target: self, action: #selector(ReplyViewController.voteReply(sender:)))
        likeGuestureRecognizer.indexPath = indexPath
        likeGuestureRecognizer.replyCell = cell
        
        cell.addGestureRecognizer(likeGuestureRecognizer)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = getReplyWithIndexPath(indexPath: indexPath).text
        let bottomMargin: CGFloat = 30.0
        let profileHeight: CGFloat = 72.0
        let usernameMargin: CGFloat = 34
        
        let replyLabelSize = CGSize.init(width: self.view.frame.width - 166, height: CGFloat.greatestFiniteMagnitude)
        let size = text.boundingRect(with: replyLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)], context: nil)
        
        let height = max(size.size.height + usernameMargin + bottomMargin, profileHeight + bottomMargin)
        return height
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset == 0 {
            if !isLoading && !isEndOfData {
                page += 1
                fetchRepies()
            }
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) ->Bool {
        if textField.isValidReply(self) {
            writeReply()
            textField.resignFirstResponder()
            textField.text = ""
        }
        
        return true
    }
    
    // MARK: override
    func prepare(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentity.replyToProfile {
            let navigationController = segue.destination as! UINavigationController
            let profileViewController = navigationController.topViewController as! ProfileViewController
            
            profileViewController.userId = sender as? Int
        }
    }
    
    // MARK: selector
    func longTouched(recognizer: ReplyUILongPressGestureRecognizer){
        let indexPath = recognizer.indexPath!
        let reply = getReplyWithIndexPath(indexPath: indexPath)
        
        let alert = UIAlertController(title: "Select", message: "", preferredStyle: .actionSheet)
        if reply.user.isMe {
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
                self.deleteReply(indexPath: indexPath)
            }))
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: custom
    func scrollToLast(){
        tableView.scrollRectToVisible(CGRect.init(x: 1, y: 1, width: tableView.contentSize.width - 1, height: tableView.contentSize.height - 1), animated: false)
    }
    
    func fetchRepies(){
        isLoading = true
        
        self.showIndicator()
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.reply)/\(postId)?page=\(page)") {
            (response, statusCode, json) -> () in
            if statusCode == 200{
                if self.page == 1{
                    self.replies.removeAll(keepingCapacity: false)
                    self.refreshTable()
                }
                let replies: Array<JSON>= json["replies"].arrayValue
                if replies.count == 0{
                    self.isEndOfData = true
                }
                for replyObject in replies{
                    let reply = Reply(o: replyObject)
                    self.replies.append(reply)
                }
                self.refreshTable()
                
                self.isLoading = false
            }
            self.hideIndicator()
        }
    }
    
    func refreshReplies(){
        if !isLoading {
            isEndOfData = false
            page = 1
            fetchRepies()
        }
    }
    
    func refreshTable(){
        DispatchQueue.main.async {
            if self.isFirst {
                // scroll to the end at first loading
                self.isFirst = false
                self.tableView.reloadData()
                self.scrollToLast()
            } else {
                // keep scrolling position at refresh
                let offset = self.tableView.contentSize.height - self.tableView.contentOffset.y
                self.tableView.reloadData()
                self.tableView.scrollRectToVisible(CGRect.init(x: 1, y: 1, width: self.tableView.contentSize.width - 1, height: self.tableView.contentSize.height - offset + self.tableView.frame.height - 1), animated: false)
                
            }
            return
        }
    }
    
    func writeReply(){
        self.showIndicator()
        _ = BlossomRequest.upload(.post, urlString: "\(Api.reply)/\(self.postId)", multipartFormData: { multipartFormData in
            multipartFormData.append(("\(self.textField.text!)".data(using: String.Encoding.utf8))!, withName: "text")
        }, completionHandler:  {
            response, statusCode, json in
            
            if statusCode == 200{
                self.refreshReplies()
                self.scrollToLast()
                self.showIndicator()
            }else{
                self.view.makeSomethingWrongToast()
                self.showIndicator()
            }
        })
    }
    
    func profileTouched(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        let reply = getReplyWithIndexPath(indexPath: indexPath!)
        
        self.performSegue(withIdentifier: SegueIdentity.replyToProfile, sender: reply.user.id)
    }
    
    func deleteReply(indexPath: IndexPath) {
        let reply = getReplyWithIndexPath(indexPath: indexPath)
        
        // 삭제확인
        let alert = BlossomAlertController(message: "Do you want to delete your reply?")
        alert.addAction(action: BlossomAlertAction(title: "Cancel", style: .Positive, handler: nil))
        alert.addAction(action: BlossomAlertAction(title: "Yes", style: .Negative, handler: {
            action in
            self.showIndicator()
            _ = BlossomRequest.request(method:.delete, endPoint: "\(Api.reply)/\(reply.id)") { (response, statusCode, json) -> () in
                if statusCode == 200{
                    self.refreshReplies()
                } else {
                    self.view.makeSomethingWrongToast()
                }
                self.hideIndicator()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func voteReply(sender: ReplyUITapGestureRecognizer){
        let reply = getReplyWithIndexPath(indexPath: sender.indexPath!)
        
        if reply.isLiked {
            _ = BlossomRequest.request(method: .delete, endPoint: "\(Api.replyLike)/\(reply.id)") { (response, statusCode, json) -> () in
                if statusCode == 200{
                    reply.likes -= 1
                    reply.isLiked = false
                }else{
                    if statusCode == 404 {
                        let toastMessage = NSLocalizedString("REPLY_ALEADY_UNVOTED", comment: "이미 투표가 취소 된 경우")
                        self.view.makeErrorToast(message: toastMessage)
                    }else{
                        self.view.makeSomethingWrongToast()
                    }
                }
                
                self.tableView.reloadData()
            }
        } else {
            _ = BlossomRequest.request(method: .post, endPoint: "\(Api.replyLike)/\(reply.id)") { (response, statusCode, json) -> () in
                if statusCode == 200{
                    reply.isLiked = true
                    reply.likes += 1
                }else{
                    if statusCode == 409 {
                        let toastMessage = NSLocalizedString("REPLY_ALEADY_VOTED", comment: "이미 투표 된 경우")
                        self.view.makeErrorToast(message: toastMessage)
                    }else{
                        self.view.makeSomethingWrongToast()
                    }
                }
                
                self.tableView.reloadData()
            }
        }
        
    }
    
    func getReplyWithIndexPath(indexPath: IndexPath) -> Reply{
        return replies[replies.count - 1 - indexPath.row]
    }
    
}
