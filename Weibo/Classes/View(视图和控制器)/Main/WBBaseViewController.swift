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
    
    var tableView:UITableView?
    
    lazy var navItem = UINavigationItem()
    
    var refreshControl: UIRefreshControl?
    
    var isPullup = false
    
    var userLogon = false
    
    var visitorInfo: [String: String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }

    override var title: String?{
        didSet{
            navItem.title = title
        }
    }
    
    func loadData() {
        refreshControl?.endRefreshing()
    }
}

//访客视图监听方法
extension WBBaseViewController{
    @objc fileprivate func login(){
        
    }
    
    @objc fileprivate func register(){
        
    }
}

//设置界面
extension WBBaseViewController{
    fileprivate func setupUI(){
        view.backgroundColor = UIColor.white
        
        automaticallyAdjustsScrollViewInsets = false
        setupNavigationBar()
        
        userLogon ? setupTableView() : setupVisitorView()
        
    }
    
    func setupTableView(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height, 0, tabBarController?.tabBar.height ?? 49, 0)
        
        refreshControl = UIRefreshControl()
        tableView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    private func setupVisitorView(){
        let visitorView = WBVisitorView(frame: view.bounds)
        visitorView.visitorInfo = visitorInfo
        visitorView.logonButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        view.insertSubview(visitorView, belowSubview: navigationBar)
    
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }
    
    private func setupNavigationBar(){
        //添加导航条
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]
        navigationBar.barTintColor = UIColor(hexString: "0xf6f6f6")
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        navigationBar.tintColor = UIColor.orange
    }
}

extension WBBaseViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        
        //最后一行同时没有开始上拉刷新
        if row == count - 1 && !isPullup {
            isPullup = true
            
            loadData()
        }
    }
}
