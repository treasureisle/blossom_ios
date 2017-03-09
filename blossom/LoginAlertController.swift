//
//  LoginAlertController.swift
//  Login
//
//  Created by Seong Phil on 2016. 11. 10..
//  Copyright © 2016년 treasureisle. All rights reserved.
// https://github.com/okmr-d/DOAlertController/blob/master/DOAlertController/DOAlertController.swift 참고

import Foundation
import SnapKit
import UIKit

// MARK: LoginAlertAnimation
class LoginAlertAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    let handler: Void
    
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
        let alertController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! LoginAlertController
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
        let alertController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! LoginAlertController
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { () -> Void in
            alertController.overlayView.alpha = 0.0
            alertController.wrapperView.alpha = 0.0
            alertController.wrapperView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (finished) -> Void in
            transitionContext.completeTransition(true)
        }
    }
}

// MARK: SignInAction
class SigninAction: NSObject {
    var handler: ((SigninAction?) -> Void)!
    
    required init(handler: ((SigninAction?) -> Void)!){
        self.handler = handler
    }
}

// MARK: LoginAlertController
class LoginAlertController: UIViewController, UIViewControllerTransitioningDelegate, KeyboardObserverDelegate {
    final let alertWidth = 300
    final let buttonHeight = 60
    final let textHeight = 40
    var messageTextSize: CGFloat = 16
    final let buttonTextSize: CGFloat = 24
    
    var signinAction: SigninAction?

    var message: String?
    
    var overlayView = UIView() // 가장바깥 overlay
    var containerView = UIView() // 전체 영역 container
    var wrapperView = UIView() // 팝업 wrapper
    var messageLabel = UILabel() // 팝업 제목
    var emailField = UITextField() // 이메일 입력
    var passwordField = UITextField() // 비밀번호 입력
    var loginButton = UIButton()
    var signinButton = UIButton()
    var cancleButton = UIButton()
    
    var keyboardObserver: KeyboardObserver!
    var containerBottomConst: Constraint!
    
    // MARK: init
    convenience init(){
        self.init(nibName: nil, bundle: nil)
        
        self.message = NSLocalizedString("LOGIN", comment: "로그인 메세지")
        
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = UIModalPresentationStyle.custom
        
        self.transitioningDelegate = self
        
        self.view.addSubview(overlayView)
        self.view.addSubview(containerView)
        
        containerView.addSubview(wrapperView)
        wrapperView.addSubview(messageLabel)
        wrapperView.addSubview(emailField)
        wrapperView.addSubview(passwordField)
        
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
            make.bottom.equalTo(passwordField)
        }
        
        messageLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(wrapperView).offset(30)
            make.left.equalTo(wrapperView).offset(20)
            make.right.equalTo(wrapperView).offset(-20)
        }
        
        emailField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(wrapperView).offset(70)
            make.left.equalTo(wrapperView)
            make.width.equalTo(wrapperView)
            make.height.equalTo(textHeight)
        }
        
        passwordField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(wrapperView).offset(111)
            make.left.equalTo(wrapperView)
            make.width.equalTo(wrapperView)
            make.height.equalTo(textHeight)

        }
        
        cancleButton.layer.masksToBounds = true
        cancleButton.tag = 0
        cancleButton.backgroundColor = UIColor.darkGray
        cancleButton.setTitle("X", for: .normal)
        cancleButton.setTitleColor(UIColor.white, for: .normal)
        cancleButton.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
        cancleButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        
        self.wrapperView.addSubview(cancleButton)
        
        cancleButton.snp.remakeConstraints({ (make) -> Void in
            make.right.equalTo(wrapperView).offset(-5)
            make.top.equalTo(wrapperView).offset(5)
            make.width.equalTo(20)
            make.height.equalTo(20)
        })
        
        loginButton.layer.masksToBounds = true
        loginButton.tag = 1
        loginButton.backgroundColor = UIColor.gray
        loginButton.setTitle(NSLocalizedString("LOGIN", comment: ""), for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        
        self.wrapperView.addSubview(loginButton)
        
        signinButton.layer.masksToBounds = true
        signinButton.tag = 2
        signinButton.backgroundColor = UIColor.gray
        signinButton.setTitle(NSLocalizedString("SIGNIN", comment: ""), for: .normal)
        signinButton.setTitleColor(UIColor.white, for: .normal)
        signinButton.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
        signinButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        
        self.wrapperView.addSubview(signinButton)
        
        wrapperView.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(alertWidth)
            make.center.equalTo(self.view)
            make.bottom.equalTo(signinButton)
        }
        
        loginButton.snp.remakeConstraints({ (make) -> Void in
            make.left.equalTo(wrapperView)
            make.width.equalTo(wrapperView)
            make.height.equalTo(buttonHeight)
            make.top.equalTo(passwordField.snp.bottom)
        })
        
        signinButton.snp.remakeConstraints({ (make) -> Void in
            make.left.equalTo(wrapperView)
            make.width.equalTo(wrapperView)
            make.height.equalTo(buttonHeight)
            make.top.equalTo(loginButton.snp.bottom).offset(1)
        })
        
        keyboardObserver = KeyboardObserver()
        keyboardObserver.delegate = self
        keyboardObserver.startObserving()
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        return LoginAlertAnimation(isPresenting: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LoginAlertAnimation(isPresenting: false)
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
        let tag = sender.tag
        if tag == 1 {
            loginFunc()
        } else if tag == 2 {
            print("tag=2")
            if let handler = self.signinAction?.handler {
                handler(self.signinAction)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func buttonTouchDown(sender: UIButton){
        sender.backgroundColor = UIColor.gray
    }
    
    func layoutViews(){
        self.overlayView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.wrapperView.backgroundColor = UIColor.darkGray
        
        self.messageLabel.textColor = UIColor.black
        self.messageLabel.text = NSLocalizedString("LOGIN_REQUIRED", comment: "")
        self.messageLabel.textAlignment = .center
        self.messageLabel.numberOfLines = 0
        self.messageLabel.lineBreakMode = .byWordWrapping
        
        self.emailField.placeholder = NSLocalizedString("EMAIL", comment: "")
        self.emailField.backgroundColor = UIColor.white
        self.emailField.textColor = UIColor.black
        self.emailField.text = ""
        
        self.passwordField.placeholder = NSLocalizedString("PASSWORD", comment: "")
        self.passwordField.backgroundColor = UIColor.white
        self.passwordField.textColor = UIColor.black
        self.passwordField.isSecureTextEntry = true
        self.passwordField.text = ""
        
        
    }
    
    func setSigninAction(action: SigninAction){
        self.signinAction = action
    }
    
    func loginFunc(){
        let email = emailField.text
        let password = passwordField.text
        if email?.isEmpty == false && password?.isEmpty == false {
            let params = [
                "email":email,
                "password":password
            ]
            
            //로그인 진행
            _ = BlossomRequest.request(method: .post, endPoint: Api.sessionEmail, params: params as [String : AnyObject]?) {
                response, statusCode, json in
                
                var isOtherError = false
                
                if statusCode == 200{
                    // 저장하고 메인으로 넘어가기
                    let me = Session(o: json["session"])
                    me.save()
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.resetWindowToInitView()
                }else{
                    let errorMsg = ErrorMsg(o: json)
                    if statusCode == 404{
                        if errorMsg.message.range(of: "user not found") != nil{
                            self.view.makeErrorToast(message: NSLocalizedString("USER_NOT_FOUND", comment: "유저가 없을 경우 표시"))
                        }else{
                            isOtherError = true
                        }
                    }else if statusCode == 400{
                        if errorMsg.message.range(of: "wrong password") != nil{
                            self.view.makeErrorToast(message: NSLocalizedString("PASSWORD_IS_WRONG", comment: "비밀번호가 틀렸을 경우 표시"))
                        }else{
                            isOtherError = true
                        }
                    }else{
                        isOtherError = true
                    }
                    
                }
                
                if isOtherError {
                    self.view.makeSomethingWrongToast()
                }
            }
        }
    }
}
