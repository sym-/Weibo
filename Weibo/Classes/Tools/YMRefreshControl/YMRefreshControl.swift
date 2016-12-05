//
//  YMRefreshControl.swift
//  Weibo
//
//  Created by 宋元明 on 16/12/4.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

/// 刷新控件
class YMRefreshControl: UIControl {
    
    /// 刷新控件的父视图
    private weak var scrollView: UIScrollView?

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
        
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv.bounds.width,
                            height: height)
    }
    
    func beginRefreshing() {
        
    }

    func endRefreshing() {
        
    }
}

extension YMRefreshControl{
    fileprivate func setupUI(){
        backgroundColor = UIColor.orange
    }
}
