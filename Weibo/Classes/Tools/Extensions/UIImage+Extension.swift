//
//  UIImage+Extension.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/29.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation

extension UIImage {
    func ym_avatarImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        var size = size
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint.zero, size: size ?? CGSize.zero)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        backColor.setFill()
        UIRectFill(rect)
        
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        
        draw(in: rect)
        
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.lineWidth = 2
        lineColor.setStroke()
        ovalPath.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    
    
    
    
}
