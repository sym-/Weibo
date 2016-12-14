//
//  WBStatusCell.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/29.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

//微博cell的协议
@objc protocol WBStatusCellDelegate: NSObjectProtocol {
    @objc optional func statusCellDidSelectedUrlString(cell: WBStatusCell, urlString: String) ;
}

class WBStatusCell: UITableViewCell {
    
    /// 代理属性
    weak var delegate: WBStatusCellDelegate?
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    /// 认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    
    @IBOutlet weak var statusLabel: FFLabel!
    
    
    /// 底部工具栏
    @IBOutlet weak var toolBar: WBStatusToolBar!

    
    /// 配图视图
    @IBOutlet weak var pictureView: WBStatusPictureView!
    
    
    /// 被转发微博label
    @IBOutlet weak var retweetedLabel: FFLabel?
    
    var viewModel: WBStatusViewModel?{
        didSet{
            statusLabel.attributedText = viewModel?.statusAttrText
            retweetedLabel?.attributedText = viewModel?.retweedtedAttrText
            nameLabel.text = viewModel?.status.user?.screen_name
            memberIconView.image = viewModel?.memberIcon
            vipIconView.image = viewModel?.vipIcon
            iconView.ym_setImage(urlStr: viewModel?.status.user?.profile_image_url, placeHolderImage: UIImage(named: "avatar_default"), isAvatar: true)
            toolBar.viewModel = viewModel
            
            timeLabel.text = viewModel?.status.created_at
            sourceLabel.text = viewModel?.sourceStr
//            if viewModel?.status.pic_urls?.count ?? 0 > 4 {
//                var picUrls = viewModel?.status.pic_urls
//                picUrls?.removeSubrange((picUrls?.startIndex)! + 4..<(picUrls?.endIndex)!)
//                pictureView.urls = picUrls
//            }
//            else{
//                pictureView.urls = viewModel?.status.pic_urls
//            }
//            pictureView.urls = viewModel?.picURLs
            //pictureView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
            pictureView.viewModel = viewModel
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        /*
        //离屏渲染--异步绘制
        layer.drawsAsynchronously = true
        //栅格化--异步绘制，会生成一张图像，cell在屏幕上滚动的时候，本质上滚动的是这张图片
        //cell 优化，要尽量减少图层的数量，相当于只有一层
        //停止滚动之后可以接受监听
        layer.shouldRasterize = true
        //设置分辨率
        layer.rasterizationScale = UIScreen.main.scale
         */
        
        statusLabel.delegate = self;
        retweetedLabel?.delegate = self;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension WBStatusCell: FFLabelDelegate{
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
       //url判断
        if !text.hasPrefix("http://") {
            return
        }
        
        //插入？表示如果代理没有实现协议方法就什么都不做，
        //如果使用！，代理没有实现协议方法会奔溃
        delegate?.statusCellDidSelectedUrlString?(cell: self, urlString: text)
    }
}
