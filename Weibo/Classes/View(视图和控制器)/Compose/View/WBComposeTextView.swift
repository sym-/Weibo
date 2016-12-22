//
//  WBComposeTextView.swift
//  Weibo
//
//  Created by 宋元明 on 2016/12/15.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit

class WBComposeTextView: UITextView {

    fileprivate lazy var placeHolderLabel = UILabel()

    override func awakeFromNib() {
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func textChanged(){
        placeHolderLabel.isHidden = hasText
    }
}

fileprivate extension WBComposeTextView{
    func setupUI() {
        placeHolderLabel.text = "分享新鲜事..."
        placeHolderLabel.font = font
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.sizeToFit()
        placeHolderLabel.frame.origin = CGPoint.init(x: 5, y: 8)
        
        addSubview(placeHolderLabel)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: .UITextViewTextDidChange, object: self)
    }
}

//表情键盘方法
extension WBComposeTextView{
    var emoticonText: String{
        guard let attrStr = attributedText else{
            return ""
        }
        var result = String()
        attrStr.enumerateAttributes(in: NSMakeRange(0, attrStr.length), options: [], using: { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? YMEmoticonAttachment {
                result += attachment.chs ?? ""
            }
            else{
                let str = attrStr.string as NSString
                let subStr = str.substring(with: range)
                //                print("\(str)+++++++\(range.location)+++++++\(range.length)++++++++++++\(subStr)")
                
                result += subStr
            }
        })
        return result
    }
    
    func insertEmoticon(em: YMEmoticon?) {
        //删除
        guard let em = em else {
            deleteBackward()
            
            return
        }
        
        //emoji
        if let emoji = em.emoji,
            let textRange = selectedTextRange{
            replace(textRange, withText: emoji)
        }
        
        //图片
        //所有的排版系统中，几乎都有一个共同点，插入的字符显示更随前一个字符的属性，但是本身“并没有”属性
        let textViewFont = font ?? UIFont.systemFont(ofSize: 18)
        let imageText = em.imageText(font: textViewFont)
        
        let attrStrM = NSMutableAttributedString(attributedString: attributedText)
        attrStrM.replaceCharacters(in: selectedRange, with: imageText)
        let range = selectedRange
        attributedText = attrStrM
        selectedRange = NSMakeRange(range.location + imageText.length, 0)
        textChanged()
    }
}
