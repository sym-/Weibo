//
//  WBNavigationController.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/10.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isHidden = true
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        var isBackBtn = false
        if childViewControllers.count == 0 {
            viewController.hidesBottomBarWhenPushed = false
        }
        else{
            var title = "返回"
            isBackBtn = true
            if let vc = viewController as? WBBaseViewController{
                
                if childViewControllers.count == 1 {
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popToParent), isBackButton:isBackBtn)
            }
            
            viewController.hidesBottomBarWhenPushed = true
        }
        
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc fileprivate func popToParent(){
        popViewController(animated: true)
        
    }

}
