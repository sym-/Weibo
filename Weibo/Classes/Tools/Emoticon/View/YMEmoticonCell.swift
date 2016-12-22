//
//  YMEmoticonCell.swift
//  表情键盘
//
//  Created by 宋元明 on 2016/12/19.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

@objc protocol YMEmoticonCellDelegate: NSObjectProtocol{
    
    /// 表情cell选中表情模型
    ///
    /// - Parameter em: 表情模型/nil表示删除
    func emoticonCellDidSelectedEmoticon(cell: YMEmoticonCell,em: YMEmoticon?)
}

/// 表情的页面cell，每个页面用九宫格算法添加20个表情
class YMEmoticonCell: UICollectionViewCell {
    
    weak var delegate: YMEmoticonCellDelegate?

    //当前页面的表情模型数组，最多20个
    var emoticons: [YMEmoticon]?{
        didSet{
            for v in contentView.subviews {
                v.isHidden = true
            }
            
            for (i,em) in (emoticons ?? []).enumerated() {
                let btn = contentView.subviews[i] as! UIButton
                //设置图片
                btn.setImage(em.image, for: .normal)
                
                //设置emoji图片
                btn.setTitle(em.emoji, for: .normal)
                
                btn.isHidden = false
            }
            
            contentView.subviews.last?.isHidden = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //button监听
    //选中表情按钮
    @objc fileprivate func selectedEmoticonButton(button: UIButton){
        let tag = button.tag
        
        //判断是否删除按钮
        var em: YMEmoticon?
        if tag < emoticons?.count ?? 0 {
            em = emoticons?[tag]
        }
        
        delegate?.emoticonCellDidSelectedEmoticon(cell: self, em: em)
    }
    
}


fileprivate extension YMEmoticonCell{
    func setupUI() {
        //连续创建21个按钮
        let rowCount = 3
        let colCount = 7
        
        //左右间距
        let leftMargin: CGFloat = 8
        //底部间距，为分页控件预留
        let bottomMargin: CGFloat = 16
        let w = (bounds.width - 2 * leftMargin) / CGFloat(colCount)
        let h = (bounds.height - bottomMargin) / CGFloat(rowCount)
        for i in 0..<21 {
            let row = i / colCount
            let col = i % colCount
            
            let x = leftMargin + CGFloat(col)*w
            let y = CGFloat(row)*h
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: x, y: y, width: w, height: h)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            btn.tag = i
            btn.addTarget(self, action: #selector(selectedEmoticonButton), for: .touchUpInside)
            
            contentView.addSubview(btn)
        }
        
        //末尾删除按钮
        let removeButton = contentView.subviews.last as! UIButton
        let image = UIImage(named: "compose_emotion_delete", in: YMEmoticonManager.shared.bundle, compatibleWith: nil)
        let imageHL = UIImage(named: "compose_emotion_delete_highlighted", in: YMEmoticonManager.shared.bundle, compatibleWith: nil)
        removeButton.setImage(image, for: .normal)
        removeButton.setImage(imageHL, for: .highlighted)
    }
}
