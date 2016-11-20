//
//  WBDemoViewController.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/15.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @objc fileprivate func showNext(){
        let vc = WBDemoViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WBDemoViewController{
    
    override func setupTableView() {
        super.setupTableView()
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", fontSize: 16, target: self, action: #selector(showNext))
    }
}
