//
//  WBComposeTypeView.swift
//  Weibo
//
//  Created by 宋元明 on 16/12/6.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit
import pop

class WBComposeTypeView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //关闭按钮约束
    @IBOutlet weak var closeButtonCenterX: NSLayoutConstraint!
    //返回上一页按钮约束
    @IBOutlet weak var returnButtonCenterX: NSLayoutConstraint!
    //返回上一页按钮
    @IBOutlet weak var returnButton: UIButton!
    
    fileprivate let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBComposeViewController"],
                                   ["imageName": "tabbar_compose_photo", "title": "图片/视频"],
                                   ["imageName": "tabbar_compose_review", "title": "长微博"],
                                   ["imageName": "tabbar_compose_lbs", "title": "签到"],
                                   ["imageName": "tabbar_compose_review", "title": "点评"],
                                   ["imageName": "tabbar_compose_more", "title": "更多","actionName": "clickMore"],
                                   ["imageName": "tabbar_compose_photo", "title": "好友圈"],
                                   ["imageName": "tabbar_compose_camera", "title": "微博相机"],
                                   ["imageName": "tabbar_compose_photo", "title": "音乐"],
                                   ["imageName": "tabbar_compose_camera", "title": "拍摄"]]
    fileprivate var completionBlock: ((_ clsName: String?) -> ())?
    
    class func composeTypeView() -> WBComposeTypeView{
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
        
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
        view.frame = UIScreen.main.bounds
        
        view.setupUI()
        
        return view
    }

    func show(completion: @escaping (_ clsName: String?) -> ()) {
        completionBlock = completion
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        vc.view.addSubview(self)
        
        showCurrentView()
    }
    
    override func awakeFromNib() {
        
    }
    
    @objc fileprivate func clickButton(selectedButton: WBComposeTypeButton){
        print("点我了")
        
        let page = Int(scrollView.contentOffset.x / scrollView.width)
        let view = scrollView.subviews[page]
        
        for btn in view.subviews {
            //缩放动画
            let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            let scale = btn == selectedButton ? 2 : 0.2
            scaleAnim.toValue = NSValue.init(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim.duration = 0.5
            
            btn.pop_add(scaleAnim, forKey: nil)
            
            //渐变动画
            let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnim.toValue = 0.2
            alphaAnim.duration = 0.5
            
            btn.pop_add(alphaAnim, forKey: nil)
            
            if btn == view.subviews[0] {
                alphaAnim.completionBlock = { (_,_) in
                    if self.completionBlock != nil {
                        self.completionBlock?(selectedButton.clsName);
                    }
                }
            }
        }
    }
    
    //移除
    @IBAction func close(_ sender: UIButton) {
        hideButtons()
//        removeFromSuperview()
    }
    
    @objc fileprivate func clickMore(){
        print("点击更多")
        scrollView.setContentOffset(CGPoint(x: scrollView.width, y: 0), animated: true)
        
        //底部按钮处理
        returnButton.isHidden = false
        
        let margin = scrollView.width / 6
        returnButtonCenterX.constant -= margin
        closeButtonCenterX.constant += margin
        
        UIView.animate(withDuration: 0.3){
            self.layoutIfNeeded()
        }
    }
    
    //返回上一页
    @IBAction func clickReturn(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        //底部按钮处理
        
        
        returnButtonCenterX.constant = 0
        closeButtonCenterX.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
            self.returnButton.alpha = 0
        }){ _ in
            self.returnButton.isHidden = true
            self.returnButton.alpha = 1
        }
    }
}

//动画
fileprivate extension WBComposeTypeView{
    func showCurrentView() {
        //创建动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.25
        
        pop_add(anim, forKey: nil)
        
        showButtons()
    }
    
    func showButtons() {
        let v = scrollView.subviews[0]
        
        for (i,btn) in v.subviews.enumerated(){
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.centerY + 350
            anim.toValue = btn.centerY
            anim.springBounciness = 8
            anim.springSpeed = 8
            //设置延迟
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            btn.layer.pop_add(anim, forKey: nil)
        }
    }
    
    func hideButtons() {
        let idx = Int(scrollView.contentOffset.x / scrollView.width)
        let v = scrollView.subviews[idx]
        
        for (i,btn) in v.subviews.reversed().enumerated() {
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.centerY
            anim.toValue = btn.centerY + 350
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            btn.layer.pop_add(anim, forKey: nil)
            
            if i == subviews.count - 1 {
                anim.completionBlock = { (_,finished) in
                    if finished {
                        self.hideCurrentView()
                    }
                }
            }
        }
    }
    
    func hideCurrentView() {
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.25
        
        pop_add(anim, forKey: nil)
        
        anim.completionBlock = { (_,finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
}

//设置UI
fileprivate extension WBComposeTypeView{
    func setupUI() {
        layoutIfNeeded()
        let rect = scrollView.bounds
        let width = scrollView.width
        for i in 0..<2 {
            let view = UIView(frame: rect.offsetBy(dx: CGFloat(i) * width, dy: 0))
            addButtons(v: view, idx: i * 6)
            scrollView.addSubview(view)
        }
        
        scrollView.contentSize = CGSize(width: 2 * width, height: 0)
    }
    
    /// 向v中添加按钮，按钮的数组索引从idx开始
    ///
    /// - Parameters:
    ///   - v: 父视图
    ///   - idx: 索引
    func addButtons(v:UIView, idx:Int) {
        let count = 6
        for i in idx..<(idx + count){
            if i >= buttonsInfo.count {
                break
            }
            let dict = buttonsInfo[i]
            guard let imageName = dict["imageName"],
                let title = dict["title"] else{
                    continue
            }
            let btn = WBComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            
            v.addSubview(btn)
            
            //监听方法
            if let actionName = dict["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            else{
                btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            }
            
            btn.clsName = dict["clsName"]
        }
        
        //布局按钮
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - 3 * btnSize.width) / 4
        for (i,btn) in v.subviews.enumerated(){
            let y: CGFloat = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            let col = i % 3
            let x = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            btn.frame = CGRect(origin: CGPoint(x: x, y: y), size: btnSize)
        }
    }
}
