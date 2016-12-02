//
//  WBStatusListViewModel.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/22.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation
import SDWebImage

/*如果类需要使用"kvc"或者一些框架，需要继承自NSObject
 如果类只是包装一些代码逻辑，可以不用任何父类
 */
class WBStatusListViewModel{
    //上啦刷新最大尝试次数
    private let maxPullupTryTimes = 3
    //上啦刷新错误次数
    private var pullupErrorTimes = 0
    
    lazy var statusList = [WBStatusViewModel]()
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - pullup: YES:上啦刷新
    ///   - completion: isSuccess:网络请求成功，shouldRefresh:能继续上啦
    func loadStatus(pullup:Bool, completion:@escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) -> () {
        
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true,false)
            
            return
        }
        
        let since_id = pullup ? 0 : (self.statusList.first?.status.id ?? 0)
        
        let max_id = !pullup ? 0 : (self.statusList.last?.status.id ?? 0)
        
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            if !isSuccess{
                completion(isSuccess, false)
                
                return
            }
            
            var array = [WBStatusViewModel]()
            
            for dict in list ?? []{
                guard let model = WBStatus.model(with: dict) else{
                    continue
                }
                array.append(WBStatusViewModel(model: model))
            }
            
//            guard let array = NSArray.modelArray(with: WBStatus.self, json: list ?? []) as? [WBStatus] else{
//                completion(isSuccess, false)
//                return
//            }
            
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
                self.cacheSingleImage(list: array,finished: completion)
            }
            
        }
    }
    
    /// 缓存本次下载微博数据数组中的单张图像
    ///
    /// - Parameter list: 本次下载的视图模型数组
    fileprivate func cacheSingleImage(list: [WBStatusViewModel], finished:@escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()){
        
        let group = DispatchGroup()
        
        /// 记录图片数据长度
        var length = 0
        
        for viewModel in list{
            if viewModel.picURLs?.count != 1{
                continue
            }
            
            guard let pic = viewModel.picURLs?[0].thumbnail_pic,
                let url = URL(string: pic) else{
                continue
            }
            
            group.enter()
            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                if let image = image,
                    let data = UIImagePNGRepresentation(image){
                    length += data.count
                    viewModel.updateSingleImageSize(image: image)
                }
                
                group.leave()
            })
            
        }
        
        group.notify(queue: DispatchQueue.main){
            print("图片缓存完成，image大小：\(length)")
            finished(true,true)
        }
    }
}
