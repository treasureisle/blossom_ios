//
//  SearchUsersViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 19..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation

class SearchUsersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewUploadMenu: UIView!
    @IBOutlet weak var uploadSellButton: UIButton!
    @IBOutlet weak var uploadBuyButton: UIButton!
    @IBOutlet weak var uploadReviewButton: UIButton!
    @IBOutlet weak var uploadMenuDim: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var postType = 0
    var me: Session?
    
    var lastPageFetched = false
    var keyword = ""
    var users: [User] = []
    var rows = 20
    var page = 1
    
    
    @IBAction func homeTouched(sender: UIButton) {
        self.performSegue(withIdentifier: SegueIdentity.searchUsersToMain, sender: self)
    }
    
    @IBAction func feedTouched(sender: UIButton) {
        if self.me != nil{
            self.performSegue(withIdentifier: SegueIdentity.searchUsersToFeed, sender: self)
        } else {
            let alert = LoginAlertController()
            alert.setSigninAction(action: SigninAction(handler: {
                action in
                if self.presentedViewController == nil {
                    self.performSegue(withIdentifier: SegueIdentity.searchUsersToSignIn, sender: self)
                } else {
                    self.dismiss(animated: false) {
                        () -> Void in
                        self.performSegue(withIdentifier: SegueIdentity.searchUsersToSignIn, sender: self)
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
                    self.performSegue(withIdentifier: SegueIdentity.searchUsersToSignIn, sender: self)
                } else {
                    self.dismiss(animated: false) {
                        () -> Void in
                        self.performSegue(withIdentifier: SegueIdentity.searchUsersToSignIn, sender: self)
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
            performSegue(withIdentifier: SegueIdentity.searchUsersToProfile, sender: me!.id)
        } else {
            let alert = LoginAlertController()
            alert.setSigninAction(action: SigninAction(handler: {
                action in
                if self.presentedViewController == nil {
                    self.performSegue(withIdentifier: SegueIdentity.searchUsersToSignIn, sender: self)
                } else {
                    self.dismiss(animated: false) {
                        () -> Void in
                        self.performSegue(withIdentifier: SegueIdentity.searchUsersToSignIn, sender: self)
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
            _ = BlossomRequest.upload(.post, urlString: "\(Api.searchUser)", multipartFormData: { multipartFormData in
                
                multipartFormData.append((self.keyword.data(using: String.Encoding.utf8))!, withName: "keyword")
                
            }, completionHandler: {
                response, statusCode, json in
                
                if statusCode == 200{
                    let users = json["users"].arrayValue
                    
                    if users.count < self.rows {
                        self.lastPageFetched = true
                    }
                    
                    for user in users {
                        self.users.append(User(o: user))
                    }
                    
                    self.collectionView!.reloadData()
                    
                    self.page += 1
                }
            })

        }
    }
    
    func upload(){
        performSegue(withIdentifier: SegueIdentity.searchUsersToUpload, sender: self)
    }
}

extension SearchUsersViewController {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
        } else {
            self.keyword = searchBar.text!
            search()
            self.searchBar.endEditing(true)
        }
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
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentity.searchUsersCell, for: indexPath) as! SearchUserCell
        
        let user = users[indexPath.row]
        
        cell.thumbnailImageView.makeCircularImageView()
        cell.thumbnailImageView.af_setImage(withURL: URL(string:user.profileThumbUrl)!)
        cell.usernameLabel.text = user.username
        cell.introduceLabel.text = user.introduce
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        performSegue(withIdentifier: SegueIdentity.searchUsersToProfile, sender: user.id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.searchUsersToUpload {
            let uploadViewController = segue.destination as! UploadViewController
            uploadViewController.postType = self.postType
        } else if segue.identifier == SegueIdentity.searchUsersToProfile {
            let userId = sender as! Int
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.userId = userId
        }
    }
}
