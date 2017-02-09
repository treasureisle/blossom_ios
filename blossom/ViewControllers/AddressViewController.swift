//
//  AddressViewController.swift
//  blossom
//
//  Created by Seong Phil on 2017. 1. 20..
//  Copyright © 2017년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class AddressViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressDetailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var pickerViewTool: UIToolbar!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancleButton: UIBarButtonItem!
    @IBOutlet weak var zipCodePickerView: UIPickerView!

    
    let imagePicker = UIImagePickerController()
    
    var unwindSegueIdentity: String?
    var profileThumbnailData: Data? = nil
    var isPickedThumbnail: Bool = false
    var keyboardObserver: KeyboardObserver?
    var searchedAddress = [Address]()
    var searchedAddressString = [String]()
    var userId: Int = 0
    var me: Session?
    var activeTF: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        me = Session.load()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        zipCodePickerView.delegate = self
        zipCodePickerView.dataSource = self
        profileImageView.makeCircularImageView()
        zipCodeTextField.delegate = self
        nameTextField.delegate = self
        addressTextField.delegate = self
        addressDetailTextField.delegate = self
        phoneTextField.delegate = self
        
        keyboardObserver = KeyboardObserver(bottomConstraint: addressBottomConstraint, rootView: self.view)
        keyboardObserver!.startObserving()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    deinit {
        keyboardObserver!.stopObserving()
    }
    
    // MARK: Selector
    @IBAction func cancelTouched(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickButtonTouched(){
        //        Mixpanel.sharedInstance().track(MixpanelTrack.changeProfileImage)
        let alert = UIAlertController(title: "Select", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take a picture", style: .default, handler: { action in
            //            Mixpanel.sharedInstance().track(MixpanelTrack.takeProfilePicture)
            self.takePhoto()
        }))
        alert.addAction(UIAlertAction(title: "Camera Album", style: .default, handler: { action in
            //            Mixpanel.sharedInstance().track(MixpanelTrack.uploadProfileImage)
            self.cameraRoll()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTouched(){
        
        let imageData = self.profileThumbnailData
        _ = BlossomRequest.upload(.post, urlString: "\(Api.userDetail)/\(self.userId)", multipartFormData: { multipartFormData in
            if imageData != nil {
                multipartFormData.append(imageData!, withName: "profile_thumb", fileName: "profile_thumb.jpg", mimeType: "image/jpg")
            }
            let name = self.nameTextField.text!
            let zipCode = self.zipCodeTextField.text!
            let address = self.addressTextField.text!
            let addressDetail = self.addressDetailTextField.text!
            let phone = self.phoneTextField.text!
            
            if name.isEmpty == false {
                multipartFormData.append(name.data(using: String.Encoding.utf8)!, withName: "name")
            }
            if zipCode.isEmpty == false {
                multipartFormData.append(zipCode.data(using: String.Encoding.utf8)!, withName: "zipcode")
            }
            if address.isEmpty == false {
                multipartFormData.append(address.data(using: String.Encoding.utf8)!, withName: "address1")
            }
            if addressDetail.isEmpty == false {
                multipartFormData.append(addressDetail.data(using: String.Encoding.utf8)!, withName: "address2")
            }
            if phone.isEmpty == false {
                multipartFormData.append(phone.data(using: String.Encoding.utf8)!, withName: "name")
            }
            
        }, completionHandler: {
            response, statusCode, json in
            
            if statusCode == 200{

            }else{
                self.view.makeSomethingWrongToast()
            }
        })
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profileImageView.image = image
            self.isPickedThumbnail = true
            self.profileThumbnailData = UIImageJPEGRepresentation(image, 1)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
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
    
    func searchZipCode(){
        
        let params = [
            "confmKey":Config.postalApiKey,
            "currentPage":"1",
            "countPerPage":"50",
            "keyword":"행신동",
            "resultType":"json"
        ]
        
        _ = BlossomRequest.requestStringToJSON(method: .get, endPoint: Api.postalSearch, params: params as [String : String]?) {

            response, statusCode, json in
        
            if statusCode == 200{
                print(json.rawString() ?? "")
                self.searchedAddress.removeAll()
                let addresses = json["results"]["juso"].arrayValue
                
                for addressObject in addresses{
                    let address = Address(o: addressObject)
                    self.searchedAddress.append(address)
                    self.searchedAddressString.append(address.jibunAddr)
                    print(address.zipNo)
                }
                
                self.zipCodePickerView.reloadAllComponents()
                self.pickerView.isHidden = false
            }else{
                self.view.makeSomethingWrongToast()
            }
        }
    }
    
    // done
    @IBAction func doneClick() {
        pickerView.isHidden = true
        
    }
    
    // cancel
    @IBAction func cancelClick() {
        pickerView.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTF = textField
        if activeTF == zipCodeTextField {

            self.searchZipCode()
            self.zipCodeTextField.endEditing(true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.zipCodeTextField.text = "\(searchedAddress[row].zipNo)"
        self.addressTextField.text = searchedAddress[row].roadAddr
        return searchedAddressString[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchedAddressString.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        zipCodeTextField.text = searchedAddressString[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
