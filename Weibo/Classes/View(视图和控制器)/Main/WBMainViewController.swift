//
//  WBMainViewController.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/10.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildControllers()
        setupComposeBtn()
    }
    
    @objc fileprivate func composeStatus() {
        //撰写微博
        
    }

    fileprivate lazy var composeBtn: UIButton = UIButton.ym_imageBtn(imageName: "tabbar_compose_icon_add", backgroungImageName: "tabbar_compose_button")
}

extension WBMainViewController{
    
    fileprivate func setupComposeBtn(){
        tabBar.addSubview(composeBtn)
        let count: CGFloat = CGFloat(childViewControllers.count)
        let width  = tabBar.bounds.size.width/count - 1
        composeBtn.frame = tabBar.bounds.insetBy(dx: 2 * width, dy: 0)
        composeBtn.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    
     fileprivate func setupChildControllers(){
        let array = [
                        ["clsName":"WBHomeViewController","title":"首页","imageName":"home"],
                        ["clsName":"WBMessageViewController","title":"消息","imageName":"message_center"],
                        ["clsName":""],
                        ["clsName":"WBDiscoverViewController","title":"发现","imageName":"discover"],
                        ["clsName":"WBProfileViewController","title":"我","imageName":"profile"]
                     ]
        var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(controller(dict: dict))
        }
        
        viewControllers = arrayM
    }
    
    
    /// 使用字典创建自控制器
    ///
    /// - Parameter dict: 信息字典[clsName,title,imageName]
    /// - Returns: 子控制器
    fileprivate func controller(dict: [String : String]) -> UIViewController{
        guard let clsName = dict["clsName"],
                let title = dict["title"],
            let imageName = dict["imageName"],
            let cls =  NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type else{
                return UIViewController()
        }
        
        let vc = cls.init();
        vc.title = title
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_"+imageName+"_selected")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .highlighted)
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12)], for: .normal)
        
        let nav = WBNavigationController(rootViewController: vc)
        
        return nav
    }
}
