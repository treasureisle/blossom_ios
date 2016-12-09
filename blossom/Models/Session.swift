//
//  Session.swift
//  blossom
//
//  Created by Seong Phil on 2016. 10. 18..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON
import Crashlytics

class SessionType {
    var type: String?
    
    init(type: String){
        self.type = type
    }
    
    init(o: JSON){
        if let type = o["type"].string {
            self.type = type
        }
    }
}

class Session {
    var id: Int
    var accessToken: String
    var username: String?
    var types = [SessionType]()
    
    init(id:Int, accessToken:String, username:String?, types:[SessionType]){
        self.id = id
        self.accessToken = accessToken
        self.username = username
        self.types = types
    }
    
    init(o:JSON){
        if let id = o["id"].int {
            self.id = id
        }else{
            fatalError("\(o["id"].error)")
        }
        
        if let accessToken = o["access_token"].string {
            self.accessToken = accessToken
        }else{
            fatalError("\(o["access_token"].error)")
        }
        
        if let username = o["username"].string {
            self.username = username
        }
        
        if let types = o["types"].array {
            for type in types {
                self.types.append(SessionType(o: type))
            }
        }
    }
}

extension Session{
    func save(){
        let pref = UserDefaults.standard
        
        pref.setValue(self.id, forKey: PrefKey.id)
        pref.setValue(self.accessToken, forKey: PrefKey.accessToken)
        pref.setValue(self.username, forKey: PrefKey.username)
        
        var typesString = [String]()
        
        for type in types {
            typesString.append(type.type!)
        }
        
        pref.set(typesString, forKey: PrefKey.sessionTypes)
        pref.synchronize()
        
        Crashlytics.sharedInstance().setUserIdentifier("\(self.id)")
        if let username = self.username {
            Crashlytics.sharedInstance().setUserName(username)
        }
    }
    
    static func load() -> Session?{
        let pref = UserDefaults.standard
        guard let id = pref.object(forKey: PrefKey.id) as? Int, let token = pref.object(forKey: PrefKey.accessToken) as? String else {
            return nil
        }
        
        Crashlytics.sharedInstance().setUserIdentifier("\(id)")
        var types = [SessionType]()
        
        var username: String?
        
        if let prefUsername = pref.object(forKey: PrefKey.username) as? String {
            username = prefUsername
            Crashlytics.sharedInstance().setUserName(prefUsername)
        }
        
        if let typesString = pref.array(forKey: PrefKey.sessionTypes){
            for type in typesString {
                types.append(SessionType(type: type as! String))
            }
        }
        
        return Session(id: id, accessToken: token, username: username, types: types)
    }
    
    static func remove(){
        let pref = UserDefaults.standard
        
        pref.removeObject(forKey: PrefKey.id)
        pref.removeObject(forKey: PrefKey.accessToken)
        pref.removeObject(forKey: PrefKey.username)
        pref.removeObject(forKey: PrefKey.sessionTypes)
    }
}

