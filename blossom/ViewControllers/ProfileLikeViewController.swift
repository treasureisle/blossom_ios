//
//  ProfileLikeViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 12..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ProfileLikeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var lastPageFetched = false
    var posts = [Post]()
    var postRow = 20
    var postPage = 1
    var postId = 0
    var userId: Int?
    
    class func instantiateFromStoryboard() -> ProfileLikeViewController {
        let storyboard = UIStoryboard(name: StoryboardName.profileViewController, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! ProfileLikeViewController
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
    
    func fetchPosts(){
        if !lastPageFetched {
            _ = BlossomRequest.request(method: .get, endPoint: "\(Api.likedPosts)/\(userId!)?page=\(postPage)") { (response, statusCode, json) -> () in
                if statusCode == 200{
                    let posts = json["posts"].arrayValue
                    
                    if posts.count < self.postRow {
                        self.lastPageFetched = true
                    }
                    
                    for post in posts {
                        self.posts.append(Post(o: post))
                    }
                    
                    self.collectionView!.reloadData()
                    
                    self.postPage += 1
                }
            }
        }
    }
}

extension ProfileLikeViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        print("postId: \(post.id)")
        self.postId = post.id
        performSegue(withIdentifier: SegueIdentity.profileLikeToDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.profileLikeToDetail {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.postId = self.postId
        }
    }
}
