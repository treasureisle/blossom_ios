//
//  FeedControllerOption.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 15..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import PagingMenuController

private var pagingControllers: [UIViewController] {
    let feedSellViewController = FeedSellViewController.instantiateFromStoryboard()
    let feedCommonViewController = FeedCommonViewController.instantiateFromStoryboard()
    return [feedSellViewController, feedCommonViewController]
}

struct MenuItemFeedSell: MenuItemViewCustomizable {}
struct MenuItemFeedCommon: MenuItemViewCustomizable {}

struct FeedPagingMenuOptions1: PagingMenuControllerCustomizable {
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
            return [MenuItemFeedSell(), MenuItemFeedCommon()]
        }
    }
    
    struct MenuItemFeedSell: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("SELL", comment: "SELL"))
            return .text(title: title)
        }
    }
    struct MenuItemFeedCommon: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("COMMON", comment: "COMMON"))
            return .text(title: title)
        }
    }
}

