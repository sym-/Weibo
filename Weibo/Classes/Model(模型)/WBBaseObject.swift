//
//  WBBaseObject.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/25.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBBaseObject: NSObject,NSCoding {
    
    func encode(with aCoder: NSCoder) {
        var count: UInt32 = 0;
        
        let list = class_copyPropertyList(WBBaseObject.self, &count)
        for i in 0..<Int(count){
            guard let cName = property_getName(list?[i])
                     else {
                continue
            }
            
            let pName = String(cString: cName)
            let pValue = value(forKey: pName)
            if pValue != nil {
                aCoder.encode(pValue, forKey: pName)
            }
        }
        
        free(list)
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
        
        var count: UInt32 = 0;
        
        let list = class_copyPropertyList(WBBaseObject.self, &count)
        for i in 0..<Int(count){
            guard let cName = property_getName(list?[i])
                else {
                    continue
            }
            
            let pName = String(cString: cName)
            let pValue = aDecoder.decodeObject(forKey: pName)
            if pValue != nil {
                setValue(pValue, forKey: pName)
            }
        }
        
        free(list)
    }

}
