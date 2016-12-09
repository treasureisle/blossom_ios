//
//  DetailViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 28..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageScrollView: UIScrollView?
    @IBOutlet weak var writerProfileImageView: UIImageView?
    @IBOutlet weak var writerProfileNameLabel: UILabel?
    @IBOutlet weak var writerProfileDetail: UILabel?
    @IBOutlet weak var brandLabel: UILabel?
    @IBOutlet weak var productNameLabel: UILabel?
    @IBOutlet weak var priceLabel: UILabel?
    @IBOutlet weak var colorSizeLabel: UILabel?
    @IBOutlet weak var locationLabel: UILabel?
    @IBOutlet weak var hashtagLabel: UILabel?
    @IBOutlet weak var detailTextView: UITextView?
    @IBOutlet weak var img1ImageView: UIImageView?
    @IBOutlet weak var purchaseView: UIView?
    @IBOutlet weak var purchaseTitleLabel: UILabel?
    @IBOutlet weak var colorSizeNamesTextField: UITextField?
    @IBOutlet weak var colorSizeAmountTextField: UITextField?
    
    var colorSizes: [ColorSize] = []
    var hashtags: [Hashtag] = []
    var colorSizeNames: [String] = []
    var colorSizeAmounts: [Int] = []
    var postId: Int = 0
    var postDetail: PostDetail? = nil
    var colorSizeNamesDownPicker: DownPicker!
    var colorSizeAmountDownPicker: DownPicker!
    
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
                let postDetail = PostDetail(o: post)
                self.postDetail = postDetail
                
                self.img1ImageView?.af_setImage(withURL: URL(string:postDetail.imgUrl1)!)
                self.writerProfileImageView?.af_setImage(withURL: URL(string:postDetail.user.profileThumbUrl)!)
                self.writerProfileNameLabel?.text = postDetail.user.username
                self.writerProfileDetail?.text = postDetail.user.introduce
                self.brandLabel?.text = postDetail.brand
                self.priceLabel?.text = "\(postDetail.purchasePrice)+\(postDetail.fee)"
                self.locationLabel?.text = postDetail.region
                self.hashtagLabel?.text = postDetail.hashtag
                self.detailTextView?.text = postDetail.text
                
            }
        }
        
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.colorSize)/\(self.postId)") { (response, statusCode, json) -> () in
            if statusCode == 200{
                let colorSizes = json["color_size"].arrayValue
                
                for colorSize in colorSizes {
                    let tempColorSize = ColorSize(o: colorSize)
                    self.colorSizes.append(tempColorSize)
                    self.colorSizeNames.append(tempColorSize.name)
                    self.colorSizeAmounts.append(tempColorSize.available)
                }
            }
        }
        
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.hashtag)/\(self.postId)") { (response, statusCode, json) -> () in
            if statusCode == 200{
                let hashtags = json["hashtag"].arrayValue
                
                for hashtag in hashtags {
                    self.hashtags.append(Hashtag(o: hashtag))
                }
            }
        }
        
        self.colorSizeNamesDownPicker = DownPicker(textField: self.colorSizeNamesTextField, withData: colorSizeNames)
        self.colorSizeAmountDownPicker = DownPicker(textField: self.colorSizeAmountTextField, withData: colorSizeAmounts)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadPost(){
        
    }
}
