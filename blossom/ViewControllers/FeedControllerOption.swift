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
            return [MenuItemFeedSell(), MenuItemFeedCommon()]
        }
    }
    
    struct MenuItemFeedSell: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("SELL", comment: "SELL"), color: UIColor.init(red: 3, green: 0, blue: 0), selectedColor: UIColor.init(red: 197, green: 78, blue: 76), font: UIFont(name: Font.regular, size: 15)!, selectedFont: UIFont(name: Font.regular, size: 15)!)
            return .text(title: title)
            //            return .image(image: #imageLiteral(resourceName: "btn_sell_nor"), selectedImage: #imageLiteral(resourceName: "btn_sell_sel"))
        }
    }
    struct MenuItemFeedCommon: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("COMMON", comment: "COMMON"), color: UIColor.init(red: 3, green: 0, blue: 0), selectedColor: UIColor.init(red: 197, green: 78, blue: 76), font: UIFont(name: Font.regular, size: 15)!, selectedFont: UIFont(name: Font.regular, size: 15)!)
            return .text(title: title)
            //            return .image(image: #imageLiteral(resourceName: "btn_sell_nor"), selectedImage: #imageLiteral(resourceName: "btn_sell_sel"))
        }
    }
}
