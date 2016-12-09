//
//  UIViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 23..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import UIKit

var activityIndicatorView: UnsafePointer<UIActivityIndicatorView>? = nil

extension UIViewController {
    func removeBackButtonTitle(){
        guard let topItem = self.navigationController?.navigationBar.topItem else{
            return
        }
        
        topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func unregisterEventBus(){
        SwiftEventBus.unregister(self)
    }
    
    func showIndicator(){
        var indicator: UIActivityIndicatorView
        if let existingIndicatorView = objc_getAssociatedObject(self, &activityIndicatorView){
            indicator = existingIndicatorView as! UIActivityIndicatorView
        }else{
            indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            indicator.hidesWhenStopped = true
            
            objc_setAssociatedObject(self, &activityIndicatorView, indicator, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            
            self.view.addSubview(indicator)
            
            indicator.translatesAutoresizingMaskIntoConstraints = false
            let centerXCons = NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            let centerYCons = NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            self.view.addConstraints([centerXCons, centerYCons])
        }
        
        indicator.startAnimating()
    }
    
    func hideIndicator(){
        guard let indicator = objc_getAssociatedObject(self, &activityIndicatorView) else{
            return
        }
        
        (indicator as AnyObject).stopAnimating()
    }
    
    func changeNavigationBarColor(color: UIColor){
        guard let bar = self.navigationController?.navigationBar else{
            return
        }
        
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.barStyle = UIBarStyle.black
        bar.isTranslucent = false
        bar.barTintColor = color
        bar.shadowImage = UIImage()
    }
    
    func changeNavigationBarTextColor(color: UIColor){
        guard let bar = self.navigationController?.navigationBar else {
            return
        }
        
        bar.titleTextAttributes = [NSForegroundColorAttributeName:color]
    }
    
    // 네비게이션 백그라운드 색깔 지정할때 사용한다.
    // 네비게이션 자체 색상 변하기로 구현하면 뷰 간 이동시 애니메이션때 모양이 깨짐
    func addNavigationBackView(color: UIColor)->UIView?{
        guard let bar = self.navigationController?.navigationBar else{
            return nil
        }
        
        // 네비게이션 길이 만큼 빼줌
        let rect = bar.frame
        let y = rect.size.height + rect.origin.y
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: y))
        view.backgroundColor = color
        self.view.addSubview(view)
        
        return view
    }
}
