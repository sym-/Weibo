//
//  YMEmoticon.swift
//  表情包数据
//
//  Created by 宋元明 on 16/12/9.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class YMEmoticon: NSObject {
    
    //表情类型 false - 图片表情/ true - emoji
    var type = false
    
    /// 表情字符串
    var chs: String?
    
    /// 表情图片名称
    var png: String?
    
    /// emoji的十六进制编码
    var code: String?{
        didSet{
            guard let code = code else {
                return
            }
            
            let scanner = Scanner(string: code)
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
            if let unicodeScalar = UnicodeScalar(result){
                emoji = String(Character(unicodeScalar))
            }
        }
    }
    
    /// emoji字符串
    var emoji: String?
    
    /// 表情模型目录
    var directory: String?

    /// 图片表情对应的图像
    var image: UIImage?{
        if type {
            return nil
        }
        
        guard let directory = directory,
            let png = png,
            let bundle = Bundle(path: Bundle.main.bundlePath + "/Frameworks/HMEmoticon.framework/HMEmoticon.bundle")
            else {
                return nil
        }
        
        return UIImage(named: directory + "/" + png, in: bundle, compatibleWith: nil)
    }
    
    func imageText(font: UIFont) -> NSAttributedString {
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        let attachment = YMEmoticonAttachment()
        attachment.image = image
        attachment.chs = chs
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        let attrStrM = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        attrStrM.addAttributes([NSFontAttributeName: font], range: NSMakeRange(0, attrStrM.length))
        return attrStrM
    }
    
    override var description: String{
        return modelDescription()
    }
}
