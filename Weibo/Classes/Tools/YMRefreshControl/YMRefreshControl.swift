//
//  YMRefreshControl.swift
//  Weibo
//
//  Created by 宋元明 on 16/12/4.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

/// 刷新状态切换临界点
let YMRefreshOffset: CGFloat = 60


/// 刷新状态
///
/// - Normal: 普通状态，什么都不做
/// - Pulling: 超过临界点，如果放手开始刷新
/// - WillRefresh: 超过临界点，并且放手
enum YMRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

/// 刷新控件
class YMRefreshControl: UIControl {
    
    /// 刷新控件的父视图
    fileprivate weak var scrollView: UIScrollView?
    
    fileprivate lazy var refreshView: YMRefreshView = YMRefreshView.refreshView()

    init() {
        super.init(frame: CGRect.zero)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    /*
     willMove addSubview方法会调用它
     -当添加到父视图时， newSuperview是父视图
     -当父视图被移除时， newSuperview为nil
     */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let scroll = newSuperview as? UIScrollView else {
            return
        }
        scrollView = scroll
        
        //kvo
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("scrollView offset and bounds frame is:\(scrollView?.contentOffset)+++++\(scrollView?.bounds)++++\(scrollView?.frame)")
        
        guard let sv = scrollView else {
            return
        }
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        print("高度：\(height)")
        
        // 往上拖拽 return
        if height < 0 {
            return
        }
        
        //传递高度
        refreshView.parentViewHeight = height
        
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv.bounds.width,
                            height: height)
        // 临界点判断
        if sv.isDragging{
            if height > YMRefreshOffset && refreshView.refreshState == .Normal{
                print("放手刷新")
                refreshView.refreshState = .Pulling
            }
            else if height <= YMRefreshOffset && refreshView.refreshState == .Pulling{
                print("在使劲")
                refreshView.refreshState = .Normal
                
            }
        }
        else{
            if refreshView.refreshState == .Pulling{
                print("准备开始刷新")
                
                beginRefreshing()
                //发送刷新事件
                sendActions(for: .valueChanged)
            }
        }
    }
    
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
    }
    
    func beginRefreshing() {
        guard let sv = scrollView else {
            return
        }
        
        //正在刷新，return
        if refreshView.refreshState == .WillRefresh {
            return
        }
        //刷新结束后，要改状态为.Normal，才能够继续刷新
        refreshView.refreshState = .WillRefresh
        
        //显示刷新视图
        var inset = sv.contentInset
        inset.top += YMRefreshOffset
        sv.contentInset = inset
        
        refreshView.parentViewHeight = YMRefreshOffset
    }

    func endRefreshing() {
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshState != .WillRefresh {
            return
        }
        
        refreshView.refreshState = .Normal
        
        //恢复/隐藏 刷新视图
        var inset = sv.contentInset
        inset.top -= YMRefreshOffset
        sv.contentInset = inset
    }
}

extension YMRefreshControl{
    fileprivate func setupUI(){
        backgroundColor = superview?.backgroundColor
        //clipsToBounds = true
        addSubview(refreshView)
        
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0.0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0.0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
        
    }
}
