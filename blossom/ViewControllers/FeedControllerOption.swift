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
    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .three
    }
    
    struct MenuOptions: MenuViewCustomizable {
        //        var backgroundColor: UIColor {
        //            return UIColor.init(red: 220, green: 150, blue: 150)
        //        }
        //        var selectedBackgroundColor: UIColor {
        //            return UIColor.init(red: 220, green: 150, blue: 150)
        //        }
        var displayMode: MenuDisplayMode {
            //            return .standard(widthMode: .fixed(width: 80.0), centerItem: false, scrollingMode: .pagingEnabled)
            return .segmentedControl
        }
        var focusMode: MenuFocusMode {
            return .underline(height: 8, color: UIColor.init(red: 220, green: 150, blue: 150), horizontalPadding: 20, verticalPadding: 0)
        }
        var height: CGFloat {
            return 50
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
