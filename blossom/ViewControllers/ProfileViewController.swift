//
//  ProfileViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 9..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import PagingMenuController

class ProfileViewController: UIViewController {
    // MARK: lifecycle
    
    @IBOutlet weak var imageProfile: UIImageView?
    @IBOutlet weak var labelName: UILabel?
    @IBOutlet weak var labelFollowing: UILabel?
    @IBOutlet weak var labelFollower: UILabel?
    @IBOutlet weak var buttonMessage: UIButton?
    @IBOutlet weak var buttonFollow: UIButton?
    @IBOutlet weak var buttonPurchaseList: UIButton?
    @IBOutlet weak var buttonSetting: UIButton?
    
    var me: Session?
    var userId: Int?
    var followings: [Follow] = []
    var followers: [Follow] = []
    var isFollowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.me = Session.load()
        
        self.imageProfile?.makeCircularImageView()
        
        fetchProfile()
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.delegate = self
        UserDefaults.standard.set(userId, forKey: PrefKey.profileId)
        pagingMenuController.setup(ProfilePagingMenuOptions1())
    }
    
    @IBAction func cancleTouched(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func followTouched(){
        self.follow()
    }
    
    @IBAction func purchaseListTouched(){
        performSegue(withIdentifier: SegueIdentity.profileToPurchaseList, sender: self)
    }
    
    @IBAction func settingTouched(){
        performSegue(withIdentifier: SegueIdentity.profileToSetting, sender: self)
        
    }
    
    func fetchProfile() {
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.users)/\(self.userId!)") { (response, statusCode, json) -> () in
            if statusCode == 200{
                
                let user = User(o: json["user"])
                
                self.imageProfile?.af_setImage(withURL: URL(string: user.profileThumbUrl)!)
                
                if self.me != nil {
                    if self.me!.id == user.id {
                        self.buttonFollow?.isHidden = true
                        self.buttonFollow?.isEnabled = false
                        self.buttonPurchaseList?.isHidden = false
                        self.buttonPurchaseList?.isEnabled = true
                        self.buttonSetting?.isHidden = false
                        self.buttonSetting?.isEnabled = true
                    } else {
                        self.buttonFollow?.isHidden = false
                        self.buttonFollow?.isEnabled = true
                        self.buttonPurchaseList?.isHidden = true
                        self.buttonPurchaseList?.isEnabled = false
                        self.buttonSetting?.isHidden = true
                        self.buttonSetting?.isEnabled = false
                        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.isFollowing)/\(self.userId!)") { (response, statusCode, json) -> () in
                            if statusCode == 200{
                                self.isFollowing = true
                                self.buttonFollow?.setTitle("Unfollow", for: .normal)
                            } else {
                                self.isFollowing = false
                                self.buttonFollow?.setTitle("Follow", for: .normal)
                            }
                        }
                    }
                }
                
                self.labelName?.text = user.username
                _ = BlossomRequest.request(method: .get, endPoint: "\(Api.follow)/\(self.userId!)") { (response, statusCode, json) -> () in
                    if statusCode == 200{
                        let followers = json["follow"]["followers"].arrayValue
                        let followings = json["follow"]["followings"].arrayValue
                        
                        if self.followers.isEmpty == false {
                            self.followers.removeAll(keepingCapacity: false)
                        }
                        
                        if self.followings.isEmpty == false {
                            self.followings.removeAll(keepingCapacity: false)
                        }
                        
                        for follower in followers {
                            self.followers.append(Follow(o: follower))
                        }
                        
                        for following in followings {
                            self.followings.append(Follow(o: following))
                        }
                        
                        self.labelFollower?.text = "follower:\(String(self.followers.count))"
                        self.labelFollowing?.text = "following:\(String(self.followings.count))"
                    }
                }
            }
        }
    }
    
    func follow(){
        if isFollowing {
            _ = BlossomRequest.request(method: .delete, endPoint: "\(Api.follow)/\(self.userId!)") { (response, statusCode, json) -> () in
                if statusCode == 200{
                    self.isFollowing = false
                    self.buttonFollow?.setTitle("Follow", for: .normal)
                    self.fetchProfile()
                } else {
                    print("status \(statusCode)")
                }
            }
        } else {
            _ = BlossomRequest.request(method: .post, endPoint: "\(Api.follow)/\(self.userId!)") { (response, statusCode, json) -> () in
                if statusCode == 200{
                    self.isFollowing = true
                    self.buttonFollow?.setTitle("Unfollow", for: .normal)
                    self.fetchProfile()
                } else {
                    print("status \(statusCode)")
                }
            }
        }
    }
}

extension ProfileViewController: PagingMenuControllerDelegate {
    // MARK: - PagingMenuControllerDelegate
    func willMove(toMenu menuController: UIViewController, fromMenu previousMenuController: UIViewController) {
        print(#function)
        print(previousMenuController)
        print(menuController)
    }
    
    func didMove(toMenu menuController: UIViewController, fromMenu previousMenuController: UIViewController) {
        print(#function)
        print(previousMenuController)
        print(menuController)
    }
    
    func willMove(toMenuItem menuItemView: MenuItemView, fromMenuItem previousMenuItemView: MenuItemView) {
        print(#function)
        print(previousMenuItemView)
        print(menuItemView)
    }
    
    func didMove(toMenuItem menuItemView: MenuItemView, fromMenuItem previousMenuItemView: MenuItemView) {
        print(#function)
        print(previousMenuItemView)
        print(menuItemView)
    }
}
