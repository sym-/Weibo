//
//  YMRefreshView.swift
//  RefreshControl
//
//  Created by 宋元明 on 16/12/5.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class YMRefreshView: UIView {

    /// 提示图标
    @IBOutlet weak var tipIcon: UIImageView?
    
    /// 提示标签
    @IBOutlet weak var tipLabel: UILabel?

    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    
    /// 父视图高度
    var parentViewHeight: CGFloat = 0
    
    /*
     iOS系统中UIView封装的旋转动画
     -默认顺时针旋转
     -就近原则
     -要实现同方向旋转，要调整一个小角度
     -实现360度旋转，用core animation
     */
    var refreshState: YMRefreshState = .Normal{
        didSet{
            switch refreshState {
            case .Normal:
                tipLabel?.text = "继续使劲拉..."
                tipIcon?.isHidden = false
                indicator?.stopAnimating()
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon?.transform = CGAffineTransform.identity
                });
            case .Pulling:
                tipLabel?.text = "放手就刷新..."
                tipIcon?.isHidden = false
                indicator?.stopAnimating()
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI - 0.001))
                });
            case .WillRefresh:
                tipLabel?.text = "正在刷新中..."
                tipIcon?.isHidden = true
                indicator?.startAnimating()
            }
        }
    }
    
    class func refreshView() -> YMRefreshView {
        let nib = UINib(nibName: "YMDianPingRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! YMRefreshView
    }
    
    override func awakeFromNib() {
        tipIcon?.image = UIImage(named: "YMRefresh.bundle/arrow@2x.png")
    }
}
