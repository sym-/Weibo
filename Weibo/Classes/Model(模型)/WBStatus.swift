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
    
    /// 正文
    var text: String?
    
    var user: WBUser?
    
    /// 微博配图数组
    var pic_urls: [WBStatusPicture]?
    
    /// 转发数
    var reposts_count: Int = 0
    
    /// 评论数
    var comments_count: Int = 0
    
    /// 表态数
    var attitudes_count: Int = 0
    
    /// 来源
    var source: String?
    
    /// 微博创建时间
    var created_at: String?
    
    override var description: String{
        return modelDescription()
    }
    
    class func modelContainerPropertyGenericClass() -> [String: AnyClass]{
        return ["pic_urls": WBStatusPicture.self]
    }
}
