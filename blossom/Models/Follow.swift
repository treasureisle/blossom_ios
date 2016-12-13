//
//  Follow.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 12..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON

class Follow{
    var id: Int
    var followerId: Int
    var followingId: Int
    
    init(o:JSON){
        if let id = o["id"].int {
            self.id = id
        }else{
            fatalError("\(o["id"].error)")
        }
        
        if let followerId = o["follower_id"].int {
            self.followerId = followerId
        }else{
            fatalError("\(o["follower_id"].error)")
        }
        
        if let followingId = o["following_id"].int {
            self.followingId = followingId
        }else{
            fatalError("\(o["following_id"].error)")
        }
    }
}

