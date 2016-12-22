//
//  YMEmoticonLayout.swift
//  表情键盘
//
//  Created by 宋元明 on 2016/12/19.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class YMEmoticonLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return
        }
        
        itemSize = collectionView.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
    }
}
