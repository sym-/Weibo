//
//  YMSQLiteManager.swift
//  数据库
//
//  Created by 宋元明 on 2016/12/27.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation
import FMDB

//数据库管理器
class YMSQLiteManager {
    //单例，全局数据库工具访问点
    static let shared = YMSQLiteManager()
    //数据库队列
    let queue: FMDatabaseQueue
    
    private init(){
        let dbName = "status.db"
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        
        print("数据库路径" + path)
        
        //创建数据库队列，同时创建或打开“数据库”
        queue = FMDatabaseQueue(path: path)
        
        creatTable()
    }
}

extension YMSQLiteManager{
    func updateStatus(userId: String, array: [[String: Any]]) {
        /*准备sql
         statuId:微博id
         userId:用户id
         status:完整微博json
         */
        let sql = "INSERT OR REPLACE INTO T_Status (statusId, userId, status) VALUES (?, ?, ?);"
        queue.inTransaction { (db, rollback) in
            for dic in array{
                guard let statusId = dic["idstr"] as? String,
                    let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: []) else{
                        continue
                }
                //执行sql
                if db?.executeUpdate(sql, withArgumentsIn: [statusId, userId, jsonData]) == false {
                    //FIXME:回滚
                    rollback?.pointee = true
                    break
                }
            }
        }
    }
    
    func execRecordSet(sql: String) -> [[String: Any]] {
        //结果数组
        var result = [[String: Any]]()
        
        //查询不需要修改数据，不用开启事务
        //事务的目的，是为了保证数据的一致性，一旦失败方便回滚
        queue.inDatabase { (db) in
            guard let rs = db?.executeQuery(sql, withArgumentsIn: []) else{
                return
            }
            
            while rs.next() {
                //列数
                let colCount = rs.columnCount()
                for col in 0..<colCount{
                    guard let name = rs.columnName(for: col),
                        let value = rs.object(forColumnIndex: col) else{
                            continue
                    }
                    
                    result.append([name: value])
                }
            }
        }
        
        return result
    }
    
    /// 从数据库加载微博数组
    ///
    /// - Parameters:
    ///   - userId: 当前登录账号
    ///   - since_id: 返回的微博ID比since_id大
    ///   - max_id: 返回的微博ID比max_id小
    /// - Returns: 微博的字典数组，将数据库中status字段对应的二进制数据反序列化返回
    func loadStatus(userId: String, since_id: Int64 = 0, max_id: Int64 = 0) -> [[String: Any]] {
        //拼接sql
        var sql = "SELECT statusId, userId, status FROM T_Status "
        sql += "WHERE userId = \(userId) "
        if since_id > 0 {
            sql += "AND statusId > \(since_id) "
        }
        else if max_id > 0{
            sql += "AND statusId < \(max_id) "
        }
        sql += "ORDER BY statusId DESC LIMIT 20;"
        let array = execRecordSet(sql: sql)
        var result = [[String: Any]]()
        for dict in array {
            guard let jsonData = dict["status"] as? Data,
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else{
                continue
            }
            
            result.append(json ?? [:])
        }
        
        return result
    }
}

fileprivate extension YMSQLiteManager{
    
    
    func creatTable(){
        guard let path = Bundle.main.path(forResource: "status.sql", ofType: nil),
            let sql = try? String(contentsOfFile: path) else{
            return
        }
        
        queue.inDatabase { (db) in
            if db?.executeStatements(sql) == true {
                print("创表成功")
            }
            else
            {
                print("创表失败")
            }
        }
        
        print("over")
    }
}
