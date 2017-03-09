//
//  Reply.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 21..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON


class Reply{
    var id: Int
    var user: User
    var post: Post
    var parentId: Int
    var depth: Int
    var text: String
    var likes: Int
    var replies: Int
    var createdAt: String
    var isLiked: Bool
    
    init(o:JSON){
        if let id = o["id"].int {
            self.id = id
        }else{
            fatalError("\(o["id"].error)")
        }
        
        self.user = User(o: o["user"])
        
        self.post = Post(o: o["post"])
        
        if let parentId = o["parent_id"].int {
            self.parentId = parentId
        }else{
            fatalError("\(o["parent_id"].error)")
        }
        
        if let depth = o["depth"].int {
            self.depth = depth
        }else{
            fatalError("\(o["depth"].error)")
        }
        
        if let text = o["text"].string {
            self.text = text
        }else{
            fatalError("\(o["text"].error)")
        }
        
        if let likes = o["likes"].int {
            self.likes = likes
        }else{
            fatalError("\(o["likes"].error)")
        }
        
        if let replies = o["replies"].int {
            self.replies = replies
        }else{
            fatalError("\(o["replies"].error)")
        }
        
        if let createdAt = o["created_at"].string {
            self.createdAt = createdAt
        }else{
            fatalError("\(o["created_at"].error)")
        }
        
        if let isLiked = o["is_liked"].bool {
            self.isLiked = isLiked
        }else{
            fatalError("\(o["is_liked"].error)")
        }
    }
}
