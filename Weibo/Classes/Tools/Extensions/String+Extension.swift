//
//  String+Extension.swift
//  Weibo
//
//  Created by 宋元明 on 16/12/8.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation

extension String{
    
    /// 从当前字符串中，提取链接和文本
    // Swift提供元组，同事返回多个值
    func ym_href() -> (link: String, text: String)? {
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []),
        let result = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.characters.count)) else{
            return nil
        }
        
        let link = (self as NSString).substring(with: result.rangeAt(1))
        let text = (self as NSString).substring(with: result.rangeAt(2))
        
        print("\(link)+++++\(text)")
        
        return (link, text)
    }
}
