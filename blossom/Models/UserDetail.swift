//
//  UserDetail.swift
//  blossom
//
//  Created by Seong Phil on 2017. 2. 23..
//  Copyright © 2017년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserDetail{
    var id: Int
    var username: String
    var email: String
    var name: String
    var zipcode: Int
    var address1: String
    var address2: String
    var recent_name: String
    var recent_zipcode: Int
    var recent_add1: String
    var recent_add2: String
    var phone: String
    var level: Int
    var point: Int
    var region: String
    var seller_level: Int
    var bank_account: String
    var biz_num: String
    var recommender_id: Int
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
        
        if let email = o["email"].string {
            self.email = email
        }else{
            fatalError("\(o["email"].error)")
        }
        
        if let name = o["name"].string {
            self.name = name
        }else{
            self.name = ""
        }
        
        if let zipcode = o["zipcode"].int {
            self.zipcode = zipcode
        }else{
            self.zipcode = 0
        }
        
        if let address1 = o["address1"].string {
            self.address1 = address1
        }else{
            self.address1 = ""
        }
        
        if let address2 = o["address2"].string {
            self.address2 = address2
        }else{
            self.address2 = ""
        }
        
        if let recent_name = o["recent_name"].string {
            self.recent_name = recent_name
        }else{
            self.recent_name = ""
        }
        
        if let recent_zipcode = o["recent_zipcode"].int {
            self.recent_zipcode = recent_zipcode
        }else{
            self.recent_zipcode = 0
        }
        
        if let recent_add1 = o["recent_add1"].string {
            self.recent_add1 = recent_add1
        }else{
            self.recent_add1 = ""
        }
        
        if let recent_add2 = o["recent_add2"].string {
            self.recent_add2 = recent_add2
        }else{
            self.recent_add2 = ""
        }
        
        if let phone = o["phone"].string {
            self.phone = phone
        }else{
            self.phone = ""
        }
        
        if let level = o["level"].int {
            self.level = level
        }else{
            fatalError("\(o["level"].error)")
        }
        
        if let point = o["point"].int {
            self.point = point
        }else{
            fatalError("\(o["point"].error)")
        }
        
        if let seller_level = o["seller_level"].int {
            self.seller_level = seller_level
        }else{
            fatalError("\(o["seller_level"].error)")
        }
        
        if let bank_account = o["bank_account"].string {
            self.bank_account = bank_account
        }else{
            self.bank_account = ""
        }
        
        if let region = o["region"].string {
            self.region = region
        }else{
            self.region = ""
        }
        
        if let biz_num = o["biz_num"].string {
            self.biz_num = biz_num
        }else{
            self.biz_num = ""
        }
        
        if let recommender_id = o["recommender_id"].int {
            self.recommender_id = recommender_id
        }else{
            self.recommender_id = 0
        }
        
    }
}

