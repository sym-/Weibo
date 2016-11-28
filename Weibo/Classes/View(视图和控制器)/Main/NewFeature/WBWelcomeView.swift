//
//  WBWelcomeView.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/28.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBWelcomeView: UIView {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    class func welcomeView()->WBWelcomeView{
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as? WBWelcomeView ?? WBWelcomeView()
        v.frame = UIScreen.main.bounds
        
        
        return v
    }
    
    override func awakeFromNib() {
        guard let urlStr = WBNetworkManager.shared.userAccount.avatar_large else{
            return
        }
        iconView.setImageWith(URL(string: urlStr), placeholder: UIImage(named: "avatar_default"))
        iconView.layer.cornerRadius = iconView.width / 2.0
        iconView.layer.masksToBounds = true
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.layoutIfNeeded()
        self.bottomConstraint.constant = self.bounds.size.height - 200
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.layoutIfNeeded()
        },
                       completion: {(finish) in
                        UIView.animate(withDuration: 1.0, animations: { 
                            self.tipLabel.alpha = 1.0
                        }, completion:{(finish) in
                            self.removeFromSuperview()
                        })
        })
        
        
        
    }
}
