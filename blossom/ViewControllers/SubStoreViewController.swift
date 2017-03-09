//
//  SubStoreViewController.swift
//  blossom
//
//  Created by Seong Phil on 2017. 3. 6..
//  Copyright © 2017년 treasureisle. All rights reserved.
//

import UIKit
import PagingMenuController
import Mixpanel

class SubStoreViewController: UIViewController {
    
    @IBOutlet weak var viewUploadMenu: UIView!
    @IBOutlet weak var viewSearchMenu: UIView!
    @IBOutlet weak var uploadSellButton: UIButton!
    @IBOutlet weak var uploadBuyButton: UIButton!
    @IBOutlet weak var uploadReviewButton: UIButton!
    @IBOutlet weak var uploadMenuDim: UIButton!
    @IBOutlet weak var searchTitleButton: UIButton!
    @IBOutlet weak var searchHashtagButton: UIButton!
    @IBOutlet weak var searchUsernameButton: UIButton!
    @IBOutlet weak var storeCollectionView: UICollectionView!
    @IBOutlet weak var storeTitleLabel: UILabel!
    
    var isHashtagId = true
    var postType: Int = 0
    var me: Session?
    var hashtagId: Int = 0
    var storeTitle: String = ""
    var posts = [Post]()
    
    @IBAction func cancleTouched() {
        self.dismiss(animated: true, completion: nil)
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
        self.performSegue(withIdentifier: SegueIdentity.subStoreToSearchPosts, sender: 0)
        self.viewSearchMenu.isHidden = true
        self.uploadMenuDim.isHidden = true
        self.uploadMenuDim.isEnabled = false
        self.searchTitleButton.isEnabled = false
        self.searchHashtagButton.isEnabled = false
        self.searchUsernameButton.isEnabled = false
    }
    
    @IBAction func searchHashtagTouched() {
        self.performSegue(withIdentifier: SegueIdentity.subStoreToSearchPosts, sender: 1)
        self.viewSearchMenu.isHidden = true
        self.uploadMenuDim.isHidden = true
        self.uploadMenuDim.isEnabled = false
        self.searchTitleButton.isEnabled = false
        self.searchHashtagButton.isEnabled = false
        self.searchUsernameButton.isEnabled = false
    }
    
    @IBAction func searchUsernameTouched() {
        self.performSegue(withIdentifier: SegueIdentity.subStoreToSearchUsers, sender: self)
        self.viewSearchMenu.isHidden = true
        self.uploadMenuDim.isHidden = true
        self.uploadMenuDim.isEnabled = false
        self.searchTitleButton.isEnabled = false
        self.searchHashtagButton.isEnabled = false
        self.searchUsernameButton.isEnabled = false
    }
    
    @IBAction func homeTouched(sender: UIButton) {
        self.performSegue(withIdentifier: SegueIdentity.subStoreToMain, sender: self)
    }
    
    @IBAction func feedTouched(sender: UIButton) {
        if self.me != nil{
            self.performSegue(withIdentifier: SegueIdentity.subStoreToFeed, sender: self)
        } else {
            let alert = LoginAlertController()
            alert.setSigninAction(action: SigninAction(handler: {
                action in
                if self.presentedViewController == nil {
                    self.performSegue(withIdentifier: SegueIdentity.subStoreToSignIn, sender: self)
                } else {
                    self.dismiss(animated: false) {
                        () -> Void in
                        self.performSegue(withIdentifier: SegueIdentity.subStoreToSignIn, sender: self)
                    }
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
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
                    self.performSegue(withIdentifier: SegueIdentity.subStoreToSignIn, sender: self)
                } else {
                    self.dismiss(animated: false) {
                        () -> Void in
                        self.performSegue(withIdentifier: SegueIdentity.subStoreToSignIn, sender: self)
                    }
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cartTouched(sender: UIButton) {
        if self.me != nil{
            performSegue(withIdentifier: SegueIdentity.subStoreToCart, sender: self)
        } else {
            let alert = LoginAlertController()
            alert.setSigninAction(action: SigninAction(handler: {
                action in
                if self.presentedViewController == nil {
                    self.performSegue(withIdentifier: SegueIdentity.subStoreToSignIn, sender: self)
                } else {
                    self.dismiss(animated: false) {
                        () -> Void in
                        self.performSegue(withIdentifier: SegueIdentity.subStoreToSignIn, sender: self)
                    }
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func profileTouched(sender: UIButton) {
        if self.me != nil{
            performSegue(withIdentifier: SegueIdentity.subStoreToProfile, sender: self)
        } else {
            let alert = LoginAlertController()
            alert.setSigninAction(action: SigninAction(handler: {
                action in
                if self.presentedViewController == nil {
                    self.performSegue(withIdentifier: SegueIdentity.subStoreToSignIn, sender: self)
                } else {
                    self.dismiss(animated: false) {
                        () -> Void in
                        self.performSegue(withIdentifier: SegueIdentity.subStoreToSignIn, sender: self)
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
        storeTitleLabel.text = storeTitle
        storeCollectionView.delegate = self
        storeCollectionView.dataSource = self
        print("hashtag: \(hashtagId)")
        getPosts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func upload(){
        performSegue(withIdentifier: SegueIdentity.subStoreToUpload, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.subStoreToUpload {
            let uploadViewController = segue.destination as! UploadViewController
            uploadViewController.postType = self.postType
        } else if segue.identifier == SegueIdentity.subStoreToProfile {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.userId = self.me?.id
        } else if segue.identifier == SegueIdentity.subStoreToSearchPosts {
            let searchPostsViewController = segue.destination as! SearchPostsViewController
            let searchType = sender as! Int
            searchPostsViewController.searchType = searchType
        } else if segue.identifier == SegueIdentity.subStoreToDetail {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.postId = sender as! Int
        }
    }
    
    func getPosts(){
        if self.isHashtagId {
            _ = BlossomRequest.request(method: .get, endPoint: "\(Api.storeDetail)/\(self.hashtagId)") { (response, statusCode, json) -> () in
                if statusCode == 200{
                    let posts = json["posts"].arrayValue
                
                    for post in posts {
                        self.posts.append(Post(o: post))
                    }
                    self.storeCollectionView.reloadData()
                }
            }
        } else {
            _ = BlossomRequest.request(method: .get, endPoint: "\(Api.userPosts)/\(self.hashtagId)") { (response, statusCode, json) -> () in
                if statusCode == 200{
                    let posts = json["posts"].arrayValue
                    
                    for post in posts {
                        self.posts.append(Post(o: post))
                    }
                    self.storeCollectionView.reloadData()
                }
            }
        }
    }
    
}

extension SubStoreViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        performSegue(withIdentifier: SegueIdentity.subStoreToDetail, sender: post.id)
    }
}

extension SubStoreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentity.mainCell, for: indexPath) as! MainCell
        
        let post = self.posts[indexPath.row]
        print("postId: \(post.id)")
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let costInt = post.purchasePrice + post.fee
        
        if let cost = formatter.string(for: costInt) {
            cell.productImageView.af_setImage(withURL: URL(string:post.imgUrl1)!)
            cell.productDescriptionLabel.text = post.title
            cell.productPriceLabel.text = "\(NSLocalizedString("MONEYMARK", comment: "MONEYMARK"))\(cost)"
            cell.roundingUIView(aView: cell, cornerRadiusParam: 5.0)
        }
        return cell
    }
}
