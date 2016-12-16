//
//  FeedCommonViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 15..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FeedCommonViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var lastPageFetched = false
    var posts = [Post]()
    var postRow = 20
    var postPage = 1
    var postId = 0
    var userId: Int?
    
    class func instantiateFromStoryboard() -> FeedCommonViewController {
        let storyboard = UIStoryboard(name: StoryboardName.feedViewController, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! FeedCommonViewController
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
            _ = BlossomRequest.request(method: .get, endPoint: "\(Api.feeds)?post_type=common&page=\(postPage)") { (response, statusCode, json) -> () in
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

extension FeedCommonViewController {
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
        
        cell.initCell(post: post)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        print("postId: \(post.id)")
        self.postId = post.id
        //performSegue(withIdentifier: SegueIdentity.profileLikeToDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.profileLikeToDetail {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.postId = self.postId
        }
    }
}

