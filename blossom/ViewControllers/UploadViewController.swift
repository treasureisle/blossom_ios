//
//  UploadViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 24..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import UIKit

class UploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var buttonImage1: UIButton!
    @IBOutlet weak var buttonImage2: UIButton!
    @IBOutlet weak var buttonImage3: UIButton!
    @IBOutlet weak var buttonImage4: UIButton!
    @IBOutlet weak var buttonImage5: UIButton!
    @IBOutlet weak var pictureDimButton: UIButton!
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var albumButtom: UIButton!
    @IBOutlet weak var pictureLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var uploadButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var originPriceTextField: UITextField!
    @IBOutlet weak var purchasePriceTextField: UITextField!
    @IBOutlet weak var feeTextField: UITextField!
    @IBOutlet weak var deliveryFeeTextField: UITextField!
    @IBOutlet weak var colorSizeTextField: UITextField!
    @IBOutlet weak var availableTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var hashtagTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var colorSizeLabel: UILabel!
    @IBOutlet weak var hashtagLabel: UILabel!
    
    @IBOutlet weak var hashtagHeightConstraints:NSLayoutConstraint!
    @IBOutlet weak var colorSizeHeightConstraints:NSLayoutConstraint!
    
    let imagePicker = UIImagePickerController()
    var regionDownPicker: DownPicker?
    var keyboardObserver: KeyboardObserver?
    var postType: Int = 0 //0:판매 1:구매 2:리뷰
    var imageNumber: Int = 0
    var imageData1: Data? = nil
    var imageData2: Data? = nil
    var imageData3: Data? = nil
    var imageData4: Data? = nil
    var imageData5: Data? = nil
    var colorSizes = [String]()
    var available = [String]()
    var hashtags = [String]()
    var lastColorSizeLabel: UILabel? = nil
    var lastHashtagLabel: UILabel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.touches(_:))))
        regionDownPicker = DownPicker(textField: regionTextField, withData: ImageName.regions)
        keyboardObserver = KeyboardObserver(bottomConstraint: uploadButtonBottomConstraint, rootView: self.view)
        keyboardObserver!.startObserving()
        print("postType:\(self.postType)")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func touches(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelTouched(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addColorSize(){
        if colorSizes.count == 5 {
            self.view.makeToast(message: "최대 갯수 초과")
            return
        }
        
        if colorSizeTextField?.text?.isEmpty == false {
            
            colorSizes.append((colorSizeTextField?.text)!)
            
            var available = "1"
            if availableTextField?.text?.isEmpty == false {
                available = availableTextField!.text!
            }
            self.available.append(available)
            
            var colorsizeString: String = ""
            for colorsize in colorSizes {
                if colorsizeString.isEmpty {
                    colorsizeString = "\(colorsize) : \(available)"
                } else {
                    colorsizeString = "\(colorsizeString)\n\(colorsize) : \(available)"
                }
            }
            
            self.colorSizeTextField?.text = ""
            self.availableTextField?.text = ""
            
            self.colorSizeLabel?.text = colorsizeString
            updateColorsizeConstraints()
        }
    }
    
    @IBAction func addHashtag(){
        if hashtags.count == 5 {
            self.view.makeToast(message: "최대 갯수 초과")
            return
        }
        
        if hashtagTextField?.text?.isEmpty == false {
            
            hashtags.append((hashtagTextField?.text)!)
            
            var hashtagString: String = ""
            for hashtag in hashtags {
                if hashtagString.isEmpty {
                    hashtagString = "#\(hashtag)"
                } else {
                    hashtagString = "\(hashtagString)\n#\(hashtag)"
                }
            }
            
            self.hashtagTextField?.text = ""
            
            self.hashtagLabel?.text = hashtagString
            updateHashtagConstraints()

        }
    }
    
    @IBAction func uploadTouched(){
        _ = BlossomRequest.upload(.post, urlString: Api.posts, multipartFormData: { multipartFormData in
            
            if let image1 = self.imageData1{
                multipartFormData.append(image1, withName: "img1", fileName: "img1.jpg", mimeType: "image/jpg")
            }
            if let image2 = self.imageData2{
                multipartFormData.append(image2, withName: "img2", fileName: "img2.jpg", mimeType: "image/jpg")
            }
            if let image3 = self.imageData3{
                multipartFormData.append(image3, withName: "img3", fileName: "img3.jpg", mimeType: "image/jpg")
            }
            if let image4 = self.imageData4{
                multipartFormData.append(image4, withName: "img4", fileName: "img4.jpg", mimeType: "image/jpg")
            }
            if let image5 = self.imageData5{
                multipartFormData.append(image5, withName: "img5", fileName: "img5.jpg", mimeType: "image/jpg")
            }
            multipartFormData.append((String(self.postType).data(using: String.Encoding.utf8))!, withName: "post_type")
            multipartFormData.append((self.titleTextField?.text?.data(using: String.Encoding.utf8))!, withName: "title")
            multipartFormData.append((self.brandTextField?.text?.data(using: String.Encoding.utf8))!, withName: "brand")
            multipartFormData.append((self.productNameTextField?.text?.data(using: String.Encoding.utf8))!, withName: "product_name")
            multipartFormData.append((self.originPriceTextField?.text?.data(using: String.Encoding.utf8))!, withName: "origin_price")
            multipartFormData.append((self.purchasePriceTextField?.text?.data(using: String.Encoding.utf8))!, withName: "purchase_price")
            multipartFormData.append((self.feeTextField?.text?.data(using: String.Encoding.utf8))!, withName: "fee")
            let region = ImageName.regions.index(of: self.regionTextField.text!)
            multipartFormData.append((String(region!).data(using: String.Encoding.utf8))!, withName: "region")
            multipartFormData.append((self.hashtagTextField?.text?.data(using: String.Encoding.utf8))!, withName: "hashtag")
            multipartFormData.append((self.detailTextView?.text?.data(using: String.Encoding.utf8))!, withName: "text")

        }, completionHandler: {
            response, statusCode, json in
            
            if statusCode == 200{
                
                let post = Post(o: json["posts"])
                
                _ = BlossomRequest.upload(.post, urlString: "\(Api.colorSize)/\(post.id)", multipartFormData: { multipartFormData in
                
                    multipartFormData.append((String(self.colorSizes.count).data(using: String.Encoding.utf8))!, withName: "count")
                    
                    if self.colorSizes.count > 0 {
                        multipartFormData.append((self.colorSizes[0].data(using: String.Encoding.utf8))!, withName: "name1")
                        multipartFormData.append((self.available[0].data(using: String.Encoding.utf8))!, withName: "available1")
                    }
                
                    if self.colorSizes.count > 1 {
                        multipartFormData.append((self.colorSizes[1].data(using: String.Encoding.utf8))!, withName: "name2")
                        multipartFormData.append((self.available[1].data(using: String.Encoding.utf8))!, withName: "available2")
                    }
                    
                    if self.colorSizes.count > 2 {
                        multipartFormData.append((self.colorSizes[2].data(using: String.Encoding.utf8))!, withName: "name3")
                        multipartFormData.append((self.available[2].data(using: String.Encoding.utf8))!, withName: "available3")
                    }
                    
                    if self.colorSizes.count > 3 {
                        multipartFormData.append((self.colorSizes[3].data(using: String.Encoding.utf8))!, withName: "name4")
                        multipartFormData.append((self.available[3].data(using: String.Encoding.utf8))!, withName: "available4")
                    }
                    
                    if self.colorSizes.count > 4 {
                        multipartFormData.append((self.colorSizes[4].data(using: String.Encoding.utf8))!, withName: "name5")
                        multipartFormData.append((self.available[4].data(using: String.Encoding.utf8))!, withName: "available5")
                    }
                }, completionHandler: {
                    response, statusCode, json in
                    
                    if statusCode == 200{
                    }
                })
            
                _ = BlossomRequest.upload(.post, urlString: "\(Api.hashtag)/\(post.id)", multipartFormData: { multipartFormData in
                    
                    multipartFormData.append((String(self.hashtags.count).data(using: String.Encoding.utf8))!, withName: "count")
                    
                    if self.hashtags.count > 0 {
                        multipartFormData.append((self.hashtags[0].data(using: String.Encoding.utf8))!, withName: "name1")
                    }
                    
                    if self.hashtags.count > 1 {
                        multipartFormData.append((self.hashtags[1].data(using: String.Encoding.utf8))!, withName: "name2")
                    }
                    
                    if self.hashtags.count > 2 {
                        multipartFormData.append((self.hashtags[2].data(using: String.Encoding.utf8))!, withName: "name3")
                    }
                    
                    if self.hashtags.count > 3 {
                        multipartFormData.append((self.hashtags[3].data(using: String.Encoding.utf8))!, withName: "name4")
                    }
                    
                    if self.hashtags.count > 4 {
                        multipartFormData.append((self.hashtags[4].data(using: String.Encoding.utf8))!, withName: "name5")
                    }
                }, completionHandler: {
                    response, statusCode, json in
                    
                    if statusCode == 200{
                    }
                })

                
                self.dismiss(animated: true, completion: nil)
            }else{
                self.view.makeSomethingWrongToast()
            }
        })
    }
    
    @IBAction func dimTouched(){
        self.pictureDimButton?.isHidden = true
        self.pictureDimButton?.isEnabled = false
        self.pictureView?.isHidden = true
        self.cameraButton?.isEnabled = false
        self.albumButtom?.isEnabled = false
    }
    
    @IBAction func image1Touched(){
        self.imageNumber = 0
        imageTouched()
    }
    
    @IBAction func image2Touched(){
        self.imageNumber = 1
        imageTouched()
    }
    
    @IBAction func image3Touched(){
        self.imageNumber = 2
        imageTouched()
    }
    
    @IBAction func image4Touched(){
        self.imageNumber = 3
        imageTouched()
    }
    
    @IBAction func image5Touched(){
        self.imageNumber = 4
        imageTouched()
    }
    
    @IBAction func cameraTouched(){
        self.takePhoto()
        self.pictureDimButton?.isHidden = true
        self.pictureDimButton?.isEnabled = false
        self.pictureView?.isHidden = true
        self.cameraButton?.isEnabled = false
        self.albumButtom?.isEnabled = false
    }
    
    @IBAction func albumTouched(){
        self.cameraRoll()
        self.pictureDimButton?.isHidden = true
        self.pictureDimButton?.isEnabled = false
        self.pictureView?.isHidden = true
        self.cameraButton?.isEnabled = false
        self.albumButtom?.isEnabled = false
    }
    
    func imageTouched(){
        self.pictureLeadingConstraint.constant = self.buttonImage1!.frame.size.width * CGFloat(self.imageNumber) - ((self.imageNumber < 3) ? 0: 80.0)
        self.pictureDimButton?.isHidden = false
        self.pictureDimButton?.isEnabled = true
        self.pictureView?.isHidden = false
        self.cameraButton?.isEnabled = true
        self.albumButtom?.isEnabled = true
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if self.imageNumber == 0 {
                self.buttonImage1?.setImage(image, for: .normal)
                self.buttonImage1?.setTitle("", for: .normal)
                self.imageData1 = UIImageJPEGRepresentation(image, 1)
                self.buttonImage2?.isEnabled = true
            } else if self.imageNumber == 1 {
                self.buttonImage2?.setImage(image, for: .normal)
                self.buttonImage2?.setTitle("", for: .normal)
                self.imageData2 = UIImageJPEGRepresentation(image, 1)
                self.buttonImage3?.isEnabled = true
            } else if self.imageNumber == 2 {
                self.buttonImage3?.setImage(image, for: .normal)
                self.buttonImage3?.setTitle("", for: .normal)
                self.imageData3 = UIImageJPEGRepresentation(image, 1)
                self.buttonImage4?.isEnabled = true
            }else if self.imageNumber == 3 {
                self.buttonImage4?.setImage(image, for: .normal)
                self.buttonImage4?.setTitle("", for: .normal)
                self.imageData4 = UIImageJPEGRepresentation(image, 1)
                self.buttonImage5?.isEnabled = true
            }else if self.imageNumber == 4 {
                self.buttonImage5?.setImage(image, for: .normal)
                self.buttonImage5?.setTitle("", for: .normal)
                self.imageData5 = UIImageJPEGRepresentation(image, 1)
            }
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func updateColorsizeConstraints() {
        colorSizeHeightConstraints.constant = CGFloat(18 * colorSizes.count)
        
        UIView.animate(withDuration: 0.5, delay: TimeInterval(0), options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            // do nothing..
        })
    }
    
    func updateHashtagConstraints() {
        
        hashtagHeightConstraints.constant = CGFloat(18 * hashtags.count)
        
        UIView.animate(withDuration: 0.5, delay: TimeInterval(0), options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            // do nothing..
        })
    }
    
    // MARK: Custom
    func takePhoto(){
        imagePicker.sourceType = .camera
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    func cameraRoll(){
        imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
    }
    
}
