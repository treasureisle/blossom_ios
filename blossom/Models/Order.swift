//
//  Order.swift
//  blossom
//
//  Created by Seong Phil on 2017. 1. 11..
//  Copyright © 2017년 treasureisle. All rights reserved.
//

import Foundation

class Order {
    var post: Post
    var colorSize: ColorSize
    var amount: Int
    
    init(post: Post, colorSize: ColorSize, amount: Int){
        self.post = post
        self.colorSize = colorSize
        self.amount = amount
    }
}
