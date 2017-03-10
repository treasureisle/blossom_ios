//
//  ProfileControllerOption.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 12..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import PagingMenuController

private var pagingControllers: [UIViewController] {
    let profileLikeViewController = ProfileLikeViewController.instantiateFromStoryboard()
    profileLikeViewController.userId = UserDefaults.standard.integer(forKey: PrefKey.profileId)
    let profileListViewController = ProfileListViewController.instantiateFromStoryboard()
    profileListViewController.userId = UserDefaults.standard.integer(forKey: PrefKey.profileId)
    let profileStoreViewController = ProfileStroeViewController.instantiateFromStoryboard()
    profileStoreViewController.userId = UserDefaults.standard.integer(forKey: PrefKey.profileId)
    return [profileLikeViewController, profileListViewController, profileStoreViewController]
}

struct MenuItemProfileLike: MenuItemViewCustomizable {}
struct MenuItemProfileList: MenuItemViewCustomizable {}
struct MenuItemProfileStore: MenuItemViewCustomizable {}

struct ProfilePagingMenuOptions1: PagingMenuControllerCustomizable {
    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .three
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var focusMode: MenuFocusMode {
            return .underline(height: 4, color: UIColor.init(red: 197, green: 78, blue: 76), horizontalPadding: 20, verticalPadding: 0)
        }
        var height: CGFloat {
            return 40
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItemProfileLike(), MenuItemProfileList(), MenuItemProfileStore()]
        }
    }
    
    struct MenuItemProfileLike: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("LIKE", comment: "LIKE"), color: UIColor.init(red: 3, green: 0, blue: 0), selectedColor: UIColor.init(red: 197, green: 78, blue: 76), font: UIFont(name: Font.regular, size: 15)!, selectedFont: UIFont(name: Font.regular, size: 15)!)
            return .text(title: title)
            //            return .image(image: #imageLiteral(resourceName: "btn_sell_nor"), selectedImage: #imageLiteral(resourceName: "btn_sell_sel"))
        }
    }
    struct MenuItemProfileList: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("LIST", comment: "LIST"), color: UIColor.init(red: 3, green: 0, blue: 0), selectedColor: UIColor.init(red: 197, green: 78, blue: 76), font: UIFont(name: Font.regular, size: 15)!, selectedFont: UIFont(name: Font.regular, size: 15)!)
            return .text(title: title)
            //            return .image(image: #imageLiteral(resourceName: "btn_sell_nor"), selectedImage: #imageLiteral(resourceName: "btn_sell_sel"))
        }
    }
    struct MenuItemProfileStore: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("STORE", comment: "STORE"), color: UIColor.init(red: 3, green: 0, blue: 0), selectedColor: UIColor.init(red: 197, green: 78, blue: 76), font: UIFont(name: Font.regular, size: 15)!, selectedFont: UIFont(name: Font.regular, size: 15)!)
            return .text(title: title)
            //            return .image(image: #imageLiteral(resourceName: "btn_sell_nor"), selectedImage: #imageLiteral(resourceName: "btn_sell_sel"))
        }
    }
}

