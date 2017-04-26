//
//  ComposeViewController.swift
//  LKWeiBo
//
//  Created by LiuKai on 2017/4/18.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    /// 输入框
    @IBOutlet weak var customTextView: LKTextView!
    /// 发送按钮
    @IBOutlet weak var sendItem: UIBarButtonItem!
    /// 工具条底部约束
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注册通知,监听键盘变化
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.keyboardWillChange(notice:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // 将键盘控制 添加为当前控制器的子控件
        addChildViewController(keyboardEmoticonVC)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 进入页面弹出键盘
        customTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 退出页面先退出键盘
        customTextView.resignFirstResponder()
    }
    
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 内部控制按钮
    /// 关闭按钮
    @IBAction func closeBtnClick()
    {
        dismiss(animated: true, completion: nil)
    }

    /// 发送按钮
    @IBAction func sendBtnClick()
    {
        // 获取用户输入内容
        let text = customTextView.text!
        // 发送请求发送微博
        NetworkTools.shareInstance.sendStatus(status: text) { (objc, error) in
            
            // 报错
            if error != nil
            {
                SVProgressHUD.showError(withStatus: "发送微博失败")
                return
            }
            
            // 成功
            SVProgressHUD.showSuccess(withStatus: "发送微博成功")
            self.closeBtnClick()
            
        }
    }
    
    /// 键盘按钮点击事件
    @IBAction func emoticonBtnClick(_ sender: Any)
    {
        
        // 关闭键盘
        customTextView.resignFirstResponder()
        
        // 判断 inputView 是否是 nil
        if customTextView.inputView != nil {
            
            // 切换为系统键盘
            customTextView.inputView = nil
            
        } else {
            
            // 切换为自定义键盘
            customTextView.inputView = keyboardEmoticonVC.view
            
        }
        
        // 重新打开键盘
        customTextView.becomeFirstResponder()
        
    }
    
    /// 图片点击事件
    @IBAction func pictureBtnClick(_ sender: Any)
    {
        
    }
    
    /// 通知方法
    func keyboardWillChange(notice: Notification)
    {
        // 弹出: AnyHashable("UIKeyboardFrameEndUserInfoKey"): NSRect: {{0, 736}, {414, 271}}
        // 关闭: AnyHashable("UIKeyboardFrameEndUserInfoKey"): NSRect: {{0, 736}, {414, 271}}
        //LKLog(message: notice)
        
        // 将工具条移到键盘上去
        // 获取键盘的 frame
        let rect = (notice.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        assert(rect != nil, "键盘高度返回值为空")
        // 获取屏幕的高度
        let height = UIScreen.main.bounds.height
        // 计算需要移动的距离
        let offsetY = height - (rect?.origin.y)!
        // 获取动画当前的节奏
        let curve = notice.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        // 修改工具条底部约束
        toolbarBottomCons.constant = offsetY
        // 添加动画
        UIView.animate(withDuration: 0.25) {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.intValue)!)
            self.view.layoutIfNeeded()
        }
        
    }
    
    // MARK: - 懒加载
    /// 表情键盘控制器
    private lazy var keyboardEmoticonVC: LKKeyboardEmoticonViewController = LKKeyboardEmoticonViewController()
    
}

// MARK: - UITextViewDelegate
extension ComposeViewController: UITextViewDelegate
{
    // textView内容发生改变时
    func textViewDidChange(_ textView: UITextView)
    {
        /// 控制发送按钮能否被点击
        sendItem.isEnabled = textView.hasText
    }
    
    // scrollView将要被滑动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 收回键盘
        customTextView.resignFirstResponder()
    }
    
}
