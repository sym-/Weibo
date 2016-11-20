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
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
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
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        var data = NSData(contentsOfFile: jsonPath)
        if data == nil {
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        guard let array = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as? [[String: Any]]
            else{
                return
        }
        /*json书写
        let json = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
        let fileUrl = NSURL.fileURL(withPath: "/Users/songyuanming/Desktop/weibo.json")
        (json as NSData).write(toFile: "/Users/songyuanming/Desktop/weibo.json", atomically: true)
         */
        
        
        var arrayM = [UIViewController]()
        for dict in array! {
            arrayM.append(controller(dict: dict))
        }
        
        viewControllers = arrayM
    }
    
    
    /// 使用字典创建自控制器
    ///
    /// - Parameter dict: 信息字典[clsName,title,imageName,visitorInfo]
    /// - Returns: 子控制器
    fileprivate func controller(dict: [String : Any]) -> UIViewController{
        guard let clsName = dict["clsName"] as? String,
                let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let visitorInfo: [String: String] = dict["visitorInfo"] as? [String : String],
            let cls =  NSClassFromString(Bundle.main.namespace + "." + clsName) as? WBBaseViewController.Type else{
                return UIViewController()
        }
        
        let vc = cls.init();
        vc.title = title
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_"+imageName+"_selected")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .highlighted)
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12)], for: .normal)
        vc.visitorInfo = visitorInfo
        
        let nav = WBNavigationController(rootViewController: vc)
        
        return nav
    }
}
