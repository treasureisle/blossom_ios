//
//  SingInViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 17..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Mixpanel

class SignInViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var signinBottomConstraint: NSLayoutConstraint!
    
    final let signInTitle = NSLocalizedString("APP_TITLE", comment: "")
    final let emailPlaceHolder = NSLocalizedString("EMAIL", comment: "")
    final let passwordPlaceHolder = NSLocalizedString("PASSWORD", comment: "")
    final let passwordConfirmPlaceHolder = NSLocalizedString("PASSWORD_CONFIRM", comment: "")
    final let nicknamePlaceHolder = NSLocalizedString("NICKNAME", comment: "")
    
    let imagePicker = UIImagePickerController()
    
    var unwindSegueIdentity: String?
    var profileThumbnailData: Data? = nil
    var isPickedThumbnail: Bool = false
    var keyboardObserver: KeyboardObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        profileImageView.makeCircularImageView()
        emailTextField.placeholder = emailPlaceHolder
        passwordTextField.placeholder = passwordPlaceHolder
        passwordConfirmTextField.placeholder = passwordConfirmPlaceHolder
        nicknameTextField.placeholder = nicknamePlaceHolder
        
        keyboardObserver = KeyboardObserver(bottomConstraint: signinBottomConstraint, rootView: self.view)
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
    
    @IBAction func signinButtonTouched(){
        
        if isInvalidEmail() {
            return
        }
        
        let imageData = self.profileThumbnailData
        _ = BlossomRequest.upload(.post, urlString: Api.users, multipartFormData: { multipartFormData in
            if imageData != nil {
            multipartFormData.append(imageData!, withName: "profile_thumb", fileName: "profile_thumb.jpg", mimeType: "image/jpg")
            }
            multipartFormData.append("email".data(using: String.Encoding.utf8)!, withName: "reg_type")
            multipartFormData.append((self.emailTextField.text?.data(using: String.Encoding.utf8))!, withName: "email")
            multipartFormData.append((self.passwordTextField.text?.data(using: String.Encoding.utf8))!, withName: "password")
            multipartFormData.append((self.nicknameTextField.text?.data(using: String.Encoding.utf8))!, withName: "username")
            }, completionHandler: {
                response, statusCode, json in
                
                if statusCode == 200{
                    self.login(email: self.emailTextField.text!, password: self.passwordTextField.text!)
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
    
    func isInvalidEmail() -> Bool {
        if !emailTextField.text!.isMatch(Regex.email){
            self.view.makeErrorToast(message: NSLocalizedString("DOESNT_LOOK_LIKE_EMAIL", comment: "이메일 형식에 어긋났을 경우 표시"))
            emailTextField.setAccentBorder()
            
            return true
        }
        
        return false
    }
    
    func login(email: String, password: String) {
        let params = [
            "email":email,
            "password":password
        ]
        
        //로그인 진행
        _ = BlossomRequest.request(method: .post, endPoint: Api.sessionEmail, params: params as [String : AnyObject]?) {
            response, statusCode, json in
            
            var isOtherError = false
            
            if statusCode == 200{
                // 저장하고 메인으로 넘어가기
                let me = Session(o: json["session"])
                me.save()
                self.view.makeToast(message: "가입완료. 로그인되었습니다")
                self.dismiss(animated: true, completion: nil)
                
            }else{
                let errorMsg = ErrorMsg(o: json)
                if statusCode == 404{
                    if errorMsg.message.range(of: "user not found") != nil{
                        self.view.makeErrorToast(message: NSLocalizedString("USER_NOT_FOUND", comment: "유저가 없을 경우 표시"))
                    }else{
                        isOtherError = true
                    }
                }else if statusCode == 400{
                    if errorMsg.message.range(of: "wrong password") != nil{
                        self.view.makeErrorToast(message: NSLocalizedString("PASSWORD_IS_WRONG", comment: "비밀번호가 틀렸을 경우 표시"))
                    }else{
                        isOtherError = true
                    }
                }else{
                    isOtherError = true
                }
                
            }
            
            if isOtherError {
                self.view.makeSomethingWrongToast()
            }
        }
    }
}
