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
    
    var userId: Int?
    var followings: [Follow] = []
    var followers: [Follow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageProfile?.makeCircularImageView()
        
        fetchProfile()
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.delegate = self
        UserDefaults.standard.set(userId, forKey: PrefKey.profileId)
        pagingMenuController.setup(ProfilePagingMenuOptions1())
    }
    
    func fetchProfile() {
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.users)/\(self.userId!)") { (response, statusCode, json) -> () in
            if statusCode == 200{
                
                let user = User(o: json["user"])
                
                self.imageProfile?.af_setImage(withURL: URL(string: user.profileThumbUrl)!)
                
                if let me = Session.load() {
                    if me.id == user.id {
                        self.buttonFollow?.isHidden = true
                        self.buttonFollow?.isEnabled = false
                        self.buttonPurchaseList?.isHidden = false
                        self.buttonPurchaseList?.isEnabled = true
                        self.buttonSetting?.isHidden = false
                        self.buttonSetting?.isEnabled = true
                    }
                }
                
                self.labelName?.text = user.username
                _ = BlossomRequest.request(method: .get, endPoint: "\(Api.follow)/\(self.userId)") { (response, statusCode, json) -> () in
                    if statusCode == 200{
                        let followers = json["follow"]["followers"].arrayValue
                        let followings = json["follow"]["followings"].arrayValue
                        
                        for follower in followers {
                            self.followers.append(Follow(o: follower))
                        }
                        
                        for following in followings {
                            self.followings.append(Follow(o: following))
                        }
                    }
                }
                
                self.labelFollower?.text = String(self.followers.count)
                self.labelFollowing?.text = String(self.followings.count)
                
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
