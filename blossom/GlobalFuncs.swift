//
//  GlobalFuncs.swift
//  blossom
//
//  Created by Seong Phil on 2016. 10. 14..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import Crashlytics

var timestamp: String {
    return "\(Date().timeIntervalSince1970)"
}

// debug 모드일때만 프린트되도록함
func print(_ items: Any..., separator: String = " ", terminator: String = "\n"){
    #if DEBUG
        Swift.print(items[0], separator: separator, terminator: terminator)
    #endif
}

func crashLog(_ format: String="", _ args:[CVarArg] = [], file: String = #file, function: String = #function, line: Int = #line){
    let filename = URL(string: file)?.lastPathComponent.components(separatedBy: ".").first
    
    #if DEBUG
        CLSNSLogv("\(filename).\(function) line \(line) $ \(format)", getVaList(args))
    #else
        CLSLogv("\(filename).\(function) line \(line) $ \(format)", getVaList(args))
    #endif
}

func getFilesOrderbyDateDesc(_ filePath: String) -> [String]?{
    let properties = [URLResourceKey.localizedNameKey, URLResourceKey.creationDateKey, URLResourceKey.contentModificationDateKey, URLResourceKey.localizedTypeDescriptionKey]
    
    if let urlArray = try? FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: filePath), includingPropertiesForKeys: properties, options: .skipsHiddenFiles){
        return urlArray.map{ (url) -> (String, TimeInterval) in
            var lastModified: AnyObject?
            _ = try? (url as NSURL).getResourceValue(&lastModified, forKey: URLResourceKey.contentModificationDateKey)
            return (url.lastPathComponent, lastModified?.timeIntervalSinceReferenceDate ?? 0)
            }
            .sorted(by: {$0.1 > $1.1}) // sort descending modification dates
            .map{ $0.0 } // extract file names
    }else{
        return nil
    }
}

func backgroundThread(_ delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    DispatchQueue.global().async {
        if(background != nil){ background!(); }
        
        let popTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            if(completion != nil){ completion!(); }
        }
    }
}
