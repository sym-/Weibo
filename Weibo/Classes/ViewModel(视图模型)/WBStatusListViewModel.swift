//
//  WBStatusListViewModel.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/22.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation

/*如果类需要使用"kvc"或者一些框架，需要继承自NSObject
 如果类只是包装一些代码逻辑，可以不用任何父类
 */
class WBStatusListViewModel{
    //上啦刷新最大尝试次数
    private let maxPullupTryTimes = 3
    //上啦刷新错误次数
    private var pullupErrorTimes = 0
    lazy var statusList = [WBStatus]()
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - pullup: YES:上啦刷新
    ///   - completion: isSuccess:网络请求成功，hasMorePullup:能继续上啦
    func loadStatus(pullup:Bool, completion:@escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) -> () {
        
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true,false)
            
            return
        }
        
        let since_id = pullup ? 0 : (self.statusList.first?.id ?? 0)
        
        let max_id = !pullup ? 0 : (self.statusList.last?.id ?? 0)
        
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            guard let array = NSArray.modelArray(with: WBStatus.self, json: list ?? []) as? [WBStatus] else{
                completion(isSuccess, false)
                return
            }
            if pullup{
                //上啦刷新，数组放在后边
                self.statusList = self.statusList + array
            }
            else{
                //下拉刷新，数组放在前边
                self.statusList = array + self.statusList
            }
            
            if pullup && array.count == 0{
                self.pullupErrorTimes += 1
                completion(isSuccess,false)
            }
            else{
                completion(isSuccess,true)
            }
            
        }
    }
}
