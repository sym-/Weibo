//
//  WBStatusViewModel.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/29.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation

/// 单条微博视图模型 
//FIXME:了解CustomStringConvertible
class WBStatusViewModel:CustomStringConvertible {
    
    /// 微博模型
    var status: WBStatus
    
    /// 会员图标
    var memberIcon: UIImage?
    
    /// 认证图标
    var vipIcon: UIImage?
    
    /// 转发文字
    var retweetedStr: String?
    
    /// 评论文字
    var commentStr: String?
    
    /// 点赞文字
    var likeStr: String?
    
    /// 配图视图大小
    var pictureViewSize = CGSize.zero
    
    /// 如果是被转发微博，原创微博一定没有图
    var picURLs: [WBStatusPicture]?{
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    /// 被转发微博文字
    var retweedtedText: String?
    init(model: WBStatus) {
        self.status = model
        //common_icon_membership_level1
        //会员 0-6
        let mbrank = model.user?.mbrank ?? 0
        if mbrank > 0 && mbrank < 7 {
            let imageName = "common_icon_membership_level\(mbrank)"
            
            memberIcon = UIImage(named: imageName)
        }
        
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2,3,4:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
            
        }
        
        retweetedStr = countString(count: model.reposts_count, defaultString: "转发")
        commentStr = countString(count: model.comments_count, defaultString: "转发")
        likeStr = countString(count: model.attitudes_count, defaultString: "转发")
        
        pictureViewSize = calcPictureViewSize(count: picURLs?.count)
        
        retweedtedText = "@" + "\(status.retweeted_status?.user?.screen_name ?? "")"
            + ":"
            + "\(status.retweeted_status?.text ?? "")"
    }
    
    fileprivate func calcPictureViewSize(count: Int?) -> CGSize{
        guard let count = count else {
            return CGSize.zero
        }
        
        if count == 0 {
            return CGSize.zero
        }
        
        //2.计算高度
        let row = (count - 2)/3 + 1
        let height = WBStatusPictureViewOutterMargin
            + CGFloat(row) * WBStatusPictureItemWidth
            + CGFloat(row-1) * WBStatusPictureViewInnerMargin
        
        
        return CGSize(width: WBStatusPictureViewWidth, height: height)
    }
    
    fileprivate func countString(count: Int, defaultString: String) -> String{
        if count == 0 {
            return defaultString
        }
        else if count < 10000{
            return String(count)
        }
        
        return String(format: "%.02f 万", Double(count)/10000)
    }
    
    var description: String{
        return status.description
    }
    
    func updateSingleImageSize(image: UIImage) {
        var size = image.size
        size.height += WBStatusPictureViewOutterMargin
        size.width < WBStatusPictureItemWidth ? size.width = WBStatusPictureItemWidth : ()
        
        //FIXME:此处size有问题
        pictureViewSize = size
    }
}
