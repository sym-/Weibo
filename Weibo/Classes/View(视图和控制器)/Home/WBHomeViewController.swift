//
//  WBHomeViewController.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/10.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBHomeViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func showFriends(){
        print(#function)
        
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WBHomeViewController{
    override func setupUI() {
        super.setupUI()
        
        //导航
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", fontSize: 16, target: self, action: #selector(showFriends))
    }
}
