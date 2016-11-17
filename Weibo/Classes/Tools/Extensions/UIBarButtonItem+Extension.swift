//
//  UIBarButtonItem+Extension.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/16.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation

extension UIBarButtonItem{
    convenience init(title: String, fontSize: CGFloat = 16, target: AnyObject? , action:Selector, isBackButton: Bool = false) {
        let btn = UIButton.ym_textBtn(title: title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        
        if isBackButton {
            btn.setImage(UIImage(named: "back"), for: .normal)
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        }
        btn.sizeToFit()

        btn.addTarget(target, action: action, for: .touchUpInside)

        self.init(customView: btn)
    }
}
