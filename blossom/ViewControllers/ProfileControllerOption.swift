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
    var userId: Int?
    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .three
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .standard(widthMode: .flexible, centerItem: false, scrollingMode: .pagingEnabled)
        }
        var focusMode: MenuFocusMode {
            return .underline(height: 3, color: UIColor.blue, horizontalPadding: 10, verticalPadding: 0)
        }
        var height: CGFloat {
            return 30
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItemProfileLike(), MenuItemProfileList(), MenuItemProfileStore()]
        }
    }
    
    struct MenuItemProfileLike: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("LIKE", comment: "LIKE"))
            return .text(title: title)
        }
    }
    struct MenuItemProfileList: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("LIST", comment: "LIST"))
            return .text(title: title)
        }
    }
    struct MenuItemProfileStore: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("STORE", comment: "STORE"))
            return .text(title: title)
        }
    }
}
