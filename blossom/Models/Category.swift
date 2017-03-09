//
//  Category.swift
//  blossom
//
//  Created by Seong Phil on 2017. 1. 20..
//  Copyright © 2017년 treasureisle. All rights reserved.
//

import Foundation
import SwiftyJSON
import Crashlytics

class Category {
    var id: Int
    var name: String
    var parentId: Int
    var depth: Int
    
    init(o:JSON){
        if let id = o["id"].int {
            self.id = id
        }else{
            fatalError("\(o["zipNo"].error)")
        }
        
        if let name = o["name"].string {
            self.name = name
        }else{
            fatalError("\(o["name"].error)")
        }
        
        if let parentId = o["parentId"].int {
            self.parentId = parentId
        }else{
            fatalError("\(o["parentId"].error)")
        }
        
        if let depth = o["depth"].int {
            self.depth = depth
        }else{
            fatalError("\(o["depth"].error)")
        }
    }
}

extension Category {
    func getCategories() -> [Category]{
        
        var categories = [Category]()
        _ = BlossomRequest.request(method: .get, endPoint: Api.category) { (response, statusCode, json) -> () in
            if statusCode == 200{
                let categories_json = json["categories"].arrayValue
                
                for category in categories_json {
                    categories.append(Category(o: category))
                }
            }
        }
        return categories
    }
    
    func save(categories: [Category]){
        let pref = UserDefaults.standard
        
        pref.setValue(categories, forKey: PrefKey.categories)
        pref.synchronize()
    }
    
    static func load() -> [Category]?{
        let pref = UserDefaults.standard
        guard let categories = pref.object(forKey: PrefKey.categories) as? [Category] else {
            return nil
        }
        
        return categories
    }
    
    static func remove(){
        let pref = UserDefaults.standard
        
        pref.removeObject(forKey: PrefKey.categories)
    }
    
    static func getMyCategory() -> Int{
        let pref = UserDefaults.standard
        
        let myCategoryId = pref.object(forKey: PrefKey.myCategoryId)
        if myCategoryId == nil {
            return 0
        }
        
        return myCategoryId as! Int
    }
    
    static func saveMyCategory(categoryId: Int) {
        let pref = UserDefaults.standard
        
        pref.set(categoryId, forKey: PrefKey.myCategoryId)
        pref.synchronize()
    }
}
