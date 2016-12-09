//
//  BlossomAlertController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 10..
//  Copyright © 2016년 treasureisle. All rights reserved.
// https://github.com/okmr-d/DOAlertController/blob/master/DOAlertController/DOAlertController.swift 참고

import Foundation
import SnapKit
import UIKit

enum BlossomAlertActionStyle: Int {
    case Positive
    case Negative
}

// MARK: BlossomAlertAnimation
class BlossomAlertAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    
    // MARK: init
    init(isPresenting: Bool){
        self.isPresenting = isPresenting
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? 0.45 : 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresenting ? self.presentAnimateTransition(transitionContext: transitionContext) : self.dissmissAnimateTransition(transitionContext: transitionContext)
    }
    
    
    // MARK: custom
    func presentAnimateTransition(transitionContext: UIViewControllerContextTransitioning){
        let alertController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! BlossomAlertController
        let containerView = transitionContext.containerView
        
        alertController.overlayView.alpha = 0.0
        alertController.wrapperView.alpha = 0.0
        alertController.wrapperView.center = alertController.view.center
        alertController.wrapperView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        containerView.addSubview(alertController.view)
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            alertController.overlayView.alpha = 1.0
            alertController.wrapperView.alpha = 1.0
            alertController.wrapperView.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
        }) { (finished) -> Void in
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                alertController.wrapperView.transform = CGAffineTransform.identity
            }, completion: { (finished) -> Void in
                if finished {
                    transitionContext.completeTransition(true)
                }
            })
        }
    }
    
    func dissmissAnimateTransition(transitionContext: UIViewControllerContextTransitioning){
        let alertController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! BlossomAlertController
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { () -> Void in
            alertController.overlayView.alpha = 0.0
            alertController.wrapperView.alpha = 0.0
            alertController.wrapperView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (finished) -> Void in
            transitionContext.completeTransition(true)
        }
    }
}

// MARK: BlossomAlertAction
class BlossomAlertAction: NSObject {
    var title: String
    var handler: ((BlossomAlertAction?) -> Void)!
    var style: BlossomAlertActionStyle
    
    required init(title: String, style:BlossomAlertActionStyle, handler: ((BlossomAlertAction?) -> Void)!){
        self.title = title
        self.handler = handler 
        self.style = style
    }
}

// MARK: BlossomAlertController
class BlossomAlertController: UIViewController, UIViewControllerTransitioningDelegate, KeyboardObserverDelegate {
    final let alertWidth = 300
    final let buttonHeight = 60
    var messageTextSize: CGFloat = 20
    final let buttonTextSize: CGFloat = 24
    
    var textFieldCount: Int = 0
    var message: String?
    var actions = [BlossomAlertAction]()
    var buttons = [UIButton]()
    
    var overlayView = UIView() // 가장바깥 overlay
    var containerView = UIView() // 전체 영역 container
    var wrapperView = UIView() // 팝업 wrapper
    var textField = UITextField()
    
    var messageLabel = UILabel()
    var placeHolder: String?
    
    var showTextField = false
    var inputMessage = ""
    var keyboardObserver: KeyboardObserver!
    var containerBottomConst: Constraint!
    
    // MARK: init
    convenience init(message: String){
        self.init(nibName: nil, bundle: nil)
        
        self.message = message
        
        inited()
    }
    
