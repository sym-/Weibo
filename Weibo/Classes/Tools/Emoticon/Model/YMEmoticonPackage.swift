//
//  YMEmoticonPackage.swift
//  表情包数据
//
//  Created by 宋元明 on 16/12/9.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class YMEmoticonPackage: NSObject {
    
    /// 表情包的分组名
    var groupName: String?
    
    /// 表情包目录,从目录下加载info.plist可以创建表情模型数组
    var directory: String?{
        didSet{
            let bundlePath = Bundle.main.bundlePath
            let emoctionPath = bundlePath + "/Frameworks/HMEmoticon.framework/HMEmoticon.bundle"
            // 设置目录时，从目录下加载表情plist
            guard let directory = directory,
                let emoctionBundle = Bundle(path: emoctionPath),
                let infopath = emoctionBundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let array = NSArray(contentsOfFile: infopath) as? [[String: String]],
                let models = NSArray.modelArray(with: YMEmoticon.self, json: array) as? [YMEmoticon] else {
                return
            }
            
            for m in models {
                m.directory = directory
            }
            emoticons += models
        }
    }
    
    /// 表情模型数组
    lazy var emoticons = [YMEmoticon]()
    
    override var description: String{
        return modelDescription()
    }
}
