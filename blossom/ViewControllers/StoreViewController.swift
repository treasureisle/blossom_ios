//
//  StoreViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 10. 28..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SubStoreTag {
    var hashtagId: Int!
    var storeTitle: String!
    init(hashtagId: Int, storeTitle: String) {
        self.hashtagId = hashtagId
        self.storeTitle = storeTitle
    }
}

class StoreViewController: UIViewController {
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var editorsPickCollectionView: UICollectionView!
    @IBOutlet weak var todaySellerCollecrionView: UICollectionView!
    @IBOutlet weak var hotHashtag1: UICollectionView!
    @IBOutlet weak var hotHashtag2: UICollectionView!
    @IBOutlet weak var hotHashtag3: UICollectionView!
    @IBOutlet weak var editorsPickTitleLabel: UILabel!
    @IBOutlet weak var todaySellerTitleLabel: UILabel!
    @IBOutlet weak var hashtag1Label: UILabel!
    @IBOutlet weak var hashtag2Label: UILabel!
    @IBOutlet weak var hashtag3Label: UILabel!
    
    var store: Store?
    var lastPageFetched = false
    var events = [Event]()
    var editorsPickPosts = [Post]()
    var todaySellerPosts = [Post]()
    var hotHashtag1Posts = [Post]()
    var hotHashtag2Posts = [Post]()
    var hotHashtag3Posts = [Post]()
    var bestHashtags = [Hashtag]()
    var postRow = 20
    var postPage = 1
    var postId = 0
    var isHashtagId = true
    
    class func instantiateFromStoryboard() -> StoreViewController {
        let storyboard = UIStoryboard(name: StoryboardName.mainViewController, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! StoreViewController
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventCollectionView.delegate = self
        editorsPickCollectionView.delegate = self
        todaySellerCollecrionView.delegate = self
        hotHashtag1.delegate = self
        hotHashtag2.delegate = self
        hotHashtag3.delegate = self
        eventCollectionView.dataSource = self
        editorsPickCollectionView.dataSource = self
        todaySellerCollecrionView.dataSource = self
        hotHashtag1.dataSource = self
        hotHashtag2.dataSource = self
        hotHashtag3.dataSource = self
        
        getStore()
    }
    
    @IBAction func editorsPickMoreTouched() {
        self.isHashtagId = true
        let storeTag: SubStoreTag = SubStoreTag.init(hashtagId: self.store!.editorsPickHashtagId, storeTitle: "에디터 선정")
        performSegue(withIdentifier: SegueIdentity.storeToSubStore, sender: storeTag)
    }
    
    @IBAction func todaySellerMoreTouched() {
        self.isHashtagId = false
        let storeTag: SubStoreTag = SubStoreTag.init(hashtagId: self.store!.sellerId, storeTitle: "추천셀러: \(self.store!.todaySellerTitle)")
        performSegue(withIdentifier: SegueIdentity.storeToSubStore, sender: storeTag)
    }
    
    @IBAction func hotHashtag1MoreTouched() {
        self.isHashtagId = true
        let storeTag: SubStoreTag = SubStoreTag.init(hashtagId: self.bestHashtags[0].id, storeTitle: "#\(self.bestHashtags[0].name)")
        performSegue(withIdentifier: SegueIdentity.storeToSubStore, sender: storeTag)
    }
    
    @IBAction func hotHashtag2MoreTouched() {
        self.isHashtagId = true
        let storeTag: SubStoreTag = SubStoreTag.init(hashtagId: self.bestHashtags[1].id, storeTitle: "#\(self.bestHashtags[1].name)")
        performSegue(withIdentifier: SegueIdentity.storeToSubStore, sender: storeTag)    }
    
    @IBAction func hotHashtag3MoreTouched() {
        self.isHashtagId = true
        let storeTag: SubStoreTag = SubStoreTag.init(hashtagId: self.bestHashtags[2].id, storeTitle: "#\(self.bestHashtags[2].name)")
        performSegue(withIdentifier: SegueIdentity.storeToSubStore, sender: storeTag)
    }
    
