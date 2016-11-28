//
//  WBUserAccount.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/25.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

fileprivate let accountFileName: NSString = "useraccount.json"


class WBUserAccount: NSObject {
    //访问令牌
    var access_token: String?
    //用户代号
    var uid: String?
    //过期日期
    //基本类型需要初始值
    var expires_in: TimeInterval = 0{
        didSet{
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    var expiresDate: Date?
    
    //用户昵称
    var screen_name: String?
    
    //用户头像
    var avatar_large: String?
    
    override var description: String{
        return modelDescription()
    }
    
    override init() {
        super.init()
        
        //取出文件
        let filePath = accountFileName.appendDocumentDir()
        print("account路径：\(filePath)")
        guard let data = NSData(contentsOfFile: filePath),
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject] else{
            return
        }
        
        modelSet(with: dict ?? [:])
        
        //token过期处理
        if expiresDate?.compare(Date()) != .orderedDescending{
            //过期
            print("账号过期")
            
            access_token = nil
            uid = nil
            
            //删除账户json
            do{
                try FileManager.default.removeItem(atPath: filePath)
            }
            catch{
                print("文件删除有问题")
            }
        }
        
        print("账号正常")
    }
    
    //按照json文件保存
    func saveAccount() -> () {
        var dict = self.modelToJSONObject() as? [String: AnyObject] ?? [:]
         _ = dict.removeValue(forKey: "expires_in")
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            return
        }
        
        let filePath = accountFileName.appendDocumentDir()
        
        print(filePath)
        (data as NSData).write(toFile: filePath, atomically: true)
    }
    
}

