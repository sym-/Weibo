//
//  WBStatus.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/22.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBStatus: NSObject {
    //Int 类型，在64位机器是64位，32位机器是32位，防止数据溢出
    var id: Int64 = 0
    var text: String?
    
    override var description: String{
        return modelDescription()
    }
}
