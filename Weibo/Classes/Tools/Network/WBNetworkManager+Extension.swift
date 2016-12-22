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
    
    //微博未读数量
    func unreadCount(completion: @escaping (_ count: Int)->()) {
        guard let uid = userAccount.uid else {
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

//获取用户信息
extension WBNetworkManager{
    func loadUserInfo(completion: @escaping (_ dict: [String: AnyObject])->()) {
        let urlStr = "https://api.weibo.com/2/users/show.json"
        
        guard let uid = userAccount.uid else {
            return
        }
        
        let params = ["uid": uid]
        
        tokenRequest(urlString: urlStr, parameters: params){(json, isSuccess) in
            completion(json as? [String: AnyObject] ?? [:])
        }
    }
}

//OAuth相关方法
extension WBNetworkManager{
    func loadAccessToken(code: String, completion: @escaping (_ isSuccess: Bool)->()) -> () {
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": WBRedirectURI];
        request(method: .POST, urlString: urlStr, parameters: params){
            (json,isSuccess) in
            print("accessToken获取：\(json)")
            
            self.userAccount.modelSet(with: (json as? [String: AnyObject]) ?? [:])
            
            
            //加载用户信息
            self.loadUserInfo(completion: { (dict) in
                self.userAccount.modelSet(with: dict)
                print(self.userAccount)
                
                self.userAccount.saveAccount()
                completion(isSuccess)
            })
        }
        
    }
}

//发布微博
extension WBNetworkManager{
    
    /// 发布微博
    ///
    /// - Parameters:
    ///   - status: 微博文本
    ///   - image: 微博配图(可以为nil,为纯文本微博)
    ///   - completion: 完成回调
    func poseStatus(status: String, image: UIImage?, completion: @escaping (_ json: [String: AnyObject]?, _ isSuccess: Bool)->()) {
        let urlString: String
        var name: String?
        var data: Data?
        
        if let image = image {
            urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
            name = "pic"
            data = UIImagePNGRepresentation(image)
        }
        else{
            urlString = "https://api.weibo.com/2/statuses/update.json"
        }
        
        let params = ["status": status]
        
        
        tokenRequest(method: .POST, urlString: urlString, parameters: params, name: name, data: data) { (json, success) in
            completion((json as? [String: AnyObject]), success)
        }

    }
}
