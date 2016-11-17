//
//  UIButton+Convenience.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/15.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation

extension UIButton{
    class func ym_imageBtn(imageName:String,backgroungImageName:String) -> UIButton {
        let btn: UIButton = UIButton(type: .custom)
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setBackgroundImage(UIImage(named: backgroungImageName), for: .normal)
        
        return btn
    }
    
    class func ym_textBtn(title: String, fontSize: CGFloat, normalColor: UIColor, highlightedColor: UIColor) -> UIButton{
        let btn = UIButton(type: .custom)
        
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(normalColor, for: .normal)
        btn.setTitleColor(highlightedColor, for: .highlighted)
        btn.sizeToFit()
        
        return btn
    }
}
