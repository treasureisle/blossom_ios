//
//  UIImageView.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 19..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit

extension UIImageView {
    // 이미지뷰를 원형으로 만든다
    func makeCircularImageView(){
        let imageWidth = self.bounds.width
        self.layer.cornerRadius = imageWidth / 2
        self.layer.masksToBounds = true
    }
    
    
    // 이미지 뷰 360도 회전시킴
    func startRotate360(duration: CFTimeInterval, repeatCount: Float){
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = CGFloat(M_PI * 2.0)
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = repeatCount
        
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}

