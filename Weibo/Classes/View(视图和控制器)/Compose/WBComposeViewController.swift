//
//  WBComposeViewController.swift
//  Weibo
//
//  Created by 宋元明 on 16/12/8.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBComposeViewController: UIViewController {
    
    @IBOutlet weak var textView: WBComposeTextView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    
    //工具栏底部约束
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    
    /// 表情键盘
    lazy var emoticonView: YMEmoticonInputView = YMEmoticonInputView.inputView {[weak self] (emoticon: YMEmoticon?) in
        self?.textView.insertEmoticon(em: emoticon)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        
        //监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //打开键盘
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //关闭键盘
        textView.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardChanged (n: Notification){
        guard let rect = (n.userInfo?[UIKeyboardFrameEndUserInfoKey]    as? NSValue)?.cgRectValue,
            let duration = (n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else{
            return
        }
        
        let offset = view.bounds.height - rect.origin.y
        
        toolbarBottomConstraint.constant = offset
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func close(){
        dismiss(animated: true, completion: nil)
    }


    //发布微博
    @IBAction func postStatus(_ sender: Any) {
        let text = textView.emoticonText
//        let image = UIImage(named: "compose_slogan")
        WBNetworkManager.shared.poseStatus(status: text, image: nil) { (result, isSuccess) in
            let message = isSuccess ? "发送成功" : "发送失败"
            
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showInfo(withStatus: message)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                SVProgressHUD.setDefaultStyle(.light)
                self.close()
            })
        }
    }
    
    //切换表情键盘
    @objc fileprivate func emoticonKeyboard(){        
        textView.inputView = textView.inputView == nil ? emoticonView : nil
        
        //刷新键盘
        textView.reloadInputViews()
    }
}

fileprivate extension WBComposeViewController{
    func setupUI() {
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupToolbar()
        sendButton.isEnabled = false
    }
    
    func setupToolbar() {
        let itemSetting = [["imageName": "compose_toolbar_picture"],
                           ["imageName": "compose_mentionbutton_background"],
                           ["imageName": "compose_trendbutton_background"],
                           ["imageName": "compose_emoticonbutton_background","actionName":"emoticonKeyboard"],
                           ["imageName": "compose_keyboardbutton_background"]
                            ]
        var items = [UIBarButtonItem]()
        for s in itemSetting{
            guard let imageName = s["imageName"] else {
                continue
            }
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            
            let btn: UIButton
            if s == itemSetting.last! {
                btn = UIButton(type: .custom)
                btn.setBackgroundImage(image, for: .normal)
                btn.setBackgroundImage(imageHL, for: .highlighted)
                btn.sizeToFit()
            }
            else{
                btn = UIButton(type: .custom)
                btn.setImage(image, for: .normal)
                btn.setImage(imageHL, for: .highlighted)
                btn.sizeToFit()
            }
            
            if let actionName = s["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            items.append(UIBarButtonItem(customView: btn))
            
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        items.removeLast()
        toolbar.items = items
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", target: self, action: #selector(close))

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        navigationItem.titleView = titleLabel
    }
}

//textview代理
extension WBComposeViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.hasText
    }
}
