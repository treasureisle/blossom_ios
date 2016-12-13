//
//  ErrorMsg.swift
//  blossom
//
//  Created by Seong Phil on 2016. 11. 17..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON

class ErrorMsg{
    var message: String
    
    init(o: JSON){
        if let message = o["message"].string {
            self.message = message
        }else{
            fatalError("\(o["message"].error)")
        }
    }
}

