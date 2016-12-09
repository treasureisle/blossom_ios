//
//  Hashtag.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 8..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON

class Hashtag{
    var id: Int
    var name: String
    var number: Int
    
    init(o:JSON){
        if let id = o["id"].int {
            self.id = id
        }else{
            fatalError("\(o["id"].error)")
        }
        
        if let name = o["name"].string {
            self.name = name
        }else{
            fatalError("\(o["name"].error)")
        }
        
        if let number = o["number"].int {
            self.number = number
        }else{
            fatalError("\(o["number"].error)")
        }
    }
}
