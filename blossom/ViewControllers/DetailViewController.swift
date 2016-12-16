//
//  DetailViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 28..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var writerProfileImageView: UIImageView!
    @IBOutlet weak var writerProfileNameLabel: UILabel!
    @IBOutlet weak var writerProfileDetail: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var colorSizeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hashtagLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var purchaseView: UIView!
    @IBOutlet weak var purchaseTitleLabel: UILabel!
    @IBOutlet weak var colorSizeNamesTextField: UITextField!
    @IBOutlet weak var colorSizeAmountTextField: UITextField!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    
    var colorSizes: [ColorSize] = []
    var hashtags: [Hashtag] = []
    var colorSizeNames: [String] = []
    var colorSizeAmounts: [Int] = []
    var postId: Int = 0
    var post: Post? = nil
    var colorSizeNamesDownPicker: DownPicker!
    var colorSizeAmountDownPicker: DownPicker!
    
    var img1: Image?
    var img2: Image?
    var img3: Image?
    var img4: Image?
    var img5: Image?
    
    @IBAction func cancleTouched() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func messageTouched() {
        
    }
    
    @IBAction func cartTouched() {
        
    }
    
    @IBAction func likeTouched() {
        
    }
    
    @IBAction func replyTouched() {
        
    }
    
    @IBAction func shareTouched() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.writerProfileImageView?.makeCircularImageView()
        
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.post)/\(self.postId)") { (response, statusCode, json) -> () in
            if statusCode == 200{
                let post = json["post"]
                let postDetail = Post(o: post)
                self.post = postDetail
                
                self.writerProfileImageView?.af_setImage(withURL: URL(string:postDetail.user.profileThumbUrl)!)
                self.writerProfileNameLabel?.text = postDetail.user.username
                self.writerProfileDetail?.text = postDetail.user.introduce
                self.brandLabel?.text = "\(NSLocalizedString("BRAND", comment: "")): \(postDetail.brand)"
                self.productNameLabel?.text = "\(NSLocalizedString("PRODUCT_NAME", comment: "")): \(postDetail.productName)"
                self.priceLabel?.text = "\(NSLocalizedString("PRICE", comment: "")): \(postDetail.purchasePrice)+\(postDetail.fee)"
                self.locationLabel?.text = "\(NSLocalizedString("REGION", comment: "")): \(postDetail.region)"
                self.detailTextView?.text = postDetail.text
                self.likeLabel?.text = String(postDetail.likes)
                self.replyLabel?.text = String(postDetail.replys)
                
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
        }
        
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.colorSize)/\(self.postId)") { (response, statusCode, json) -> () in
            if statusCode == 200{
                let colorSizes = json["color_sizes"].arrayValue
                
                var colorSizeLabelText = "\(NSLocalizedString("AVAILABLE", comment: "")):"
                
                for colorSize in colorSizes {
                    let tempColorSize = ColorSize(o: colorSize)
                    self.colorSizes.append(tempColorSize)
                    self.colorSizeNames.append(tempColorSize.name)
                    self.colorSizeAmounts.append(tempColorSize.available)
                    colorSizeLabelText = "\(colorSizeLabelText)\n\(tempColorSize.name)  \(tempColorSize.available)"
                }
                self.colorSizeLabel.text = colorSizeLabelText
                self.colorSizeLabel.sizeToFit()
            }
        }
        
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.hashtag)/\(self.postId)") { (response, statusCode, json) -> () in
            if statusCode == 200{
                let hashtags = json["hashtag"].arrayValue
                
                var hashtagLabelText = ""
                
                for hashtag in hashtags {
                    let tempHashtag = Hashtag(o: hashtag)
                    self.hashtags.append(tempHashtag)
                    hashtagLabelText = "\(hashtagLabelText)#\(tempHashtag.name) "
                }
                self.hashtagLabel.text = hashtagLabelText
                self.hashtagLabel.sizeToFit()

            }
        }
        
        self.writerProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.profileTouched(_:))))
        self.writerProfileImageView.isUserInteractionEnabled = true
        self.writerProfileNameLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.profileTouched(_:))))
        self.writerProfileNameLabel.isUserInteractionEnabled = true
        self.writerProfileDetail.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.profileTouched(_:))))
        self.writerProfileDetail.isUserInteractionEnabled = true
        
        self.colorSizeNamesDownPicker = DownPicker(textField: self.colorSizeNamesTextField, withData: colorSizeNames)
        self.colorSizeAmountDownPicker = DownPicker(textField: self.colorSizeAmountTextField, withData: colorSizeAmounts)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.detailToProfile {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.userId = self.post?.user.id
        }
    }
    
    func profileTouched(_ sender: UITapGestureRecognizer){
        performSegue(withIdentifier: SegueIdentity.detailToProfile, sender: self)
    }
    
    func loadPost(){
        
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
