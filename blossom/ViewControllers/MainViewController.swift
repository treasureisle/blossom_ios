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
    
    @IBOutlet weak var viewUploadMenu: UIView!
    @IBOutlet weak var viewSearchMenu: UIView!
    @IBOutlet weak var uploadSellButton: UIButton!
    @IBOutlet weak var uploadBuyButton: UIButton!
    @IBOutlet weak var uploadReviewButton: UIButton!
    @IBOutlet weak var uploadMenuDim: UIButton!
    @IBOutlet weak var searchTitleButton: UIButton!
    @IBOutlet weak var searchHashtagButton: UIButton!
    @IBOutlet weak var searchUsernameButton: UIButton!
    
    var postType: Int = 0
    var me: Session?
    
    @IBAction func retryTouched(sender: UIButton) {
        sender.isEnabled = false
        tryLogin()
    }
    
    @IBAction func searchTouched() {
        self.viewSearchMenu.isHidden = false
        self.uploadMenuDim.isHidden = false
        self.uploadMenuDim.isEnabled = true
        self.searchTitleButton.isEnabled = true
        self.searchHashtagButton.isEnabled = true
        self.searchUsernameButton.isEnabled = true
    }
    
    @IBAction func searchTitleTouched() {
        self.performSegue(withIdentifier: SegueIdentity.mainToSearchPosts, sender: 0)
        self.viewSearchMenu.isHidden = true
        self.uploadMenuDim.isHidden = true
        self.uploadMenuDim.isEnabled = false
        self.searchTitleButton.isEnabled = false
        self.searchHashtagButton.isEnabled = false
        self.searchUsernameButton.isEnabled = false
    }
    
    @IBAction func searchHashtagTouched() {
        self.performSegue(withIdentifier: SegueIdentity.mainToSearchPosts, sender: 1)
        self.viewSearchMenu.isHidden = true
        self.uploadMenuDim.isHidden = true
        self.uploadMenuDim.isEnabled = false
        self.searchTitleButton.isEnabled = false
        self.searchHashtagButton.isEnabled = false
        self.searchUsernameButton.isEnabled = false
    }
    
    @IBAction func searchUsernameTouched() {
        self.performSegue(withIdentifier: SegueIdentity.mainToSearchUsers, sender: self)
        self.viewSearchMenu.isHidden = true
        self.uploadMenuDim.isHidden = true
        self.uploadMenuDim.isEnabled = false
        self.searchTitleButton.isEnabled = false
        self.searchHashtagButton.isEnabled = false
        self.searchUsernameButton.isEnabled = false
    }
    
    @IBAction func homeTouched(sender: UIButton) {

    }
    
    @IBAction func feedTouched(sender: UIButton) {
        if self.me != nil{
            self.performSegue(withIdentifier: SegueIdentity.mainToFeed, sender: self)
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
            
            self.present(alert, animated: true, completion: {
                
                self.tryLogin()
            })
        }
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
        self.viewSearchMenu.isHidden = true
        self.searchTitleButton.isEnabled = false
        self.searchHashtagButton.isEnabled = false
        self.searchUsernameButton.isEnabled = false
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
            
            self.present(alert, animated: true, completion: {self.tryLogin()})
        }
        
    }
    
    @IBAction func cartTouched(sender: UIButton) {
        if self.me != nil{
            performSegue(withIdentifier: SegueIdentity.mainToCart, sender: self)
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
            
            self.present(alert, animated: true, completion: {self.tryLogin()})
        }
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
            
            self.present(alert, animated: true, completion: {self.tryLogin()})
        }
    }
    
    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        me = Session.load()
        log.info("API Url: \(apiUrl)")
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.onMove = { state in
            switch state {
            case let .willMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .didMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .willMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case let .didMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case .didScrollStart:
                print("Scroll start")
            case .didScrollEnd:
                print("Scroll end")
            }
        }
        
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
                    Mixpanel.sharedInstance()?.identify(String(me.id))
                    
                }else{
                    log.debug("다른기기에서의 로그인이 확인되어 다시 로그인합니다.")
                    Session.remove()
                }
            })
        }else{
            log.debug("login failed, no session")
            
            let myCategory = Category.getMyCategory()
            if myCategory == 0 {
                print("category 0")
                self.performSegue(withIdentifier: SegueIdentity.mainToGreeting, sender: self)
            } else {
                print("category id: \(myCategory)")
            }
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
        } else if segue.identifier == SegueIdentity.mainToSearchPosts {
            let searchPostsViewController = segue.destination as! SearchPostsViewController
            let searchType = sender as! Int
            searchPostsViewController.searchType = searchType
        }
    }
}


