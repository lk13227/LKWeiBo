//
//  LKPresentaionManager.swift
//  LKWeiBo
//
//  Created by Kai Liu on 17/3/8.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

class LKPresentaionManager: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning
{
    /// 记录菜单当前是否展现
    var isPresent = false
    
    /// 标题菜单的尺寸
    var presentFrame = CGRect.zero
    
    // MARK: - UIViewControllerTransitioningDelegate
    /// 该方法用于返回一个负责转场动画的对象
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
        let pc = LKPresentationController(presentedViewController: presented, presenting: presenting)
        pc.presentFrame = presentFrame
        return pc
    }
    
    /// 该方法用于返回一个负责转场如何出现的对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = true
        // 发送一个通知,告诉调用者按钮状态发生了改变
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LKPresentaionManagerDidPresented), object: self)
        return self
    }
    
    /// 该方法用于返回一个负责转场如何消失的对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = false
        // 发送一个通知,告诉调用者按钮状态发生了改变
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LKPresentaionManagerDidDismissed), object: self)
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    /// 展现和消失的动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.5
    }
    
    /// 专门用于管理modal如何展现和消失
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        //判断当前是展现还是消失
        if isPresent
        {//展现
            
            willPresentedController(transitionContext: transitionContext)
            
        } else {//消失
            
            willDismissedController(transitionContext: transitionContext)
            
        }
        
    }
    
    /// 执行展现动画
    private func willPresentedController(transitionContext: UIViewControllerContextTransitioning)
    {
        // 获取需要弹出的视图
        /**
         let toVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
         let fromVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
         */
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else
        {
            return
        }
        
        // 将需要弹出的视图添加到 containerView 上
        transitionContext.containerView.addSubview(toView)
        
        // 执行动画
        toView.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            //设置锚点
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            toView.transform = CGAffineTransform.identity
            
        }) { (_) in
            
            // 自定义转场动画,在执行完动画后,要告诉系统动画执行完毕
            transitionContext.completeTransition(true)
            
        }
    }
    
    /// 执行消失动画
    private func willDismissedController(transitionContext: UIViewControllerContextTransitioning)
    {
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else
        {
            return
        }
        
        //执行动画 使视图消失
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            // 动画突然消失:CGfloat 不准确,需要将其设为一个很小的值
            fromView.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.000001)
            
        }, completion: { (_) in
            
            // 自定义转场动画,在执行完动画后,要告诉系统动画执行完毕
            transitionContext.completeTransition(true)
            
        })
    }
    
}
