//
//  WBHomeViewController.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/10.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

///原创微博重用ID
private let OriginalCellId = "OriginalCellId"

///被转发微博重用ID
private let RetweetedCellId = "RetweetedCellId"

class WBHomeViewController: WBBaseViewController {

    fileprivate lazy var listViewModel = WBStatusListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavTitle()
    }
    
    @objc fileprivate func showFriends(){
        print(#function)
        
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func loadData() {
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
//            if self.isPullup == false{
//                self.tabBarItem.badgeValue = nil
//            }
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
        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier:OriginalCellId)
        tableView?.register(UINib(nibName: "WBStatusRetweetedCell", bundle: nil), forCellReuseIdentifier:RetweetedCellId)
        
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.separatorStyle = .none
    }
    
    func setupNavTitle() {
        let btn = UIButton.ym_textBtn(title: "sym1992", fontSize: 17, normalColor: UIColor.darkGray, highlightedColor: UIColor.black)
        btn.setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        btn.setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
        btn.layoutButton(with: .right, imageTitleSpace: 5)
        btn.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
        navItem.titleView = btn
    }
    
    @objc func clickTitleButton(btn: UIButton){
        btn.isSelected = !btn.isSelected
    }
}

//表格数据源方法
extension WBHomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = listViewModel.statusList[indexPath.row]
        let cellId = (viewModel.status.retweeted_status != nil) ? RetweetedCellId : OriginalCellId
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell
        cell.viewModel = viewModel
        
        return cell
    }
}
