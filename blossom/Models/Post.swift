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
    var imgUrl2: String
    var imgUrl3: String
    var imgUrl4: String
    var imgUrl5: String
    var title: String
    var brand: String
    var productName: String
    var originPrice: Int
    var purchasePrice: Int
    var fee: Int
    var region: String
    var hashtag: String
    var text: String
    var replys: Int
    var likes: Int
    var isLiked: Bool
    
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
        
        if let imgUrl2 = o["img_url2"].string {
            self.imgUrl2 = imgUrl2
        } else {
            self.imgUrl2 = ""
        }
        
        if let imgUrl3 = o["img_url3"].string {
            self.imgUrl3 = imgUrl3
        } else {
            self.imgUrl3 = ""
        }
        
        if let imgUrl4 = o["img_url4"].string {
            self.imgUrl4 = imgUrl4
        } else {
            self.imgUrl4 = ""
        }
        
        if let imgUrl5 = o["img_url5"].string {
            self.imgUrl5 = imgUrl5
        } else {
            self.imgUrl5 = ""
        }
        
        self.title = o["title"].string!
        
        self.brand = o["brand"].string!
        
        self.productName = o["product_name"].string!
        
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
        
        if let region = o["region"].string {
            self.region = region
        }else{
            fatalError("\(o["region"].error)")
        }
        
        self.hashtag = o["hashtag"].string!
        
        self.text = o["text"].string!
        
        if let replys = o["replys"].int {
            self.replys = replys
        }else{
            fatalError("\(o["replys"].error)")
        }
        
        if let likes = o["likes"].int {
            self.likes = likes
        }else{
            fatalError("\(o["likes"].error)")
        }
        
        if let isLiked = o["is_liked"].bool {
            self.isLiked = isLiked
        }else{
            fatalError("\(o["is_liked"].error)")
        }
    }
}
