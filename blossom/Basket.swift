//
//  Post.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 8..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON

class Basket{
    var id: Int
    var post: Post
    var user: User
    var colorSize: ColorSize
    var amount: Int
    
    init(o:JSON){
        if let id = o["id"].int {
            self.id = id
        }else{
            fatalError("\(o["id"].error)")
        }
        
        self.user = User(o: o["user"])
        
        self.post = Post(o: o["post"])
        
        self.colorSize = ColorSize(o: o["color_size"])
        
        if let amount = o["amount"].int {
            self.amount = amount
        }else{
            fatalError("\(o["amount"].error)")
        }
    }
}
