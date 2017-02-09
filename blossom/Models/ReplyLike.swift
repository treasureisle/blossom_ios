//
//  ReplyLike.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 21..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReplyLike{
    var id: Int
    var userId: Int
    var replyId: Int
    
    init(o:JSON){
        if let id = o["id"].int {
            self.id = id
        }else{
            fatalError("\(o["id"].error)")
        }
        
        if let userId = o["user_id"].int {
            self.userId = userId
        }else{
            fatalError("\(o["user_id"].error)")
        }
        
        if let replyId = o["reply_id"].int {
            self.replyId = replyId
        }else{
            fatalError("\(o["reply_id"].error)")
        }
    }
}
