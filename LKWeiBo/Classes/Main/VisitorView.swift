//
//  VisitorView.swift
//  LKWeiBo
//
//  Created by Kai Liu on 17/3/6.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

/**
protocol VisitorViewDelegate: NSObjectProtocol
{
    //默认情况下 协议中的方法必须实现
    func visitorViewDidClickLoginBtn(visitor: VisitorView)
    func visitorViewDidClickRegisterBtn(visitor: VisitorView)
}
 */

class VisitorView: UIView {

    // 转盘
    @IBOutlet weak var rotationView: UIImageView!
    // 标题
    @IBOutlet weak var titleLabel: UILabel!
    // 图标
    @IBOutlet weak var iconView: UIImageView!
    // 注册
    @IBOutlet weak var registerButton: UIButton!
    // 登录
    @IBOutlet weak var loginButton: UIButton!
    
    //代理
    //weak var delegate: VisitorViewDelegate?
    
    //设置访客视图上的数据
    func setupVisitorInfo(imageName: String?, title: String)
    {
        
        titleLabel.text = title
        
        //没有设置图标，首页
        guard let name = imageName else
        {
            //执行转盘动画
            starAnimation()
            
            return
        }
        
        //不是首页
        rotationView.isHidden = true
        iconView.image = UIImage(named: name)
        
    }
    
    //转盘动画
    private func starAnimation()
    {
        //创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        //设置动画属性
        anim.toValue = 2 * Double.pi
        anim.duration = 5.0
        anim.repeatCount = MAXFLOAT
        //注意：默认情况下，视图消失或者切换，动画都会自动移除
        anim.isRemovedOnCompletion = false
        //将动画添加到图层上
        rotationView.layer.add(anim, forKey: nil)
    }
    
    /**
    //注册点击事件
    @IBAction func RegisterBtnClick(_ sender: Any)
    {
        //delegate?.visitorViewDidClickRegisterBtn(visitor: self)
    }
    
    //登录点击事件
    @IBAction func LoginBtnClick(_ sender: Any)
    {
        //delegate?.visitorViewDidClickLoginBtn(visitor: self)
    }
    */
    
    // func       ==  -
    // class func ==  +
    class func visitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.last as! VisitorView
    }

}
