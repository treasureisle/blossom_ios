//
//  FeedCell.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 15..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var profileThumbnailImageView: UIImageView!
    @IBOutlet weak var profileNicknameLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    
    var post: Post?
    
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
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.delegate = self
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
        
        if indexPath.row == 0 { cell.imageView.af_setImage(withURL: URL(string: self.post!.imgUrl1)!) }
        if indexPath.row == 1 { cell.imageView.af_setImage(withURL: URL(string: self.post!.imgUrl2)!) }
        if indexPath.row == 2 { cell.imageView.af_setImage(withURL: URL(string: self.post!.imgUrl3)!) }
        if indexPath.row == 3 { cell.imageView.af_setImage(withURL: URL(string: self.post!.imgUrl4)!) }
        if indexPath.row == 4 { cell.imageView.af_setImage(withURL: URL(string: self.post!.imgUrl5)!) }
        
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
}

