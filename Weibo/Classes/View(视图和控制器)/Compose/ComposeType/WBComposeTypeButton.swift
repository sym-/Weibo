//
//  WBComposeTypeButton.swift
//  Weibo
//
//  Created by 宋元明 on 16/12/6.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBComposeTypeButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    
    //绑定控制器类名   
    var clsName: String?
    
    class func composeTypeButton(imageName: String, title: String) -> WBComposeTypeButton {
        let nib = UINib(nibName: "WBComposeTypeButton", bundle: nil)
        
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeButton
        
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLabel.text = title
        
        return btn
    }
}
