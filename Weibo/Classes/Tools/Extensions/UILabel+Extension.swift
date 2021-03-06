//
//  UILabel+Extension.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/17.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation

extension UILabel{
    class func ym_label(withText: String, fontSize: CGFloat = 14, textColor: UIColor) -> UILabel{
        let label = UILabel()
        label.text = withText
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColor
        
        return label
    }
}
