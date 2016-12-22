//
//  WBOAuthViewController.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/24.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBOAuthViewController: UIViewController {
    
    fileprivate lazy var webView: UIWebView = UIWebView()

    override func loadView() {
        view = webView
        
        view.backgroundColor = UIColor.white
        
        webView.delegate = self
        webView.scrollView.isScrollEnabled = false
        
        title = "登录新浪微博"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回",  target: self, action: #selector(close), isBackButton: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill), isBackButton: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        guard let url = URL(string: urlStr) else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    @objc fileprivate func close(){
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func autoFill(){
        let js = "document.getElementById('userId').value = '18902117726';"+"document.getElementById('passwd').value = 'sym8825501.0';"
        
        webView.stringByEvaluatingJavaScript(from: js)
    }

}

extension WBOAuthViewController: UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.url else {
            return false
        }
        print("预加载URL：\(url)")
        let prefix = WBRedirectURI + "/?code="
        if url.absoluteString.hasPrefix(prefix) == false {
            return true
        }
        
        if url.query?.hasPrefix("code=") == false {
            print("取消授权")
            close()
            return false
        }
        
        let code = url.query?.substring(from: "code=".endIndex) ?? ""
        print(code)
        WBNetworkManager.shared.loadAccessToken(code: code){ isSuccess in
            if isSuccess{
                SVProgressHUD.showSuccess(withStatus: "登录成功")
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:WBUserLoginSuccessNotification), object: nil)
                
                self.close()
            }
            else{
                SVProgressHUD.showError(withStatus: "登录失败")
            }
        }
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
}
