//
//  WBBaseViewController.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/10.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController {

    lazy var navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.ym_screenWidth(), height: 64))
    
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override var title: String?{
        didSet{
            navItem.title = title
        }
    }
}

extension WBBaseViewController{
    func setupUI(){
        view.backgroundColor = UIColor.random()
        
        //添加导航条
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]
        navigationBar.barTintColor = UIColor(hexString: "0xf6f6f6")
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
    }
}
