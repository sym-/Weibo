//
//  UIImageView+Extension.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/30.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import SDWebImage

extension UIImageView{
    func ym_setImage(urlStr: String?, placeHolderImage: UIImage?, isAvatar: Bool = false){
        guard let urlStr = urlStr,
            let url = URL(string: urlStr) else{
            image = placeHolderImage
            return
        }
        
        sd_setImage(with: url,
                    placeholderImage: placeHolderImage,
                    options: [],
                    progress: nil,
                    completed: {[weak self] (image, error, _, _) in
                        if isAvatar {
                            self?.image = image?.ym_avatarImage(size: self?.bounds.size)
                        }
        })
    }
}
