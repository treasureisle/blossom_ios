//
//  Post.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 8..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON

class Purchase{
    var id: Int
    var post: Post
    var seller: User
    var buyer: User
    var colorSize: ColorSize
    var amount: Int
    var price: Int
    var payment: Int
    var zipcode: Int
    var address1: String
    var address2: String
    var phone: String
    var comment: String
    var deliveryCode: Int
    var deliveryNumber: String
    var createdAt: String
    
    init(o:JSON){
        if let id = o["id"].int {
            self.id = id
        }else{
            fatalError("\(o["id"].error)")
        }
        
        self.post = Post(o: o["post"])
        
        self.seller = User(o: o["seller"])
        
        self.buyer = User(o: o["buyer"])
        
        self.colorSize = ColorSize(o: o["color_size"])
        
        if let amount = o["amount"].int {
            self.amount = amount
        }else{
            fatalError("\(o["amount"].error)")
        }
        
        if let price = o["price"].int {
            self.price = price
        }else{
            fatalError("\(o["price"].error)")
        }
        
        if let payment = o["payment"].int {
            self.payment = payment
        }else{
            fatalError("\(o["payment"].error)")
        }
        
        if let zipcode = o["zipcode"].int {
            self.zipcode = zipcode
        }else{
            fatalError("\(o["zipcode"].error)")
        }
        
        self.address1 = o["address1"].string!
        
        self.address2 = o["address2"].string!
        
        self.phone = o["phone"].string!
        
        self.comment = o["comment"].string!
        
        if let deliveryCode = o["delivery_code"].int {
            self.deliveryCode = deliveryCode
        }else{
            self.deliveryCode = 0
        }
        
        if let deliveryNumber = o["delivery_number"].string {
            self.deliveryNumber = deliveryNumber
        }else{
            self.deliveryNumber = ""
        }
        
        if let createdAt = o["created_at"].string {
            self.createdAt = createdAt
        }else{
            fatalError("\(o["created_at"].error)")
        }
    }
}
