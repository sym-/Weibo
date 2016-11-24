//
//  WBNetworkManager.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/20.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit
//导入文件夹的名称
import AFNetworking

enum WBHTTPMethod {
    case GET
    case POST
}

class WBNetworkManager: AFHTTPSessionManager {
    //单例:静态，常量
    static let shared = WBNetworkManager()
    
    var accessToken: String? //= "2.00RLN_RERRDPhD0aefb2d334zgibDE"
    
    var userLogon:Bool{
        return accessToken != nil
    }
    
    var uid: String? 
    
    func tokenRequest(method: WBHTTPMethod = .GET,urlString: String, parameters:[String: Any]?,completion:@escaping (_ json:Any?,_ isSuccess: Bool)->()){
        
        guard let token = accessToken else {
            print("没有token，需要登录")
            
            completion(nil,false)
            return
        }
        var parameters = parameters
        if parameters == nil {
             parameters = [String: AnyObject]()
        }
        
        parameters!["access_token"] = token
        
        request(method:method ,urlString: urlString, parameters: parameters, completion: completion)
    }
    
    func request(method: WBHTTPMethod = .GET,urlString: String, parameters:[String: Any]?,completion:@escaping (_ json:Any?,_ isSuccess: Bool)->()){
        let success = {(task: URLSessionDataTask, json: Any?) -> () in
            completion(json,true)
        }
        
        let failure = {(task: URLSessionDataTask?, error:Error) -> () in
            if (task?.response as? HTTPURLResponse)?.statusCode == 403{
                print("Token过期，需要重新登录")
                //FIXME:发送通知
                 
            }
            else{
                
            }
            
            completion(nil,false)
        }
        
        if method == .GET {
            get(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        else{
            post(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        
    }
}
