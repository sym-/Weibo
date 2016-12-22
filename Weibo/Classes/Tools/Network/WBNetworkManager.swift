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
    static let shared: WBNetworkManager = {
        let instance = WBNetworkManager()
        //初始化
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
    }()
    
//    var accessToken: String? //= "2.00RLN_RERRDPhD0aefb2d334zgibDE"
//    var uid: String?
    lazy var userAccount = WBUserAccount()
    
    var userLogon:Bool{
        return userAccount.access_token != nil
    }
    
    /// 专门负责拼接token的网络请求方法
    ///
    /// - Parameters:
    ///   - method: GET/Post
    ///   - urlString: url
    ///   - parameters: 参数字典
    ///   - name: 上传文件使用的字段名，默认为nil，不上传文件
    ///   - data: 上传文件的二进制数据，默认为nil，不上传文件
    ///   - completion: 完成回调
    func tokenRequest(method: WBHTTPMethod = .GET,urlString: String, parameters:[String: Any]?,name: String? = nil,data: Data? = nil ,completion:@escaping (_ json:Any?,_ isSuccess: Bool)->()){
        
        guard let token = userAccount.access_token else {
            print("没有token，需要登录")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
            
            completion(nil,false)
            return
        }
        var parameters = parameters
        if parameters == nil {
             parameters = [String: AnyObject]()
        }
        
        parameters!["access_token"] = token
        
        if let name = name,
            let data = data {
            upload(urlString: urlString, parameters: parameters, name: name, data: data, completion: completion)
        }
        else{
            
            request(method:method ,urlString: urlString, parameters: parameters, completion: completion)
        }
        
    }
    
    //封装AFN的上传文件请求
    //上传文件必须是POST方法，GET只能获取数据
    ///
    /// - Parameters:
    ///   - urlString: 路径
    ///   - parameters: 参数
    ///   - name: 接受上传数据的服务器字段-'pic'
    ///   - data: 要上传二进制数据
    ///   - completion: 完成回调
    func upload(urlString: String, parameters:[String: Any]?, name: String, data: Data, completion:@escaping (_ json:Any?,_ isSuccess: Bool)->()) {
        post(urlString, parameters: parameters, constructingBodyWith: { (formData: AFMultipartFormData) in
            //FIXME:创建formData
            /*
             1.data:要上传的二进制数据
             2.name:服务器接受字段名
             3.fileName:保存在服务器的文件名
             4.mineType:上传文件的类型，如果不想指定，可以使用application/octer-stream
            */
            formData.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "application/octer-stream")
        }, progress: nil, success: { (_, json) in
            completion(json, true)
        }) { (task: URLSessionDataTask?, error) in
            print("error:\(error)")
            if (task?.response as? HTTPURLResponse)?.statusCode == 403{
                print("Token过期，需要重新登录")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: "bad token")
            }
            else{
                
            }
            
            completion(nil,false)
        }
    }
    
    func request(method: WBHTTPMethod = .GET,urlString: String, parameters:[String: Any]?,completion:@escaping (_ json:Any?,_ isSuccess: Bool)->()){
        let success = {(task: URLSessionDataTask, json: Any?) -> () in
            completion(json,true)
        }
        
        let failure = {(task: URLSessionDataTask?, error:Error) -> () in
            print("error:\(error)")
            if (task?.response as? HTTPURLResponse)?.statusCode == 403{
                print("Token过期，需要重新登录")
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: "bad token")
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
