//
//  WBNewFeatureView.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/28.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBNewFeatureView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    class func newFeatureView()->WBNewFeatureView{
        let nib = UINib(nibName: "WBNewFeatureView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as? WBNewFeatureView ?? WBNewFeatureView()
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    override func awakeFromNib() {
        let rect = UIScreen.main.bounds
        let count = 4
        for i in 0..<count{
            let imageName = "new_feature_\(i + 1)"
            let iv = UIImageView(image: UIImage(named: imageName))
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.size.width, dy: 0)
            scrollView.addSubview(iv)
        }
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: 0)
        scrollView.delegate = self
        enterButton.isHidden = true
    }
    
    @IBAction func enterStatus(_ sender: UIButton) {
        removeFromSuperview()
    }
    
}

extension WBNewFeatureView: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.width)
        if page == scrollView.subviews.count{
            //最后一页
            removeFromSuperview()
        }
        
        if page == scrollView.subviews.count - 1 {
            enterButton.isHidden = false
        }
        else{
            enterButton.isHidden = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        enterButton.isHidden = true
        let page = Int(scrollView.contentOffset.x / scrollView.width + 0.5)
        pageControl.currentPage = page
        pageControl.isHidden = page == scrollView.subviews.count
    }
}
