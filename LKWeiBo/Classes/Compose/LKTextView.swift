//
//  LKTextView.swift
//  LKWeiBo
//
//  Created by LiuKai on 2017/4/19.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//自定义发布的 UITextView

import UIKit
import SnapKit

class LKTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 内部控制方法
    private func setupUI()
    {
        addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.top.equalTo(6)
        }
        
        // 文本发生变化会发送通知与代理
        NotificationCenter.default.addObserver( self, selector: #selector(LKTextView.textChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    // 通知方法
    @objc private func textChange()
    {
        // 控制提示文本是否显示
        placeholderLabel.isHidden = hasText
    }
    
    // MARK: - 懒加载
    private lazy var placeholderLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.text = "分享新鲜事..."
        lb.font = self.font
        return lb
    }()
}
