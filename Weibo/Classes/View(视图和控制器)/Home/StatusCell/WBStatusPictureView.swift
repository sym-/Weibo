//
//  WBStatusPictureView.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/30.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {
    
    var viewModel: WBStatusViewModel?{
        didSet{
            calcViewSize()
            
            urls = viewModel?.picURLs
        }
    }
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
     fileprivate var urls: [WBStatusPicture]?{
        didSet{
            for v in subviews{
                v.isHidden = true
            }
            
            var index = 0
            for url in urls ?? []{
                let iv = subviews[index] as! UIImageView
                iv.ym_setImage(urlStr: url.thumbnail_pic, placeHolderImage: nil)
                iv.isHidden = false
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                index += 1
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    /// 根据视图模型配图视图大小，调整显示内容
    fileprivate func calcViewSize(){
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
        
        let viewSize = viewModel?.pictureViewSize ?? CGSize.zero
        let imageV0 = subviews[0]
        //1.单图
        if viewModel?.picURLs?.count == 1 {
            imageV0.frame = CGRect(x: 0,
                                   y:WBStatusPictureViewOutterMargin,
                                   width: viewSize.width,
                                   height: viewSize.height - WBStatusPictureViewOutterMargin)
        }
            //2.多图
        else{
            imageV0.frame = CGRect(x: 0,
                                   y: WBStatusPictureViewOutterMargin,
                                   width: WBStatusPictureItemWidth,
                                   height: WBStatusPictureItemWidth)
        }
        
    }
}

extension WBStatusPictureView{
    fileprivate func setupUI(){
        clipsToBounds = true
        backgroundColor = superview?.backgroundColor
        //9个图
        let count = 3
        let rect = CGRect(x: 0,
                          y: WBStatusPictureViewOutterMargin,
                          width: WBStatusPictureItemWidth,
                          height: WBStatusPictureItemWidth)
        for i in 0..<count * count{
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            /// 行 -> y
            let row = CGFloat(i / count)
            
            /// 列 -> x
            let col = CGFloat(i % count)
            
            let xOffset = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            let yOffset = row * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
//            iv.backgroundColor = UIColor.red
            addSubview(iv)
        }
    }
}
