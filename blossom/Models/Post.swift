//
//  Post.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 8..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON

class Post{
    var id: Int
    var postType: Int
    var user: User
    var imgUrl1: String
    var title: String
    var originPrice: Int
    var purchasePrice: Int
    var fee: Int
    
    init(o:JSON){
        if let id = o["id"].int {
            self.id = id
        }else{
            fatalError("\(o["id"].error)")
        }
        
        if let postType = o["post_type"].int {
            self.postType = postType
        }else{
            fatalError("\(o["post_type"].error)")
        }
        
        self.user = User(o: o["user"])
        
        self.imgUrl1 = o["img_url1"].string!
        self.title = o["title"].string!
        
        if let originPrice = o["origin_price"].int {
            self.originPrice = originPrice
        }else{
            fatalError("\(o["origin_price"].error)")
        }
        
        if let purchasePrice = o["purchase_price"].int {
            self.purchasePrice = purchasePrice
        }else{
            fatalError("\(o["purchase_price"].error)")
        }
        
        if let fee = o["fee"].int {
            self.fee = fee
        }else{
            fatalError("\(o["fee"].error)")
        }
    }
}
