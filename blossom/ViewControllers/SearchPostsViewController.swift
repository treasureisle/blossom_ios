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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchType = 0 //0:title 1:hashtag
    var lastPageFetched = false
    var keyword = ""
    var posts: [Post] = []
    var rows = 20
    var page = 1
    
    var postType = 0
    var me: Session?
    
    
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
    
    @IBAction func cancleTouched() {
        self.dismiss(animated: true, completion: nil)
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
            cell.regionFlagImage.image = ImageName.flags[Int(post.region)!]
            let ratio = 100 - (post.purchasePrice * 100 / post.originPrice)
            cell.discountRatioLabel.text = "\(ratio)%"
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
