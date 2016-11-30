//
//  WeiBoCommon.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/24.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation

//MARK:全局通知定义
let WBAppKey = "3387368467"

let WBAppSecret = "1f1ee6937144ef6d2bb9c22780349c21"

let WBRedirectURI = "http://www.baidu.com"

//用户需要登录通知
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"

let WBUserLoginSuccessNotification = "WBUserLoginSuccessNotification"

//UserDefault里面的保存的旧版本号
let WBOldVersionKey = "WBOldVersionKey"

// 微博配图视图常量
//配图视图外侧间距
let WBStatusPictureViewOutterMargin: CGFloat = 12
//配图视图内部图像视图间距
let WBStatusPictureViewInnerMargin: CGFloat = 3
//配图视图高度
let WBStatusPictureViewWidth = UIScreen.ym_screenWidth() - 2*WBStatusPictureViewOutterMargin
//每个item默认的宽度
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth - 2*WBStatusPictureViewInnerMargin) / 3
