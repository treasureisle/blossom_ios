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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var colorSizeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hashtagLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var purchaseView: UIView!
    @IBOutlet weak var purchaseTitleLabel: UILabel!
    @IBOutlet weak var colorSizeNamesTextField: UITextField!
    @IBOutlet weak var colorSizeAmountTextField: UITextField!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var putCartButton: UIButton!
    
    var me: Session?
    var colorSizes: [ColorSize] = []
    var hashtags: [Hashtag] = []
    var colorSizeNames: [String] = []
    var colorSizeAmounts: [String] = []
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
        if self.purchaseView.isHidden {
            self.purchaseView.isHidden = false
        } else {
            self.purchaseView.isHidden = true
        }
    }
    
    @IBAction func likeTouched() {
        if self.post!.isLiked {
            _ = BlossomRequest.request(method: .delete, endPoint: "\(Api.like)/\(self.postId)") { (response, statusCode, json) -> () in
                if statusCode == 200{
                    self.post!.isLiked = false
                    self.post!.likes -= 1
                    self.likeLabel.text = String(self.post!.likes)
                } else if statusCode == 404 {
                    self.post!.isLiked = false
                    
                }
            }
        } else {
            _ = BlossomRequest.request(method: .post, endPoint: "\(Api.like)/\(self.postId)") { (response, statusCode, json) -> () in
                if statusCode == 200{
                    self.post!.isLiked = true
                    self.post!.likes += 1
                    self.likeLabel.text = String(self.post!.likes)
                } else if statusCode == 409 {
                    self.post!.isLiked = true
                }
            }
        }
    }
    
    @IBAction func replyTouched() {
        performSegue(withIdentifier: SegueIdentity.detailToReply, sender: self)
    }
    
    @IBAction func shareTouched() {
        
    }
    
    @IBAction func putCart() {
        if self.me != nil{
            var selectedColorSize: ColorSize?
            
            for colorSize in self.colorSizes {
                if colorSize.name == self.colorSizeNamesDownPicker.text! {
                    selectedColorSize = colorSize
                }
            }
            _ = BlossomRequest.upload(.post, urlString: "\(Api.basket)/\(self.postId)", multipartFormData: { multipartFormData in
                multipartFormData.append(("\(selectedColorSize!.id)".data(using: String.Encoding.utf8))!, withName: "color_size_id")
                multipartFormData.append((self.colorSizeAmountDownPicker.text!.data(using: String.Encoding.utf8))!, withName: "amount")
            }, completionHandler:  {
                response, statusCode, json in
                
                if statusCode == 200{
                    let alert = BlossomAlertController(message: "장바구니에 담았습니다. 장바구니로 이동하시겠습니까?")
                    alert.addAction(action: BlossomAlertAction(title: "머무르기", style: .Positive, handler: nil))
                    alert.addAction(action: BlossomAlertAction(title: "이동", style: .Negative, handler: {
                        action in
                        if self.presentedViewController == nil {
                            self.performSegue(withIdentifier: SegueIdentity.detailToCart, sender: self)
                        } else {
                            self.dismiss(animated: false) {
                                () -> Void in
                                self.performSegue(withIdentifier: SegueIdentity.detailToCart, sender: self)
                            }
                        }
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    self.view.makeSomethingWrongToast()
                }
            })
        } else {
            let alert = LoginAlertController()
            alert.setSigninAction(action: SigninAction(handler: {
                action in
                if self.presentedViewController == nil {
                    self.performSegue(withIdentifier: SegueIdentity.jumpToSignin, sender: self)
                } else {
                    self.dismiss(animated: false) {
                        () -> Void in
                        self.performSegue(withIdentifier: SegueIdentity.jumpToSignin, sender: self)
                    }
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.me = Session.load()
        self.writerProfileImageView?.makeCircularImageView()
        self.putCartButton.isEnabled = false
        
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.post)/\(self.postId)") { (response, statusCode, json) -> () in
            if statusCode == 200{
                let post = json["post"]
                let postDetail = Post(o: post)
                self.post = postDetail
                
                self.writerProfileImageView?.af_setImage(withURL: URL(string:postDetail.user.profileThumbUrl)!)
                self.writerProfileNameLabel?.text = postDetail.user.username
                self.writerProfileDetail?.text = postDetail.user.introduce
                self.titleLabel?.text = "\(NSLocalizedString("TITLE", comment: "")): \(postDetail.title)"
                self.brandLabel?.text = "\(NSLocalizedString("BRAND", comment: "")): \(postDetail.brand)"
                self.productNameLabel?.text = "\(NSLocalizedString("PRODUCT_NAME", comment: "")): \(postDetail.productName)"
                self.priceLabel?.text = "\(NSLocalizedString("PRICE", comment: "")): \(postDetail.purchasePrice)+\(postDetail.fee)"
                self.locationLabel?.text = "\(NSLocalizedString("REGION", comment: "")): \(postDetail.region)"
                self.detailLabel?.text = postDetail.text
                self.detailLabel?.sizeToFit()
                self.likeLabel?.text = String(postDetail.likes)
                self.replyLabel?.text = String(postDetail.replies)
                self.purchaseTitleLabel?.text = postDetail.productName
                
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
                    self.colorSizeAmounts.append(String(tempColorSize.available))
                    colorSizeLabelText = "\(colorSizeLabelText)\n  \(tempColorSize.name) - \(tempColorSize.available)"
                }
                self.colorSizeLabel.text = colorSizeLabelText
                self.colorSizeLabel.sizeToFit()
                
                self.colorSizeNamesDownPicker = DownPicker(textField: self.colorSizeNamesTextField, withData: self.colorSizeNames)
                self.colorSizeNamesDownPicker.addTarget(self, action: #selector(self.colorSizeNameSelected(dp:)), for: .valueChanged)
            }
        }
        
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.hashtag)/\(self.postId)") { (response, statusCode, json) -> () in
            if statusCode == 200{
                let hashtags = json["hashtag"].arrayValue
                
                var hashtagLabelText = ""
                
                for hashtag in hashtags {
                    let tempHashtag = Hashtag(o: hashtag)
                    if tempHashtag.hidden == 0 {
                        self.hashtags.append(tempHashtag)
                        hashtagLabelText = "\(hashtagLabelText)#\(tempHashtag.name) "
                    }
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
        
        self.colorSizeAmountTextField.isUserInteractionEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.detailToProfile {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.userId = self.post?.user.id
        } else if segue.identifier == SegueIdentity.detailToReply {
            let replyViewController = segue.destination as! ReplyViewController
            replyViewController.postId = self.postId
        } 
    }
    
    func colorSizeNameSelected(dp: Any?) {
        self.colorSizeAmountTextField.isUserInteractionEnabled = true
        let selectedValue = self.colorSizeNamesDownPicker.text
    // do what you want
        self.colorSizeAmounts.removeAll()
        
        for colorSize in self.colorSizes {
            if colorSize.name == selectedValue {
                print("selectied: \(colorSize.name)")
                for i in (0..<colorSize.available){
                    self.colorSizeAmounts.append(String(i+1))
                }
                break
            }
        }
        
        self.colorSizeAmountDownPicker = DownPicker(textField: self.colorSizeAmountTextField, withData: self.colorSizeAmounts)
        
        self.colorSizeAmountDownPicker.addTarget(self, action: #selector(self.amountSelected(dp:)), for: .valueChanged)
    }
    
    func amountSelected(dp: Any?) {
        self.putCartButton.isEnabled = true
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
