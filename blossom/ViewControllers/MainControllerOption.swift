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
            return .standard(widthMode: .flexible, centerItem: false, scrollingMode: .pagingEnabled)
        }
        var focusMode: MenuFocusMode {
            return .underline(height: 3, color: UIColor.blue, horizontalPadding: 10, verticalPadding: 0)
        }
        var height: CGFloat {
            return 30
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

struct PagingMenuOptions2: PagingMenuControllerCustomizable {
    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    var menuControllerSet: MenuControllerSet {
        return .single
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItemSell(), MenuItemBuy(), MenuItemReview(), MenuItemStore()]
        }
    }
}

struct PagingMenuOptions3: PagingMenuControllerCustomizable {
    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .three
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .infinite(widthMode: .fixed(width: 80), scrollingMode: .scrollEnabled)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItemSell(), MenuItemBuy(), MenuItemReview(), MenuItemStore()]
        }
    }

}

struct PagingMenuOptions4: PagingMenuControllerCustomizable {
    var componentType: ComponentType {
        return .menuView(menuOptions: MenuOptions())
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var focusMode: MenuFocusMode {
            return .underline(height: 3, color: UIColor.blue, horizontalPadding: 10, verticalPadding: 0)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItemSell(), MenuItemBuy(), MenuItemReview(), MenuItemStore()]
        }
    }
}

struct PagingMenuOptions5: PagingMenuControllerCustomizable {
    var componentType: ComponentType {
        return .menuView(menuOptions: MenuOptions())
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .infinite(widthMode: .flexible, scrollingMode: .pagingEnabled)
        }
        var focusMode: MenuFocusMode {
            return .roundRect(radius: 12, horizontalPadding: 8, verticalPadding: 8, selectedColor: UIColor.lightGray)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItemSell(), MenuItemBuy(), MenuItemReview(), MenuItemStore()]
        }
    }
}

struct PagingMenuOptions6: PagingMenuControllerCustomizable {
    var componentType: ComponentType {
        return .pagingController(pagingControllers: pagingControllers)
    }
    var defaultPage: Int {
        return 1
    }
}

