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
            return [MenuItemSell(), MenuItemBuy(), MenuItemReview(), MenuItemStore()]
        }
    }
    
    struct MenuItemSell: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("SELL", comment: "SELL"), color: UIColor.init(red: 3, green: 0, blue: 0), selectedColor: UIColor.init(red: 197, green: 78, blue: 76), font: UIFont(name: Font.regular, size: 15)!, selectedFont: UIFont(name: Font.regular, size: 15)!)
            return .text(title: title)
//            return .image(image: #imageLiteral(resourceName: "btn_sell_nor"), selectedImage: #imageLiteral(resourceName: "btn_sell_sel"))
        }
    }
    struct MenuItemBuy: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("BUY", comment: "BUY"), color: UIColor.init(red: 3, green: 0, blue: 0), selectedColor: UIColor.init(red: 197, green: 78, blue: 76), font: UIFont(name: Font.regular, size: 15)!, selectedFont: UIFont(name: Font.regular, size: 15)!)
            return .text(title: title)
//            return .image(image: #imageLiteral(resourceName: "btn_getit_nor"), selectedImage: #imageLiteral(resourceName: "btn_getit_sel"))
        }
    }
    struct MenuItemReview: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("REVIEW", comment: "REVIEW"), color: UIColor.init(red: 3, green: 0, blue: 0), selectedColor: UIColor.init(red: 197, green: 78, blue: 76), font: UIFont(name: Font.regular, size: 15)!, selectedFont: UIFont(name: Font.regular, size: 15)!)
            return .text(title: title)
//            return .image(image: #imageLiteral(resourceName: "btn_review_nor"), selectedImage: #imageLiteral(resourceName: "btn_review_sel"))
        }
    }
    struct MenuItemStore: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: NSLocalizedString("STORE", comment: "STORE"), color: UIColor.init(red: 3, green: 0, blue: 0), selectedColor: UIColor.init(red: 197, green: 78, blue: 76), font: UIFont(name: Font.regular, size: 15)!, selectedFont: UIFont(name: Font.regular, size: 15)!)
            return .text(title: title)
//            return .image(image: #imageLiteral(resourceName: "btn_store_nor"), selectedImage: #imageLiteral(resourceName: "btn_store_sel"))
        }
    }
}

