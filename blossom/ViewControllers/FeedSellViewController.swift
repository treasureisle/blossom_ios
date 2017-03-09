//
//  FeedSellViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 15..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FeedSellViewController: UICollectionViewController {
    var lastPageFetched = false
    var posts = [Post]()
    var postRow = 20
    var postPage = 1
    var postId = 0
    var userId: Int?
    
    class func instantiateFromStoryboard() -> FeedSellViewController {
        let storyboard = UIStoryboard(name: StoryboardName.feedViewController, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! FeedSellViewController
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
            _ = BlossomRequest.request(method: .get, endPoint: "\(Api.feeds)?page=\(postPage)") { (response, statusCode, json) -> () in
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

extension FeedSellViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentity.feedCell, for: indexPath) as! FeedCell
        
        let post = posts[indexPath.row]
        
        cell.cartButton.tag = indexPath.row
        cell.likeButton.tag = indexPath.row
        cell.replyButton.tag = indexPath.row
        cell.shareButton.tag = indexPath.row
        
        cell.cartButton.addTarget(self, action: #selector(self.cartTouched(_:)), for: .touchUpInside)
        cell.likeButton.addTarget(self, action: #selector(self.likeTouched(_:)), for: .touchUpInside)
        cell.replyButton.addTarget(self, action: #selector(self.replyTouched(_:)), for: .touchUpInside)
        cell.shareButton.addTarget(self, action: #selector(self.shareTouched(_:)), for: .touchUpInside)
        
        let profileImageGR = BlossomTapGestureRecognizer(target: self, action: #selector(self.profileTouched(_:)))
        profileImageGR.tag = indexPath.row
        
        let profileNicknameGR = BlossomTapGestureRecognizer(target: self, action: #selector(self.profileTouched(_:)))
        profileNicknameGR.tag = indexPath.row
        
        cell.profileThumbnailImageView.addGestureRecognizer(profileImageGR)
        cell.profileThumbnailImageView.isUserInteractionEnabled = true
        cell.profileNicknameLabel.addGestureRecognizer(profileNicknameGR)
        cell.profileNicknameLabel.isUserInteractionEnabled = true
        
        cell.initCell(post: post)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        self.postId = post.id
        performSegue(withIdentifier: SegueIdentity.feedSellToDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.feedSellToDetail {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.postId = self.postId
        } else if segue.identifier == SegueIdentity.feedSellToReply {
            let replyViewController = segue.destination as! ReplyViewController
            replyViewController.postId = self.postId
        } else if segue.identifier == SegueIdentity.feedSellToProfile {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.userId = self.postId // 변수 추가하지않고 postId에 userId로 사용
        }
    }
    
    func cartTouched(_ sender: UIButton) {
        let post = posts[sender.tag]
        self.postId = post.id
        performSegue(withIdentifier: SegueIdentity.feedSellToDetail, sender: self)
    }
    
    func likeTouched(_ sender: UIButton) {
        let post = posts[sender.tag]
        if post.isLiked {
            _ = BlossomRequest.request(method: .delete, endPoint: "\(Api.like)/\(post.id)") { (response, statusCode, json) -> () in
                if statusCode == 200{
                    post.isLiked = false
                    post.likes -= 1
                    self.collectionView!.reloadData()
                    
                } else if statusCode == 404 {
                    post.isLiked = false
                    
                }
            }
        } else {
            _ = BlossomRequest.request(method: .post, endPoint: "\(Api.like)/\(post.id)") { (response, statusCode, json) -> () in
                if statusCode == 200{
                    post.isLiked = true
                    post.likes += 1
                    self.collectionView!.reloadData()
                } else if statusCode == 409 {
                    post.isLiked = true
                }
            }
        }
    }
    
    func replyTouched(_ sender: UIButton) {
        let post = posts[sender.tag]
        self.postId = post.id
        performSegue(withIdentifier: SegueIdentity.feedSellToReply, sender: self)
    }
    
    func shareTouched(_ sender: UIButton) {
//        let post = posts[sender.tag]
    }
    
    func profileTouched(_ sender: BlossomTapGestureRecognizer) {
        let post = posts[sender.tag]
        self.postId = post.user.id
        performSegue(withIdentifier: SegueIdentity.feedSellToProfile, sender: self)
    }
}

