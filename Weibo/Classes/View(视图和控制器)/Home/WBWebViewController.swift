//
//  WBWebViewController.swift
//  Weibo
//
//  Created by 宋元明 on 16/12/12.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBWebViewController: WBBaseViewController {

    fileprivate lazy var webview = UIWebView(frame: UIScreen.main.bounds)
    
    var urlString: String?{
        didSet{
            guard let urlString = urlString,
                let url = URL(string: urlString) else {
                return
            }
            
            webview.loadRequest(URLRequest(url: url))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WBWebViewController{
    override func setupTableView() {
        //设置webview
        
        view.insertSubview(webview, belowSubview: navigationBar)
        
        webview.backgroundColor = UIColor.white
        
        webview.scrollView.contentInset.top = navigationBar.height
    }
}
