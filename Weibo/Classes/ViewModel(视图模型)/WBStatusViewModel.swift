//
//  WBStatusViewModel.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/29.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation
import UIKit

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
    
    /// 微博正文属性文本
    var statusAttrText: NSAttributedString?
    
    /// 被转发微博文字
    var retweedtedAttrText: NSAttributedString?
    
    /// 行高
    var rowHeight: CGFloat = 0
    
    /// 来源
    var sourceStr: String?
    
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

        let originFont: UIFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont: UIFont = UIFont.systemFont(ofSize: 14)
        
        //微博文本属性文本
        statusAttrText = YMEmoticonManager.shared.emoticonString(string: model.text ?? "", font: originFont)
        //被转发文本属性文本
        var rText: String = "@"
        rText.append(status.retweeted_status?.user?.screen_name ?? "")
        rText.append(":")
        rText.append(status.retweeted_status?.text ?? "")
        
//        let rText: String = "@" + "\(status.retweeted_status?.user?.screen_name ?? "")"
//            + ":"
//            + "\(status.retweeted_status?.text ?? "")"
        
        retweedtedAttrText = YMEmoticonManager.shared.emoticonString(string: rText, font: retweetedFont)

        //计算行高
        updateRowHeight()

        sourceStr = "来自：" + (model.source?.ym_href()?.text ?? "")
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
    
    
    /// 根据当前视图模型内容计算行高
    func updateRowHeight(){
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        
        var height: CGFloat = 0
        
        let viewSize: CGSize = CGSize(width: UIScreen.ym_screenWidth() - 2*margin, height: CGFloat(MAXFLOAT))
        
        //顶部位置
        height = 2 * margin + iconHeight + margin
        
        //正文高度
        if let text = statusAttrText {
            height += text.boundingRect(with: viewSize,
                                        options: [.usesLineFragmentOrigin],
                                        context: nil).height
        }
        
        //是否转发微博
        if status.retweeted_status != nil{
            height += 2*margin
            //转发文本高度
            if let text = retweedtedAttrText {
                height += text.boundingRect(with: viewSize,
                                            options: [.usesLineFragmentOrigin],
                                            context: nil).height
            }
        }
        
        //配图视图
        height += pictureViewSize.height
        height += margin
        height += toolbarHeight
        
        rowHeight = height
    }
    
    func updateSingleImageSize(image: UIImage) {
        var size = image.size
        
        let maxWidth: CGFloat = 300
        let minWidth: CGFloat = 40
        //图像过宽
        if size.width > maxWidth {
            size.width = maxWidth
            size.height = size.width * image.size.height / image.size.width
        }
        
        //图像过窄
        if size.width < minWidth {
            size.width = minWidth
            size.height = size.width * image.size.height / image.size.width / 4
        }
        size.height += WBStatusPictureViewOutterMargin
        
        
        
        pictureViewSize = size
        
        //更新行高
        updateRowHeight()
    }
}
