//
//  SearchUsersViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 19..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation

class SearchUsersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate  {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var me = Session.load()
    var postType = 0
    
    var lastPageFetched = false
    var keyword = ""
    var users: [User] = []
    var rows = 20
    var page = 1
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func cancleTouched(){
        self.dismiss(animated: true, completion: nil)
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
        
}

extension SearchUsersViewController {
    
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
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentity.searchUsersCell, for: indexPath) as! SearchUsersCell
    
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
        if segue.identifier == SegueIdentity.searchUsersToProfile {
            let userId = sender as! Int
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.userId = userId
        }
    }
}
