//
//  WBStatusToolBar.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/30.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {

    var viewModel: WBStatusViewModel?{
        didSet{
            retweetButton.setTitle(viewModel?.retweetedStr, for: .normal)
            commentButton.setTitle(viewModel?.commentStr, for: .normal)
            likeButton.setTitle(viewModel?.likeStr, for: .normal)
        }
    }
    
    /// 转发
    @IBOutlet weak var retweetButton: UIButton!
    
    /// 评论
    @IBOutlet weak var commentButton: UIButton!
    
    /// 点赞
    @IBOutlet weak var likeButton: UIButton!
}
