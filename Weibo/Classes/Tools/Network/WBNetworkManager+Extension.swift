//
//  WBNetworkManager+Extension.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/21.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation

//封装微博网络请求方法
extension WBNetworkManager{
    
    /// 加载微博数据字典数组
    ///
    /// - Parameters:
    ///   - since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博）,默认为0
    ///   - max_id: 返回ID小于或等于max_id的微博，默认为0
    ///   - completion: 完成回调
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: Any]]?, _ isSuccess: Bool)->()) -> (){
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let params = ["since_id":since_id, "max_id":(max_id>0 ? max_id-1 : 0)]
        tokenRequest(method: .GET, urlString: urlString, parameters: params){
            (json: Any?,isSuccess: Bool) -> () in
            guard let json = json as? AnyObject,
                let result = json["statuses"] as? [[String: Any]] else{
                completion(nil, false)
                return
            }
            
            completion(result, true)
            
        }
    }
    
    
    func unreadCount(completion: @escaping (_ count: Int)->()) {
        guard let uid = uid else {
            return
        }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid": uid]
        
        tokenRequest(urlString: urlString, parameters: params){
            (json, isSuccess)  in
            
            let dict = json as? [String: AnyObject]
            let count = dict?["status"] as? Int
            
            completion(count ?? 0)
        }
    }
}
