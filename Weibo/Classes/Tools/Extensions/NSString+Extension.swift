//
//  NSString+Extension.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/25.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation

extension NSString{
    func appendDocumentDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = path.appendingPathComponent(self as String)
        
        
        return filePath
    }
}
