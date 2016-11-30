//
//  WBUser.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/29.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBUser: NSObject {
    //基本数据类型不设置初始值 & private 不能使用kvc
    var id: Int64 = 0
    
    /// 昵称
    var screen_name: String?
    
    /// 头像
    var profile_image_url: String?
    
    /// 认证类型，1-：没有认证，0：认证用户，2，3，5企业，220：达人
    var verified_type: Int = 0
    
    /// 会员等级 0-6
    var mbrank: Int = 0
    
    override var description: String{
        return modelDescription()
    }
}
