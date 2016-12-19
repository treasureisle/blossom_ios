//
//  SearchPostsViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 19..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation

class SearchPostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewUploadMenu: UIView!
    @IBOutlet weak var uploadSellButton: UIButton!
    @IBOutlet weak var uploadBuyButton: UIButton!
    @IBOutlet weak var uploadReviewButton: UIButton!
    @IBOutlet weak var uploadMenuDim: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchType = 0 //0:title 1:hashtag
    var lastPageFetched = false
    var keyword = ""
    var posts: [Post] = []
    var rows = 20
    var page = 1
    
    var postType = 0
    var me: Session?
    
    
    @IBAction func homeTouched(sender: UIButton) {
        self.performSegue(withIdentifier: SegueIdentity.searchPostsToMain, sender: self)
    }
    
    @IBAction func feedTouched(sender: UIButton) {
        if self.me != nil{
            self.performSegue(withIdentifier: SegueIdentity.searchPostsToFeed, sender: self)
        } else {
            let alert = LoginAlertController()
            alert.setSigninAction(action: SigninAction(handler: {
                action in
                if self.presentedViewController == nil {
                    self.performSegue(withIdentifier: SegueIdentity.searchPostsToSignIn, sender: self)
                } else {
                    self.dismiss(animated: false) {
                        () -> Void in
                        self.performSegue(withIdentifier: SegueIdentity.searchPostsToSignIn, sender: self)
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
                    self.performSegue(withIdentifier: SegueIdentity.searchPostsToSignIn, sender: self)
                } else {
                    self.dismiss(animated: false) {
                        () -> Void in
                        self.performSegue(withIdentifier: SegueIdentity.searchPostsToSignIn, sender: self)
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
            performSegue(withIdentifier: SegueIdentity.searchPostsToProfile, sender: me!.id)
        } else {
            let alert = LoginAlertController()
            alert.setSigninAction(action: SigninAction(handler: {
                action in
                if self.presentedViewController == nil {
                    self.performSegue(withIdentifier: SegueIdentity.searchPostsToSignIn, sender: self)
                } else {
                    self.dismiss(animated: false) {
                        () -> Void in
                        self.performSegue(withIdentifier: SegueIdentity.searchPostsToSignIn, sender: self)
                    }
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.me = Session.load()
        self.searchBar.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func search(){
        if !lastPageFetched {
            _ = BlossomRequest.upload(.post, urlString: "\(Api.searchPost)", multipartFormData: { multipartFormData in
                
                if self.searchType == 0 {
                    multipartFormData.append(("title".data(using: String.Encoding.utf8))!, withName: "search_type")
                } else if self.searchType == 1 {
                    multipartFormData.append(("hashtag".data(using: String.Encoding.utf8))!, withName: "search_type")

                }
                
                multipartFormData.append((self.keyword.data(using: String.Encoding.utf8))!, withName: "keyword")
                
                
            }, completionHandler: {
                response, statusCode, json in
                
                if statusCode == 200{
                    let posts = json["posts"].arrayValue
                    
                    if posts.count < self.rows {
                        self.lastPageFetched = true
                    }
                    
                    for post in posts {
                        self.posts.append(Post(o: post))
                    }
                    
                    self.collectionView!.reloadData()
                    
                    self.page += 1
                }
            })
            
        }
    }
    
    func upload(){
        performSegue(withIdentifier: SegueIdentity.searchPostsToUpload, sender: self)
    }
}

extension SearchPostsViewController {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
        } else {
            self.keyword = searchBar.text!
            search()
        }
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentity.mainCell, for: indexPath) as! MainCell
        
        let post = posts[indexPath.row]
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        performSegue(withIdentifier: SegueIdentity.searchPostsToDetail, sender: post.id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.searchPostsToUpload {
            let uploadViewController = segue.destination as! UploadViewController
            uploadViewController.postType = self.postType
        } else if segue.identifier == SegueIdentity.searchPostsToProfile {
            let userId = sender as! Int
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.userId = userId
        } else if segue.identifier == SegueIdentity.searchPostsToDetail {
            let postId = sender as! Int
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.postId = postId
        }
    }
    
}
