//
//  LKPresentationController.swift
//  LKWeiBo
//
//  Created by Kai Liu on 17/3/8.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

class LKPresentationController: UIPresentationController
{
    /// 标题菜单的尺寸
    var presentFrame = CGRect.zero
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting:presentingViewController)
    }
    
    /// 用于布局转场动画弹出的控件
    override func containerViewWillLayoutSubviews()
    {
        //containerView 容器视图
        //presentedView() 通过该方法能拿到弹出的视图
        
        // 设置弹出视图的尺寸
        presentedView?.frame = presentFrame //CGRect(x: 100, y: 55, width: 200, height: 200)
        
        // 添加蒙版
        containerView?.insertSubview(coverButton, at: 0)
        coverButton.addTarget(self, action: #selector(LKPresentationController.coverBtnClick), for: UIControlEvents.touchUpInside)
    }
    
    // MARK: - 懒加载
    private var coverButton: UIButton = {
        let btn = UIButton()
        btn.frame = UIScreen.main.bounds
        
        return btn
    }()
    
    // MARK: - 内部控制方法
    func coverBtnClick()
    {
         //让菜单消失
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}

