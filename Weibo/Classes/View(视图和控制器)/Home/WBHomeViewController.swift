//
//  WBHomeViewController.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/10.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

private let CellId = "CellId"

class WBHomeViewController: WBBaseViewController {

    fileprivate lazy var listViewModel = WBStatusListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func showFriends(){
        print(#function)
        
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func loadData() {
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
            self.isPullup = false
            self.refreshControl?.endRefreshing()
            if shouldRefresh{
                self.tableView?.reloadData()
            }
        }
    }
}

//设置界面
extension WBHomeViewController{
    override func setupTableView()  {
        super.setupTableView()
        
        //导航
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", fontSize: 16, target: self, action: #selector(showFriends))
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: CellId)
    }
    
    
}

//表格数据源方法
extension WBHomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath)
        
        cell.textLabel?.text = listViewModel.statusList[indexPath.row].text
        
        return cell
    }
}