    convenience init(placeHolder: String, inputMessage: String){
        self.init(nibName: nil, bundle: nil)
        
        self.showTextField = true
        self.placeHolder = placeHolder
        self.inputMessage = inputMessage

        
        inited()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        layoutViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BlossomAlertAnimation(isPresenting: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BlossomAlertAnimation(isPresenting: false)
    }
    
    // MARK: KeyboardObserverDelegate
    func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            containerBottomConst.update(offset: endFrame!.size.height * -1.0 )
            
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: .curveEaseOut, animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.wrapperView.center = self.containerView.center
            }, completion: { (finished) -> Void in
                // do nothing..
            })
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        // do nothing..
    }
    
    // MARK: selector
    func buttonTouched(sender: UIButton){
        let action = actions[sender.tag]
        if let handler = action.handler {
            handler(action)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func buttonTouchDown(sender: UIButton){
        sender.backgroundColor = UIColor.gray
    }
    
    // MARK: custom
    func inited(){
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = UIModalPresentationStyle.custom
        
        self.transitioningDelegate = self
        
        self.view.addSubview(overlayView)
        self.view.addSubview(containerView)
        
        containerView.addSubview(wrapperView)
        
        if showTextField {
            wrapperView.addSubview(textField)
        }else{
            wrapperView.addSubview(messageLabel)
        }
        
        overlayView.snp.makeConstraints { (make) -> Void in
            make.top.bottom.left.right.equalTo(self.view)
        }
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(self.view)
            containerBottomConst = make.bottom.equalTo(self.view).constraint
        }
        
        wrapperView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(alertWidth)
            make.center.equalTo(containerView)
            make.bottom.equalTo(showTextField ? textField : messageLabel)
        }
        
        if showTextField {
            textField.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(wrapperView).offset(15)
                make.left.equalTo(wrapperView).offset(20)
                make.right.equalTo(wrapperView).offset(-20)
            }
        }else{
            messageLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(wrapperView).offset(15)
                make.left.equalTo(wrapperView).offset(20)
                make.right.equalTo(wrapperView).offset(-20)
            }
        }
        
        keyboardObserver = KeyboardObserver()
        keyboardObserver.delegate = self
        keyboardObserver.startObserving()
    }
    
    func layoutViews(){
        self.overlayView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.wrapperView.backgroundColor = UIColor.darkGray
        
        if showTextField {
            self.textField.placeholder = self.placeHolder
            self.textField.textColor = UIColor.black
            self.textField.text = inputMessage
        }else{
            self.messageLabel.font = UIFont.systemFont(ofSize: showTextField ? messageTextSize - 4 : messageTextSize)
            self.messageLabel.textColor = UIColor.black
            self.messageLabel.text = self.message!
            self.messageLabel.textAlignment = .center
            self.messageLabel.numberOfLines = 0
            self.messageLabel.lineBreakMode = .byWordWrapping
        }
        
        for button in buttons {
            button.titleLabel!.font = UIFont.systemFont(ofSize: buttonTextSize)
        }
    }
    
    func addAction(action: BlossomAlertAction){
        self.actions.append(action)
        
        // 버튼 추가
        let button = UIButton()
        button.layer.masksToBounds = true
        button.setTitle(action.title, for: .normal)
        button.addTarget(self, action: #selector(BlossomAlertController.buttonTouched(sender:)), for: .touchUpInside)
        if action.style == .Negative {
            button.setTitleColor(UIColor.black, for: .normal)
        }
        button.addTarget(self, action: #selector(BlossomAlertController.buttonTouchDown(sender:)), for: .touchDown)
        button.tag = buttons.count
        
        buttons.append(button)
        self.wrapperView.addSubview(button)
        
        for i in 0 ..< buttons.count {
            if i == 0 {
                wrapperView.snp.remakeConstraints { (make) -> Void in
                    make.width.equalTo(alertWidth)
                    make.center.equalTo(self.view)
                    make.bottom.equalTo(buttons[i])
                }
            }
            
            buttons[i].snp.remakeConstraints({ (make) -> Void in
                if i == 0 {
                    make.left.equalTo(wrapperView)
                }else{
                    make.left.equalTo(buttons[i-1].snp.right)
                }
                make.width.equalTo(wrapperView).dividedBy(buttons.count)
                make.height.equalTo(buttonHeight)
                if showTextField {
                    make.top.equalTo(textField.snp.bottom).offset(15)
                }else{
                    make.top.equalTo(messageLabel.snp.bottom).offset(20)
                }
            })
        }
    }
}
