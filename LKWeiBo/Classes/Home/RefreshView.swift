//
//  RefreshView.swift
//  LKWeiBo
//
//  Created by 888 on 2017/4/11.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit
import SnapKit

class LKRefreshControl: UIRefreshControl
{
    
    override init() {
        super.init()
        // 添加子控件
        addSubview(refreshView)
        // 布局子控件
        refreshView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 150, height: 50))
            make.center.equalTo(self)
        }
        // 监听 RefreshControl frame 改变
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // 删除监听
        removeObserver(self, forKeyPath: "frame")
    }
    
    
    /// 重写停止刷新方法
    override func endRefreshing()
    {
        super.endRefreshing()
//        loadingFlag = false
        refreshView.stopLoadingView()
    }
    
    /// 记录是否需要旋转
    var rotationFlag = false
//    var loadingFlag = false
    // MARK: - 内部控制方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        
        if frame.origin.y == 0 || frame.origin.y == -64
        {
            // 过滤掉垃圾数据
            return
        }
        
        // 判断是否触发了下拉刷新事件
        if isRefreshing // && !loadingFlag
        {
//            loadingFlag = true
            // 隐藏提示视图
            refreshView.startLoadingView()
            return
        }
        
        // 越往下拉 y 越小
        if frame.origin.y < -50 && !rotationFlag {
            rotationFlag = true
            refreshView.rotationArrow(flag: rotationFlag)
        } else if frame.origin.y > -50 && rotationFlag {
            rotationFlag = false
            refreshView.rotationArrow(flag: rotationFlag)
        }
        
    }
    
    // MARK: - 懒加载
    private lazy var refreshView: RefreshView = RefreshView.refreshView()
}

class RefreshView: UIView {

    /// 加载中
    @IBOutlet weak var loadingImageView: UIImageView!
    /// 提示视图
    @IBOutlet weak var tipView: UIView!
    /// 箭头
    @IBOutlet weak var arrowImageView: UIImageView!
    /// 刷新文字
    @IBOutlet weak var refreshLabel: UILabel!
    
    /// 快速创建方法
    class func refreshView() -> RefreshView
    {
        return Bundle.main.loadNibNamed("RefreshView", owner: nil, options: nil)?.last as! RefreshView
    }
    
    // MARK: - 外部控制方法
    /// 旋转箭头
    func rotationArrow(flag: Bool)
    {
        var angle: CGFloat = flag ? -0.01 : 0.01
        angle += CGFloat(Double.pi)
        UIView.animate(withDuration: 0.5) {
            self.arrowImageView.transform = CGAffineTransform.rotated(self.arrowImageView.transform)(by: angle)
        }
        
    }
    
    /// 显示加载视图
    func startLoadingView()
    {
        // 隐藏提示视图
        tipView.isHidden = true
        
        if let _ = loadingImageView.layer.animation(forKey: "lnj")
        {
            return
        }
        
        // 创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 设置动画属性
        anim.toValue = 2 * Double.pi
        anim.duration = 5.0
        anim.repeatCount = MAXFLOAT
        // 将动画添加到图层上
        loadingImageView.layer.add(anim, forKey: "lnj")
    }
    
    // 停止加载中视图
    func stopLoadingView()
    {
        // 显示提示视图
        tipView.isHidden = false
        // 移除动画
        loadingImageView.layer.removeAllAnimations()
    }
    
}
