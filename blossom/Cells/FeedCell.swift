//
//  FeedCell.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 15..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class FeedCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var profileThumbnailImageView: UIImageView!
    @IBOutlet weak var profileNicknameLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    
    var post: Post?
    var img1: Image?
    var img2: Image?
    var img3: Image?
    var img4: Image?
    var img5: Image?
    
    func initCell(post: Post){
        self.post = post
        
        self.productDescriptionLabel.text = self.post!.title
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let costInt = self.post!.purchasePrice + self.post!.fee
        if let cost = formatter.string(for: costInt) {
            self.productPriceLabel.text = "\(NSLocalizedString("MONEYMARK", comment: ""))\(cost)"
        }
        
        self.profileNicknameLabel.text = post.user.username
        self.profileThumbnailImageView.makeCircularImageView()
        self.profileThumbnailImageView.image = nil
        self.profileThumbnailImageView.af_setImage(withURL: URL(string: self.post!.user.profileThumbUrl)!)
        self.likeLabel.text = String(self.post!.likes)
        self.replyLabel.text = String(self.post!.replys)
        
        Alamofire.request((self.post?.imgUrl1)!).responseImage {
            response in
            self.img1 = response.result.value
            if (self.post?.imgUrl2.isEmpty)! {
                self.imageCollectionView.dataSource = self
                self.imageCollectionView.delegate = self
            } else {
                Alamofire.request((self.post?.imgUrl2)!).responseImage {
                    response in
                    self.img2 = response.result.value
                    if (self.post?.imgUrl3.isEmpty)! {
                        self.imageCollectionView.dataSource = self
                        self.imageCollectionView.delegate = self
                    } else {
                        Alamofire.request((self.post?.imgUrl3)!).responseImage {
                            response in
                            self.img3 = response.result.value
                            if (self.post?.imgUrl4.isEmpty)! {
                                self.imageCollectionView.dataSource = self
                                self.imageCollectionView.delegate = self
                            } else {
                                Alamofire.request((self.post?.imgUrl4)!).responseImage {
                                    response in
                                    self.img4 = response.result.value
                                    if (self.post?.imgUrl5.isEmpty)! {
                                        self.imageCollectionView.dataSource = self
                                        self.imageCollectionView.delegate = self
                                    } else {
                                        Alamofire.request((self.post?.imgUrl1)!).responseImage {
                                            response in
                                            self.img5 = response.result.value
                                            self.imageCollectionView.dataSource = self
                                            self.imageCollectionView.delegate = self
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    @IBAction func purchaseTouched() {
        
    }
    
    @IBAction func likeTouched() {
        
    }
    
    @IBAction func replyTouched() {
        
    }
    
    @IBAction func shareTouched() {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        if (self.post?.imgUrl2.isEmpty)! { return 1 }
        if (self.post?.imgUrl3.isEmpty)! { return 2 }
        if (self.post?.imgUrl4.isEmpty)! { return 3 }
        if (self.post?.imgUrl5.isEmpty)! { return 4 }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentity.imagePreviewCell, for: indexPath) as! ImagePreviewCell
        
        print("postId: \(self.post!.id)")
        print("indexPath: \(indexPath.row)")
        
        var imageUrl: String!
        
        if indexPath.row == 0 { imageUrl = self.post!.imgUrl1 }
        else if indexPath.row == 1 { imageUrl = self.post!.imgUrl2 }
        else if indexPath.row == 2 { imageUrl = self.post!.imgUrl3 }
        else if indexPath.row == 3 { imageUrl = self.post!.imgUrl4 }
        else if indexPath.row == 4 { imageUrl = self.post!.imgUrl5 }
        
        cell.imageView.af_setImage(withURL: URL(string: imageUrl)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("postId: \(self.post!.id)")
        //performSegue(withIdentifier: SegueIdentity.profileLikeToDetail, sender: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageCollectionView.delegate = nil
        self.imageCollectionView.dataSource = nil
        self.profileThumbnailImageView.image = nil
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var image: Image?
        
        if indexPath.row == 0 { image = self.img1 }
        else if indexPath.row == 1 { image = self.img2 }
        else if indexPath.row == 2 { image = self.img3 }
        else if indexPath.row == 3 { image = self.img4 }
        else { image = self.img5 }
        
        var size: CGSize?

        if image!.size.width > image!.size.height {
            size = CGSize(width: (320 / 3 * 4), height: 320)
        } else {
            size = CGSize(width: 240.0, height: 320.0)
        }

        return size!
    }
}

