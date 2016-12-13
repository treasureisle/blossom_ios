//
//  LaunchViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 10. 14..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit
import PagingMenuController
import Mixpanel

class MainViewController: UIViewController {
    
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var viewUploadMenu: UIView!
    @IBOutlet weak var uploadSellButton: UIButton!
    @IBOutlet weak var uploadBuyButton: UIButton!
    @IBOutlet weak var uploadReviewButton: UIButton!
    @IBOutlet weak var uploadMenuDim: UIButton!
    
    var postType: Int = 0
    var me: Session?
    
    @IBAction func retryTouched(sender: UIButton) {
        sender.isEnabled = false
        tryLogin()
    }
    
    @IBAction func homeTouched(sender: UIButton) {
        
    }
    
    @IBAction func feedTouched(sender: UIButton) {
        
    }
    
    @IBAction func sellUploadTouched(sender: UIButton) {
        self.postType = 0
        self.upload()
        self.uploadMenuDim.isHidden = true
        self.uploadMenuDim.isEnabled = false
        self.viewUploadMenu.isHidden = true
        self.uploadSellButton.isEnabled = false
        self.uploadBuyButton.isEnabled = false
        self.uploadReviewButton.isEnabled = false
    }
    
    @IBAction func buyUploadTouched(sender: UIButton) {
        self.postType = 1
        self.upload()
        self.uploadMenuDim.isHidden = true
        self.uploadMenuDim.isEnabled = false
        self.viewUploadMenu.isHidden = true
        self.uploadSellButton.isEnabled = false
        self.uploadBuyButton.isEnabled = false
        self.uploadReviewButton.isEnabled = false
    }
    
    @IBAction func reviewUploadTouched(sender: UIButton) {
        self.postType = 2
        self.upload()
        self.uploadMenuDim.isHidden = true
        self.uploadMenuDim.isEnabled = false
        self.viewUploadMenu.isHidden = true
        self.uploadSellButton.isEnabled = false
        self.uploadBuyButton.isEnabled = false
        self.uploadReviewButton.isEnabled = false
    }
    
    @IBAction func dimTouched(sender: UIButton) {
        self.uploadMenuDim.isHidden = true
        self.uploadMenuDim.isEnabled = false
        self.viewUploadMenu.isHidden = true
        self.uploadSellButton.isEnabled = false
        self.uploadBuyButton.isEnabled = false
        self.uploadReviewButton.isEnabled = false
    }
    
    @IBAction func uploadTouched(sender: UIButton) {
        if self.me != nil{
            self.uploadMenuDim.isHidden = false
            self.uploadMenuDim.isEnabled = true
            self.viewUploadMenu.isHidden = false
            self.uploadSellButton.isEnabled = true
            self.uploadBuyButton.isEnabled = true
            self.uploadReviewButton.isEnabled = true
        } else {
            let alert = LoginAlertController()
            alert.setSigninAction(action: SigninAction(handler: {
                action in
                if self.presentedViewController == nil {
                    self.performSegue(withIdentifier: SegueIdentity.jumpToSignin, sender: self)
                } else {
                    self.dismiss(animated: false) {
                        () -> Void in
                        self.performSegue(withIdentifier: SegueIdentity.jumpToSignin, sender: self)
                    }
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cartTouched(sender: UIButton) {
        
    }
    
    @IBAction func profileTouched(sender: UIButton) {
        if self.me != nil{
            performSegue(withIdentifier: SegueIdentity.mainToProfile, sender: self)
        } else {
            let alert = LoginAlertController()
            alert.setSigninAction(action: SigninAction(handler: {
                action in
                if self.presentedViewController == nil {
                    self.performSegue(withIdentifier: SegueIdentity.jumpToSignin, sender: self)
                } else {
                    self.dismiss(animated: false) {
                        () -> Void in
                        self.performSegue(withIdentifier: SegueIdentity.jumpToSignin, sender: self)
                    }
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        me = Session.load()
        log.info("API Url: \(apiUrl)")
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.delegate = self
        pagingMenuController.setup(PagingMenuOptions1())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tryLogin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: custom
    func tryLogin() {
        if let me = Session.load(){
            // 로그인 체크
            let params = [
                "id": String(me.id),
                "access_token": me.accessToken
            ]
            print("id: \(me.id), access_token: \(me.accessToken)")
            
            _ = BlossomRequest.request(method: .post, endPoint: Api.session, params: params as [String : AnyObject]?, completionHandler: {
                response, statusCode, json in
                if statusCode == 200{
                    log.debug("login success")
//                    self.jumpToTopicListAfterFetchTopics(SegueIdentity.launchToTopicList)
                    Mixpanel.sharedInstance().identify(String(me.id))
//                    Mixpanel.sharedInstance().track(MixpanelTrack.login)
                    
                }else{
                    log.debug("login failed")
//                    self.performSegueWithIdentifier(SegueIdentity.launchToGuide, sender: self)
                }
            })
        }else{
            log.debug("login failed, no session")
//            self.performSegueWithIdentifier(SegueIdentity.launchToGuide, sender: self)
        }
    }
    
    func upload(){
        performSegue(withIdentifier: SegueIdentity.jumpToUpload, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.jumpToUpload {
            let uploadViewController = segue.destination as! UploadViewController
            uploadViewController.postType = self.postType
        } else if segue.identifier == SegueIdentity.mainToProfile {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.userId = self.me?.id
        }
    }
    
}

extension MainViewController: PagingMenuControllerDelegate {
    // MARK: - PagingMenuControllerDelegate
    func willMove(toMenu menuController: UIViewController, fromMenu previousMenuController: UIViewController) {
        print(#function)
        print(previousMenuController)
        print(menuController)
    }
    
    func didMove(toMenu menuController: UIViewController, fromMenu previousMenuController: UIViewController) {
        print(#function)
        print(previousMenuController)
        print(menuController)
    }
    
    func willMove(toMenuItem menuItemView: MenuItemView, fromMenuItem previousMenuItemView: MenuItemView) {
        print(#function)
        print(previousMenuItemView)
        print(menuItemView)
    }
    
    func didMove(toMenuItem menuItemView: MenuItemView, fromMenuItem previousMenuItemView: MenuItemView) {
        print(#function)
        print(previousMenuItemView)
        print(menuItemView)
    }
}
