//
//  UIColor.swift
//  blossom
//
//  Created by Seong Phil on 2016. 10. 18..
//  Copyright © 2016년 treasureisle. All rights reserved.
//


import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int){
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(htmlColor:Int){
        self.init(red:(htmlColor >> 16) & 0xff, green:(htmlColor >> 8) & 0xff, blue:htmlColor & 0xff)
    }
    
    // uicolor html string 으로 가져오기
    // http://stackoverflow.com/a/31504040/500714
    convenience init(colorCode: String, alpha: Float = 1.0){
        let scanner = Scanner(string: colorCode)
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x0000FF
        let r = CGFloat(Float(Int(color >> 16) & mask) / 255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask) / 255.0)
        let b = CGFloat(Float(Int(color) & mask) / 255.0)
        
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}

