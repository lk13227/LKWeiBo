//
//  LKTitleView.swift
//  LKWeiBo
//
//  Created by LiuKai on 2017/4/19.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//发布界面的标题 view

import UIKit
import SnapKit

class LKTitleView: UIView {

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
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }

    // MARK: - 懒加载
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "发送微博"
        lb.font = UIFont.systemFont(ofSize: 18)
        return lb
    }()
    private lazy var subTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "发送微博"
        lb.textColor = UIColor.lightGray
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
    }()
}
