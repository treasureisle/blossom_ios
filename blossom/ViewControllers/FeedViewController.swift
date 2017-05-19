//
//  FeedViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 15..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit
import PagingMenuController
import Mixpanel

class FeedViewController: UIViewController {
    
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
    
    @IBAction func searchTouched() {
        self.viewSearchMenu.isHidden = false
        self.uploadMenuDim.isHidden = false
        self.uploadMenuDim.isEnabled = true
        self.searchTitleButton.isEnabled = true
        self.searchHashtagButton.isEnabled = true
        self.searchUsernameButton.isEnabled = true
    }
    
    @IBAction func searchTitleTouched() {
        self.performSegue(withIdentifier: SegueIdentity.feedToSearchPosts, sender: 0)
        self.viewSearchMenu.isHidden = true
        self.uploadMenuDim.isHidden = true
        self.uploadMenuDim.isEnabled = false
        self.searchTitleButton.isEnabled = false
        self.searchHashtagButton.isEnabled = false
        self.searchUsernameButton.isEnabled = false
    }
    
    @IBAction func searchHashtagTouched() {
        self.performSegue(withIdentifier: SegueIdentity.feedToSearchPosts, sender: 1)
        self.viewSearchMenu.isHidden = true
        self.uploadMenuDim.isHidden = true
        self.uploadMenuDim.isEnabled = false
        self.searchTitleButton.isEnabled = false
        self.searchHashtagButton.isEnabled = false
        self.searchUsernameButton.isEnabled = false
    }
    
    @IBAction func searchUsernameTouched() {
        self.performSegue(withIdentifier: SegueIdentity.feedToSearchUsers, sender: self)
        self.viewSearchMenu.isHidden = true
        self.uploadMenuDim.isHidden = true
        self.uploadMenuDim.isEnabled = false
        self.searchTitleButton.isEnabled = false
        self.searchHashtagButton.isEnabled = false
        self.searchUsernameButton.isEnabled = false
    }
    
    @IBAction func homeTouched(sender: UIButton) {
        performSegue(withIdentifier: SegueIdentity.feedToMain, sender: self)
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
        }
    }
    
    @IBAction func cartTouched(sender: UIButton) {
        performSegue(withIdentifier: SegueIdentity.feedToCart, sender: self)
    }
    
    @IBAction func profileTouched(sender: UIButton) {
        if self.me != nil{
            performSegue(withIdentifier: SegueIdentity.feedToProfile, sender: self)
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
        pagingMenuController.setup(FeedPagingMenuOptions1())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func upload(){
        performSegue(withIdentifier: SegueIdentity.feedToUpload, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.feedToUpload {
            let uploadViewController = segue.destination as! UploadViewController
            uploadViewController.postType = self.postType
        } else if segue.identifier == SegueIdentity.feedToProfile {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.userId = self.me?.id
        } else if segue.identifier == SegueIdentity.feedToSearchPosts {
            let searchPostsViewController = segue.destination as! SearchPostsViewController
            let searchType = sender as! Int
            searchPostsViewController.searchType = searchType
        }
    }
    
}
