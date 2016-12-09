//
//  ColorSize.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 8..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON

class ColorSize{
    var id: Int
    var postId: Int
    var name: String
    var available: Int
    
    init(o:JSON){
        if let id = o["id"].int {
            self.id = id
        }else{
            fatalError("\(o["id"].error)")
        }
        
        if let postId = o["post_id"].int{
            self.postId = postId
        }else{
            fatalError("\(o["post_id"].error)")
        }
        
        if let name = o["name"].string {
            self.name = name
        }else{
            fatalError("\(o["name"].error)")
        }
        
        if let available = o["available"].int {
            self.available = available
        }else{
            fatalError("\(o["available"].error)")
        }
    }
}
