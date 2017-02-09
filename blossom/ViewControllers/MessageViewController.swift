//
//  MessageViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 12..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

protocol MessageViewControllerOnExitListener{
    func onExit()
}

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var me: Session?
    var sender: User?
    var isLoading = true
    var messages = [Message]()
    var keyboardObserver: KeyboardObserver?
    var exitDelegate: MessageViewControllerOnExitListener?
    
    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.me = Session.load()
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchMessages()
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageViewCell", for: indexPath) as! MessageViewCell
        let message = getMessageWithIndexPath(indexPath: indexPath)
        let profileGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(MessageViewController.profileTouched(sender:)))
        
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(profileGestureRecognizer)
        cell.profileImageView.af_setImage(withURL: URL(string: message.sender.profileThumbUrl)!)
        
        cell.profileImageView.makeCircularImageView()
        cell.usernameLabel.text = message.sender.username
        cell.messageLabel.text = message.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = getMessageWithIndexPath(indexPath: indexPath).text
        let bottomMargin: CGFloat = 30.0
        let profileHeight: CGFloat = 72.0
        let usernameMargin: CGFloat = 34
        
        let replyLabelSize = CGSize.init(width: self.view.frame.width - 166, height: CGFloat.greatestFiniteMagnitude)
        let size = text.boundingRect(with: replyLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)], context: nil)
        
        let height = max(size.size.height + usernameMargin + bottomMargin, profileHeight + bottomMargin)
        return height
    }

    func profileTouched(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        let message = getMessageWithIndexPath(indexPath: indexPath!)
        
        self.performSegue(withIdentifier: SegueIdentity.messageToProfile, sender: message.sender.id)
    }
        func getMessageWithIndexPath(indexPath: IndexPath) -> Message{
        return messages[messages.count - 1 - indexPath.row]
    }
    
    func writeMessage(){
        let params = [
            "text": textField.text!
        ]
        
        self.showIndicator()
        _ = BlossomRequest.request(method: .post, endPoint: "" , params: params) {
            response, statusCode, json in
            if statusCode == 200 {
                self.refreshMessages()
                self.scrollToLast()
            }else if statusCode == 400 || statusCode == 409{
                let errorMsg = ErrorMsg(o: json)
                self.view.makeErrorToast(message: errorMsg.message)
            }else{
                self.view.makeSomethingWrongToast()
            }
            self.hideIndicator()
        }
    }
    
    func scrollToLast(){
        tableView.scrollRectToVisible(CGRect.init(x: 1, y: 1, width: tableView.contentSize.width - 1, height: tableView.contentSize.height - 1), animated: false)
    }
    
    func fetchMessages(){
        isLoading = true
        
        self.showIndicator()
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.messages)/\(sender?.id)") {
            (response, statusCode, json) -> () in
            if statusCode == 200{
                let messages: Array<JSON>= json["messages"].arrayValue
                
                for messageObject in messages{
                    let message = Message(o: messageObject)
                    self.messages.append(message)
                }
                
                self.scrollToLast()
                self.isLoading = false
            }
            self.hideIndicator()
        }
    }
    
    func refreshMessages(){
        if !isLoading {
            fetchMessages()
        }
    }

}

