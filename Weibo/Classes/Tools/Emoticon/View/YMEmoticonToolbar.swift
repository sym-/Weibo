//
//  YMEmoticonToolbar.swift
//  表情键盘
//
//  Created by 宋元明 on 2016/12/19.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class YMEmoticonToolbar: UIView {

    override func awakeFromNib() {
        setupUI()
    }
    
    override func layoutSubviews() {
        let count = subviews.count
        let w = bounds.width / CGFloat(count)
        let rect = CGRect(x: 0, y: 0, width: w, height: bounds.height)
        for (i,btn) in subviews.enumerated() {
            btn.frame = rect.offsetBy(dx: w*CGFloat(i), dy: 0)
        }
    }

}

fileprivate extension YMEmoticonToolbar{
    func setupUI() {
        let manager = YMEmoticonManager.shared
        
        for p in manager.packages {
            let button = UIButton(type: .custom)
            
            button.setTitle(p.groupName, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitleColor(UIColor.darkGray, for: .highlighted)
            button.setTitleColor(UIColor.darkGray, for: .selected)
            button.sizeToFit()
            
            let imageName = "compose_emotion_table_\(p.bgImageName ?? "")_normal"
            let imageNameHL = "compose_emotion_table_\(p.bgImageName ?? "")_selected"
            let image = UIImage(named: imageName, in: manager.bundle, compatibleWith: nil)
            let imageHL = UIImage(named: imageNameHL, in: manager.bundle, compatibleWith: nil)
            let size = image?.size ?? CGSize.zero
            let edge = UIEdgeInsetsMake(size.height * 0.5,
                                        size.width * 0.5,
                                        size.height * 0.5,
                                        size.width * 0.5)
            
            button.setBackgroundImage(image?.resizableImage(withCapInsets: edge), for: .normal)
            button.setBackgroundImage(imageHL?.resizableImage(withCapInsets: edge), for: .highlighted)
            
            button.setBackgroundImage(imageHL?.resizableImage(withCapInsets: edge), for: .selected)
            
            addSubview(button)
        }
    }
}
