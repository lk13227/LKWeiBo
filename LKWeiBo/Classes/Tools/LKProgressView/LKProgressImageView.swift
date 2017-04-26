//
//  LKProgressImageView.swift
//  ProgressView
//
//  Created by LiuKai on 2017/4/14.
//  Copyright © 2017年 天高云展. All rights reserved.
//

import UIKit

class LKProgressImageView: UIImageView {
    
    /// 记录当前进度
    var progress: CGFloat = 0.0
    {
        didSet
        {
            progressView.progress = progress
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - 内部控制方法
    private func setupUI()
    {
        addSubview(progressView)
        progressView.backgroundColor = UIColor.clear
        
    }

    override func layoutSubviews() {
        progressView.frame = self.bounds
    }
    
    // MARK: - 懒加载
    private lazy var progressView: LKProgressView = LKProgressView()

}
