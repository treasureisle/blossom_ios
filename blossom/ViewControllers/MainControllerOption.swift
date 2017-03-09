//
//  MainControllerOption.swift
//  blossom
//
//  Created by Seong Phil on 2016. 10. 28..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import PagingMenuController

private var pagingControllers: [UIViewController] {
    let sellViewController = SellViewController.instantiateFromStoryboard()
    let buyViewController = BuyViewController.instantiateFromStoryboard()
    let reviewViewController = ReviewViewController.instantiateFromStoryboard()
    let storeViewController = StoreViewController.instantiateFromStoryboard()
    return [sellViewController, buyViewController, reviewViewController, storeViewController]
}

struct MenuItemSell: MenuItemViewCustomizable {}
struct MenuItemBuy: MenuItemViewCustomizable {}
struct MenuItemReview: MenuItemViewCustomizable {}
struct MenuItemStore: MenuItemViewCustomizable {}

struct PagingMenuOptions1: PagingMenuControllerCustomizable {
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
            return [MenuItemSell(), MenuItemBuy(), MenuItemReview(), MenuItemStore()]
        }
    }
    
    struct MenuItemSell: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("SELL", comment: "SELL"))
            return .text(title: title)
        }
    }
    struct MenuItemBuy: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("BUY", comment: "BUY"))
            return .text(title: title)
        }
    }
    struct MenuItemReview: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("REVIEW", comment: "REVIEW"))
            return .text(title: title)
        }
    }
    struct MenuItemStore: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("STORE", comment: "STORE"))
            return .text(title: title)
        }
    }
}

