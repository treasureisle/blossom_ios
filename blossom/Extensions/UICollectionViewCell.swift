//
//  UICollectionViewCell.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 10..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    func roundingUIView( aView: UIView!, cornerRadiusParam: CGFloat!) {
        aView.clipsToBounds = true
        aView.layer.cornerRadius = cornerRadiusParam
    }
}
