//
//  WBOAuthViewController.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/24.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBOAuthViewController: UIViewController {
    
    fileprivate lazy var webView: UIWebView = UIWebView()

    override func loadView() {
        view = webView
        
        view.backgroundColor = UIColor.white
        
        title = "登录新浪微博"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回",  target: self, action: #selector(close), isBackButton: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func close(){
        dismiss(animated: true, completion: nil)
    }

}
