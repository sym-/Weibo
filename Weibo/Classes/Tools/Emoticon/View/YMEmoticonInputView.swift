//
//  YMEmoticonInputView.swift
//  表情键盘
//
//  Created by 宋元明 on 2016/12/16.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

fileprivate let CellId = "CellId"

class YMEmoticonInputView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var toolbar: UIView!
    
    fileprivate var selectedEmoticonCallBack: ((_ emoticon: YMEmoticon?)->())?
    
    class func inputView(selectedEmoticon: @escaping (_ emoticon: YMEmoticon?)->()) -> YMEmoticonInputView{
        let nib = UINib(nibName: "YMEmoticonInputView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! YMEmoticonInputView
        v.selectedEmoticonCallBack = selectedEmoticon
        return v
    }

    override func awakeFromNib() {
//        let nib = UINib(nibName: "YMEmoticonCell", bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: CellId)
        collectionView.register(YMEmoticonCell.self, forCellWithReuseIdentifier: CellId)
    }
}

extension YMEmoticonInputView: UICollectionViewDataSource{
    
    // 分组数量 -返回表情包的数量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return YMEmoticonManager.shared.packages.count
    }
    
    // 返回每个分组中的表情“页”的数量
    // 每个分组表情包中，表情页面的数量 emoticons.count/20
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return YMEmoticonManager.shared.packages[section].numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! YMEmoticonCell
        cell.emoticons = YMEmoticonManager.shared.packages[indexPath.section].emoticon(page: indexPath.item)
        cell.delegate = self
        return cell
    }
}

extension YMEmoticonInputView: YMEmoticonCellDelegate{
    func emoticonCellDidSelectedEmoticon(cell: YMEmoticonCell, em: YMEmoticon?) {
        selectedEmoticonCallBack?(em)
    }
}
