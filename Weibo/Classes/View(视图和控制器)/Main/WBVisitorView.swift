//
//  WBVisitorView.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/17.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBVisitorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconView = UIImageView(image: UIImage(named: ""))
    
    private lazy var houseView = UIImageView(image: UIImage(named: ""))
    
    private lazy var tipLabel = UILabel.ym_label(withText: "关注一些人，回这里看看有什么惊喜", textColor: UIColor.darkGray)
    
    private lazy var registerButton: UIButton = UIButton.ym_textBtn(title: "注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgoundImageName: "")
    
    private lazy var logonButton: UIButton = UIButton.ym_textBtn(title: "登录", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.black, backgoundImageName: "")
}

extension WBVisitorView{
    fileprivate func setupUI(){
        backgroundColor = UIColor.random()
    }
}
