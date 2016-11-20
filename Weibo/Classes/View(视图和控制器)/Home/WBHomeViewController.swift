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

    fileprivate lazy var statusList = [String]()
    
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
        if statusList.count != 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                if self.isPullup{
                    for i in 0..<20{
                        self.statusList.append(i.description)
                    }
                }
                else{
                    for i in 0..<20{
                        self.statusList.insert(i.description, at: 0)
                    }
                }
                
                self.isPullup = false
                self.refreshControl?.endRefreshing()
                self.tableView?.reloadData()
            }
        }
        else{
            for i in 0..<20{
                self.statusList.insert(i.description, at: 0)
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
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath)
        
        cell.textLabel?.text = statusList[indexPath.row]
        
        return cell
    }
}
