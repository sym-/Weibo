//
//  WBStatusCell.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/29.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBStatusCell: UITableViewCell {
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    /// 认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    /// 底部工具栏
    @IBOutlet weak var toolBar: WBStatusToolBar!

    
    /// 配图视图
    @IBOutlet weak var pictureView: WBStatusPictureView!
    
    
    var viewModel: WBStatusViewModel?{
        didSet{
            statusLabel.text = viewModel?.status.text
            nameLabel.text = viewModel?.status.user?.screen_name
            memberIconView.image = viewModel?.memberIcon
            vipIconView.image = viewModel?.vipIcon
            iconView.ym_setImage(urlStr: viewModel?.status.user?.profile_image_url, placeHolderImage: UIImage(named: "avatar_default"), isAvatar: true)
            toolBar.viewModel = viewModel
            pictureView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
            timeLabel.text = viewModel?.status.created_at
            sourceLabel.text = viewModel?.status.source
//            if viewModel?.status.pic_urls?.count ?? 0 > 4 {
//                var picUrls = viewModel?.status.pic_urls
//                picUrls?.removeSubrange((picUrls?.startIndex)! + 4..<(picUrls?.endIndex)!)
//                pictureView.urls = picUrls
//            }
//            else{
//                pictureView.urls = viewModel?.status.pic_urls
//            }
            pictureView.urls = viewModel?.status.pic_urls
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
