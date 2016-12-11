//
//  YMEmoticonManager.swift
//  表情包数据
//
//  Created by 宋元明 on 16/12/9.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation
import UIKit

class YMEmoticonManager{
    static let shared = YMEmoticonManager()
    
    /// 表情包懒加载数组
    lazy var packages = [YMEmoticonPackage]()
    
    /// 构造函数，如果添加private修饰符，就要求调用者必须通过shared访问对象
    private init(){
        loadPackages()
    }
}


//数据处理
fileprivate extension YMEmoticonManager{
    func loadPackages() {
        let bundlePath = Bundle.main.bundlePath
        let emoctionPath = bundlePath + "/Frameworks/HMEmoticon.framework/HMEmoticon.bundle"
        print("Emoticon路径是：\(emoctionPath)")
        guard let emoctionBundle = Bundle(path: emoctionPath),
            let plistPath = emoctionBundle.path(forResource: "emoticons.plist", ofType: nil),
            let array = NSArray(contentsOfFile: plistPath) as? [[String: String]],
            let models = NSArray.modelArray(with: YMEmoticonPackage.self, json: array) as? [YMEmoticonPackage] else{
            return
        }
        // 懒加载和+=不重新分配空间
        packages += models
        print(models)
    }
}

//表情符号处理
extension YMEmoticonManager{
    /// 将给定的字符串转换为属性文本
    ///
    /// - Parameter sting: 完整字符串
    /// - Returns: 属性文本
    func emoticonString(string: String, font: UIFont) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: string)
        
        let pattern = "\\[.*?\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else{
            return attrString
        }
        
        let matches = regex.matches(in: string, options: [], range: NSMakeRange(0, attrString.length))
        //WARNING:需要倒序替换，因为替换了前面的，后面的range会不准确
        for m in matches.reversed() {
            let r = m.rangeAt(0)
            let substring = (attrString.string as NSString).substring(with: r)
            if let em = YMEmoticonManager.shared.findEmoticon(string: substring) {
                print(em)
                
                attrString.replaceCharacters(in: r, with: em.imageText(font: font))
            }
            
        }
        
        attrString.addAttributes([NSFontAttributeName: font], range: NSMakeRange(0, attrString.length))
        
        return attrString
    }
    
    /// 根据 string 在所有的表情符号中查找对应的表情模型对象
    ///
    /// - Parameter string: 如果找到，返回表情模型
    /// - Returns: 返回nil
    func findEmoticon(string: String) -> YMEmoticon? {
        for p in packages {
            
//            let result = p.emoticons.filter({ (em) -> Bool in
//                return em.chs == string
//            })
            
            /*
             如果闭包中只有一句，并且是返回
             1> 闭包格式定义可以省略
             2> 参数使用$0,$1...依次替代
             3> return也可以省略
             */
            let result = p.emoticons.filter({
                $0.chs == string
            })
            
            if result.count == 1 {
                return result[0]
            }
        }
        
        return nil
    }
}