    func getStore(){
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.store)") { (response,statusCode, json) -> () in
            if statusCode == 200{
                let store = Store(o: json["store"])
                self.store = store
                    
                self.events.removeAll()
                
                if store.numEvents > 0 {
                    self.events.append(Event(hashtagId: store.event1HashtagId, imgUrl:store.event1ImgUrl))
                }
                if store.numEvents > 1 {
                    self.events.append(Event(hashtagId: store.event2HashtagId, imgUrl:store.event2ImgUrl))
                }
                if store.numEvents > 2 {
                    self.events.append(Event(hashtagId: store.event3HashtagId, imgUrl:store.event3ImgUrl))
                }
                if store.numEvents > 3 {
                    self.events.append(Event(hashtagId: store.event4HashtagId, imgUrl:store.event4ImgUrl))
                }
                if store.numEvents > 4 {
                    self.events.append(Event(hashtagId: store.event5HashtagId, imgUrl:store.event5ImgUrl))
                }
                
                self.editorsPickTitleLabel.text = store.editorsPickTitle
                self.todaySellerTitleLabel.text = store.todaySellerTitle

                self.eventCollectionView.reloadData()
                
                self.fetchPosts()
                
            }
        }
    }
    
    func fetchPosts() {
        fetchEditorsPick()
        fetchTodaySeller()
        fetchBestHashtags()
    }
    
    func fetchEditorsPick(){
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.storeDetail)/\(store!.editorsPickHashtagId)") { (response, statusCode, json) -> () in
            if statusCode == 200{
                print("editors pick: \(self.store!.editorsPickHashtagId)")
                let posts = json["posts"].arrayValue
                
                if posts.count < self.postRow {
                    self.lastPageFetched = true
                }
                
                for post in posts {
                    self.editorsPickPosts.append(Post(o: post))
                }
                
                self.editorsPickCollectionView.reloadData()
                
            }
        }
    }
    
    func fetchTodaySeller(){
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.userPosts)/\(store!.sellerId)") { (response, statusCode, json) -> () in
            if statusCode == 200{
                print("todayseller: \(self.store!.sellerId)")
                let posts = json["posts"].arrayValue
                
                if posts.count < self.postRow {
                    self.lastPageFetched = true
                }
                
                for post in posts {
                    self.todaySellerPosts.append(Post(o: post))
                }
                
                self.todaySellerCollecrionView.reloadData()
                
            }
        }
    }
    
    func fetchBestHashtags(){
        let categoryId = Category.getMyCategory()
        
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.hashtagScore)/\(categoryId)") { (response, statusCode, json) -> () in
            if statusCode == 200{
                let hashtags = json["hashtags"].arrayValue
                
                for hashtag in hashtags {
                    self.bestHashtags.append(Hashtag(o: hashtag))
                }
                
                if self.bestHashtags.count > 0 {
                    _ = BlossomRequest.request(method: .get, endPoint: "\(Api.storeDetail)/\(self.bestHashtags[0].id)") { (response, statusCode, json) -> () in
                        if statusCode == 200{
                            print("hashtag1")
                            let posts = json["posts"].arrayValue
                            
                            for post in posts {
                                self.hotHashtag1Posts.append(Post(o: post))
                            }
                            self.hotHashtag1.reloadData()
                        }
                    }
                }
                
                if self.bestHashtags.count > 1 {
                    _ = BlossomRequest.request(method: .get, endPoint: "\(Api.storeDetail)/\(self.bestHashtags[1].id)") { (response, statusCode, json) -> () in
                        if statusCode == 200{
                            print("hashtag2")
                            let posts = json["posts"].arrayValue
                            
                            for post in posts {
                                self.hotHashtag2Posts.append(Post(o: post))
                            }
                            self.hotHashtag2.reloadData()
                        }
                    }
                }
                
                if self.bestHashtags.count > 2 {
                    _ = BlossomRequest.request(method: .get, endPoint: "\(Api.storeDetail)/\(self.bestHashtags[2].id)") { (response, statusCode, json) -> () in
                        if statusCode == 200{
                            print("hashtag3")
                            let posts = json["posts"].arrayValue
                            
                            for post in posts {
                                self.hotHashtag3Posts.append(Post(o: post))
                            }
                            self.hotHashtag3.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.storeToDetail {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.postId = sender as! Int
        } else if segue.identifier == SegueIdentity.storeToSubStore {
            let subStoreViewController = segue.destination as! SubStoreViewController
            let storeTag = sender as! SubStoreTag
            subStoreViewController.isHashtagId = isHashtagId
            subStoreViewController.hashtagId = storeTag.hashtagId
            subStoreViewController.storeTitle = storeTag.storeTitle
        }
    }
}

extension StoreViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.eventCollectionView {
            return self.events.count
        } else if collectionView == editorsPickCollectionView {
            return self.editorsPickPosts.count
        } else if collectionView == todaySellerCollecrionView {
            return self.todaySellerPosts.count
        } else if collectionView == hotHashtag1 {
            return self.hotHashtag1Posts.count
        } else if collectionView == hotHashtag2 {
            return self.hotHashtag2Posts.count
        } else if collectionView == hotHashtag3 {
            return self.hotHashtag3Posts.count
        }
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.eventCollectionView {
            self.isHashtagId = true
            let storeTag: SubStoreTag = SubStoreTag.init(hashtagId: self.events[indexPath.row].hashtagId, storeTitle: "이벤트")
            performSegue(withIdentifier: SegueIdentity.storeToSubStore, sender: storeTag)
        } else if collectionView == editorsPickCollectionView {
            performSegue(withIdentifier: SegueIdentity.storeToDetail, sender: self.editorsPickPosts[indexPath.row].id)
        } else if collectionView == todaySellerCollecrionView {
            performSegue(withIdentifier: SegueIdentity.storeToDetail, sender: self.todaySellerPosts[indexPath.row].id)
        } else if collectionView == hotHashtag1 {
            performSegue(withIdentifier: SegueIdentity.storeToDetail, sender: self.hotHashtag1Posts[indexPath.row].id)
        } else if collectionView == hotHashtag2 {
            performSegue(withIdentifier: SegueIdentity.storeToDetail, sender: self.hotHashtag2Posts[indexPath.row].id)
        } else if collectionView == hotHashtag3 {
            performSegue(withIdentifier: SegueIdentity.storeToDetail, sender: self.hotHashtag3Posts[indexPath.row].id)
        }
    }
}
//
//extension StoreViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        print("Here sizeForItemAt Works")
//        
//        return CGSize(width: 375, height: 160)
//    }
//}

extension StoreViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.eventCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentity.storeBannerCell, for:indexPath) as! StoreBannerCell
    
            cell.bannerImageView.af_setImage(withURL: URL(string: self.events[indexPath.row].imgUrl)!)
    
            return cell
        } else if collectionView == editorsPickCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentity.mainCell, for: indexPath) as! MainCell
            let post = self.editorsPickPosts[indexPath.row]
            
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
        } else if collectionView == todaySellerCollecrionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentity.mainCell, for: indexPath) as! MainCell
            let post = self.todaySellerPosts[indexPath.row]
            
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
        } else if collectionView == hotHashtag1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentity.mainCell, for: indexPath) as! MainCell
            let post = self.hotHashtag1Posts[indexPath.row]
            
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
        } else if collectionView == hotHashtag2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentity.mainCell, for: indexPath) as! MainCell
            let post = self.hotHashtag2Posts[indexPath.row]
            
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
        } else if collectionView == hotHashtag3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentity.mainCell, for: indexPath) as! MainCell
            let post = self.hotHashtag3Posts[indexPath.row]
            
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
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentity.mainCell, for: indexPath) as! MainCell
            return cell
        }
    }
}
