//
//  Address.swift
//  blossom
//
//  Created by Seong Phil on 2017. 1. 20..
//  Copyright © 2017년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON

class Address {
    var roadAddr: String
    var roadAddrPart1: String
    var roadAddrPart2: String
    var jibunAddr: String
    var engAddr: String
    var zipNo: Int
    
    init(o:JSON){
        if let roadAddr = o["roadAddr"].string {
            self.roadAddr = roadAddr
        }else{
            fatalError("\(o["roadAddr"].error)")
        }
        
        if let roadAddrPart1 = o["roadAddrPart1"].string {
            self.roadAddrPart1 = roadAddrPart1
        }else{
            fatalError("\(o["roadAddrPart1"].error)")
        }
        
        if let roadAddrPart2 = o["roadAddrPart2"].string {
            self.roadAddrPart2 = roadAddrPart2
        }else{
            fatalError("\(o["roadAddrPart2"].error)")
        }
        
        if let jibunAddr = o["jibunAddr"].string {
            self.jibunAddr = jibunAddr
        }else{
            fatalError("\(o["jibunAddr"].error)")
        }
        
        if let engAddr = o["engAddr"].string {
            self.engAddr = engAddr
        }else{
            fatalError("\(o["engAddr"].error)")
        }
        
        if let zipNo = o["zipNo"].string {
            self.zipNo = Int(zipNo)!
        }else{
            self.zipNo = 0
        }
    }
}

