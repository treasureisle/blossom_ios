//
//  Store.swift
//  blossom
//
//  Created by Seong Phil on 2017. 2. 27..
//  Copyright © 2017년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON

class Store{
    var id: Int
    var numEvents: Int
    var event1HashtagId: Int
    var event1ImgUrl: String
    var event2HashtagId: Int
    var event2ImgUrl: String
    var event3HashtagId: Int
    var event3ImgUrl: String
    var event4HashtagId: Int
    var event4ImgUrl: String
    var event5HashtagId: Int
    var event5ImgUrl: String
    var sellerId: Int
    var editorsPickHashtagId: Int
    var editorsPickTitle: String
    var todaySellerTitle: String
    
    init(o:JSON){
        if let id = o["id"].int {
            self.id = id
        }else{
            fatalError("\(o["id"].error)")
        }
        
        if let numEvents = o["num_events"].int {
            self.numEvents = numEvents
        }else{
            fatalError("\(o["num_events"].error)")
        }
        
        if let event1HashtagId = o["event1_hashtag_id"].int {
            self.event1HashtagId = event1HashtagId
        }else{
            fatalError("\(o["event1_hashtag_id"].error)")
        }
        
        if let event1ImgUrl = o["event1_img_url"].string {
            self.event1ImgUrl = event1ImgUrl
        }else{
            fatalError("\(o["event1_img_url"].error)")
        }
        
        if let event2HashtagId = o["event2_hashtag_id"].int {
            self.event2HashtagId = event2HashtagId
        }else{
            fatalError("\(o["event2_hashtag_id"].error)")
        }
        
        if let event2ImgUrl = o["event2_img_url"].string {
            self.event2ImgUrl = event2ImgUrl
        }else{
            fatalError("\(o["event2_img_url"].error)")
        }
        
        if let event3HashtagId = o["event3_hashtag_id"].int {
            self.event3HashtagId = event3HashtagId
        }else{
            fatalError("\(o["event3_hashtag_id"].error)")
        }
        
        if let event3ImgUrl = o["event3_img_url"].string {
            self.event3ImgUrl = event3ImgUrl
        }else{
            fatalError("\(o["event3_img_url"].error)")
        }
        
        if let event4HashtagId = o["event4_hashtag_id"].int {
            self.event4HashtagId = event4HashtagId
        }else{
            fatalError("\(o["event4_hashtag_id"].error)")
        }
        
        if let event4ImgUrl = o["event4_img_url"].string {
            self.event4ImgUrl = event4ImgUrl
        }else{
            fatalError("\(o["event4_img_url"].error)")
        }
        
        if let event5HashtagId = o["event5_hashtag_id"].int {
            self.event5HashtagId = event5HashtagId
        }else{
            fatalError("\(o["event5_hashtag_id"].error)")
        }
        
        if let event5ImgUrl = o["event5_img_url"].string {
            self.event5ImgUrl = event5ImgUrl
        }else{
            fatalError("\(o["event5_img_url"].error)")
        }
        
        if let sellerId = o["seller_id"].int {
            self.sellerId = sellerId
        }else{
            fatalError("\(o["seller_id"].error)")
        }
        
        if let todaySellerTitle = o["today_seller_title"].string {
            self.todaySellerTitle = todaySellerTitle
        }else{
            fatalError("\(o["today_seller_title"])")
        }
        
        if let editorsPickHashtagId = o["editors_pick_hashtag_id"].int {
            self.editorsPickHashtagId = editorsPickHashtagId
        }else{
            fatalError("\(o["editors_pick_hashtag_id"].error)")
        }
        
        if let editorsPickTitle = o["editors_pick_title"].string {
            self.editorsPickTitle = editorsPickTitle
        }else{
            fatalError("\(o["editors_pick_title"])")
        }
    }
}
