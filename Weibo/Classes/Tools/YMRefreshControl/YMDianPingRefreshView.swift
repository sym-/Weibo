//
//  YMDianPingRefreshView.swift
//  RefreshControl
//
//  Created by 宋元明 on 16/12/6.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class YMDianPingRefreshView: YMRefreshView {

    @IBOutlet weak var dropdownImageView: UIImageView!
    
    @IBOutlet weak var dianPingTipLabel: UILabel!
    
    /// 设置普通状态的动画图片
    lazy var normalImages = [UIImage]()
    
    /// 设置刷新状态的动画图片
    lazy var refreshingImages = [UIImage]()
    
    
    override var parentViewHeight: CGFloat {
        didSet{
            // 0 - 60
            var index: Int = Int(parentViewHeight / YMRefreshOffset * 59)
            index = index > 59 ? 59 : index
            index = index < 0 ? 0 : index
            print("index is: \(index)")
            dropdownImageView.image = normalImages[index]
        }
    }
    
    override var refreshState: YMRefreshState{
        didSet{
            switch refreshState {
            case .Normal:
                dianPingTipLabel.text = "继续使劲拉..."
                dropdownImageView.stopAnimating()
            case .Pulling:
                dianPingTipLabel.text = "放手就刷新..."
                !dropdownImageView.isAnimating ? dropdownImageView.startAnimating() : ()
            case .WillRefresh:
                dianPingTipLabel.text = "正在刷新中..."
                !dropdownImageView.isAnimating ? dropdownImageView.startAnimating() : ()
            }
        }
    }
    
    override func awakeFromNib() {
        for i in 1...60 {
            guard let image = UIImage(named: "dropdown_anim__000\(i)") else{
                continue
            }
            normalImages.append(image)
        }
        
        for j in 1...3 {
            guard let image = UIImage(named: "dropdown_loading_0\(j)") else{
                continue
            }
            refreshingImages.append(image)
        }
        
        dropdownImageView.animationImages = refreshingImages
        dropdownImageView.animationRepeatCount = Int.max
        dropdownImageView.animationDuration = 0.5
    }
}
