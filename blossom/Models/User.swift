//
//  User.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 8..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON

class User{
    var id: Int
    var username: String
    var profileThumbUrl: String
    var introduce: String
    var isMe: Bool
    
    init(o:JSON){
        if let id = o["id"].int {
            self.id = id
        }else{
            fatalError("\(o["id"].error)")
        }
        
        if let username = o["username"].string {
            self.username = username
        }else{
            fatalError("\(o["username"].error)")
        }
        
        if let profileThumbUrl = o["profile_thumb_url"].string {
            self.profileThumbUrl = profileThumbUrl
        }else{
            fatalError("\(o["profile_thumb_url"].error)")
        }
        
        if let introduce = o["introduce"].string {
            self.introduce = introduce
        }else{
            self.introduce = ""
        }
        
        if let isMe = o["is_me"].bool {
            self.isMe = isMe
        }else{
            fatalError("\(o["is_me"].error)")
        }
    }
}
