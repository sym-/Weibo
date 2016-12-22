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
    
    /// 背景图片名称
    var bgImageName: String?
    
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
    
    var numberOfPages: Int{
        return (emoticons.count - 1) / 20 + 1
    }
    
    //从懒加载的表情包中，按照page截取最多20个表情模型数组
    //例如有26个表情
    //page = 0，返回0-20模型
    //page = 1，返回20-25模型
    func emoticon(page: Int) -> [YMEmoticon] {
        //每页数量
        let count = 20
        let location = page * count
        var length = count
        //数组越界判断
        if location + length > emoticons.count {
            length = emoticons.count - location
        }
        let range = NSRange(location: location, length: length)
        let subArray = (emoticons as NSArray).subarray(with: range) as! [YMEmoticon]
        
        return subArray
    }
    
    override var description: String{
        return modelDescription()
    }
}
