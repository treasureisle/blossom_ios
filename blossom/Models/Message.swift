//
//  Post.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 8..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON

class Message{
    var id: Int
    var sender: User
    var reciever: User
    var text: String
    var createdAt: String
    
    init(o:JSON){
        if let id = o["id"].int {
            self.id = id
        }else{
            fatalError("\(o["id"].error)")
        }
        
        self.sender = User(o: o["user"])
        
        self.reciever = User(o: o["user"])
        
        self.text = o["text"].string!
        self.createdAt = o["created_at"].string!
    }
}
