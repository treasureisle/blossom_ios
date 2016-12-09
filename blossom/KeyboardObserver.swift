//
//  KeyboardObserver.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 10..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit

public protocol KeyboardObserverDelegate: class {
    func keyboardWillShow(_ notification: Notification)
    
    func keyboardWillHide(_ notification: Notification)
}

open class KeyboardObserver {
    open weak var delegate: KeyboardObserverDelegate?
    
    var bottomConstraint: NSLayoutConstraint?
    var tableViewHeightConstraint: NSLayoutConstraint?
    var tableViewHeightOriginConstant: CGFloat = 0.0
    var tableView: UITableView?
    var rootView: UIView?
    
    public init(){
        
    }
    
    public init(bottomConstraint: NSLayoutConstraint, rootView: UIView){
        self.bottomConstraint = bottomConstraint
        self.rootView = rootView
    }
    
    public init(tableViewHeightConstraint: NSLayoutConstraint, tableView: UITableView, rootView:UIView){
        self.tableViewHeightConstraint = tableViewHeightConstraint
        self.tableViewHeightOriginConstant = tableViewHeightConstraint.constant
        self.tableView = tableView
        self.rootView = rootView
    }
    
    deinit {
        stopObserving()
    }
    
    open func startObserving(){
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardObserver.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardObserver.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    open func stopObserving(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc open func keyboardWillShow(_ notification: Notification){
        if bottomConstraint != nil && rootView != nil {
            showKeyboardAnimateWithConstraint(notification, bottomConstraint: bottomConstraint!, rootView: rootView!)
        }else if tableViewHeightConstraint != nil && rootView != nil {
            showKeyboardAnimateWithConstraint(notification, tableViewHeightConstraint: tableViewHeightConstraint!, rootView: rootView!)
        } else {
            delegate!.keyboardWillShow(notification)
        }
    }
    
    @objc open func keyboardWillHide(_ notification: Notification){
        if bottomConstraint != nil {
            hideKeyboardAnimateWithConstraint(notification, bottomConstraint: bottomConstraint!, rootView: rootView!)
        }else if tableViewHeightConstraint != nil {
            hideKeyboardAnimateWithConstraint(notification, tableViewHeightConstraint: tableViewHeightConstraint!, rootView: rootView!)
        } else {
            delegate!.keyboardWillHide(notification)
        }
    }
    
    func showKeyboardAnimateWithConstraint(_ notification: Notification, bottomConstraint:NSLayoutConstraint, rootView:UIView){
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            bottomConstraint.constant = endFrame!.size.height 
            
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                rootView.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                // do nothing..
            })
        }
    }
    
    func showKeyboardAnimateWithConstraint(_ notification: Notification, tableViewHeightConstraint: NSLayoutConstraint, rootView:UIView){
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let offset = tableView?.contentOffset
            tableViewHeightConstraint.constant = tableViewHeightOriginConstant - endFrame!.size.height 
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                rootView.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                // do nothing..
            })
            
            self.tableView?.setContentOffset(CGPoint(x: offset!.x, y: offset!.y + endFrame!.size.height), animated: false)
        }
    }
    
    func hideKeyboardAnimateWithConstraint(_ notification: Notification, bottomConstraint:NSLayoutConstraint, rootView:UIView) {
        if let userInfo = notification.userInfo {
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            bottomConstraint.constant = 0
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                rootView.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                // do nothing..
            })
        }
    }
    
    func hideKeyboardAnimateWithConstraint(_ notification: Notification, tableViewHeightConstraint: NSLayoutConstraint, rootView:UIView) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let offset = tableView?.contentOffset
            tableViewHeightConstraint.constant = tableViewHeightOriginConstant
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                rootView.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                // do nothing..
            })
            if offset!.y > endFrame!.size.height {
                self.tableView?.setContentOffset(CGPoint(x: offset!.x, y: offset!.y - endFrame!.size.height), animated: true)
            } else {
                self.tableView?.setContentOffset(CGPoint(x: offset!.x, y: 0), animated: false)
            }
        }
    }
    
}
