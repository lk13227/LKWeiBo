//
//  TitleButton.swift
//  LKWeiBo
//
//  Created by Kai Liu on 17/3/7.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    
    //通过代码创建时调用
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    //通过xib创建时调用
    required init?(coder aDecoder: NSCoder) {
        //系统对init?(coder aDecoder: NSCoder)的默认实现是报一个致命错误
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        setupUI()
        
    }
    
    //设置基本UI
    private func setupUI()
    {
        setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), for: UIControlState.normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: UIControlState.selected)
        sizeToFit()
    }
    
    //重写setTitle 在标题后加上空格
    override func setTitle(_ title: String?, for state: UIControlState) {
        // ?? 用于判断前面的参数是否是nil 如果是nil返回后面的数据 如果不是nil那么后面的数据不赋值
        super.setTitle((title ?? "") + "  ", for: state)
    }

//    override func titleRect(forContentRect contentRect: CGRect) -> CGRect
//    {
//        return CGRect.zero
//    }
    
//    override func imageRect(forContentRect contentRect: CGRect) -> CGRect
//    {
//        return CGRect.zero
//    }

    //重写布局方法 将箭头和标题互换位置
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        //offsetBy 用于设置控件的偏移位
//        titleLabel?.frame = (titleLabel?.frame.offsetBy(dx: -imageView!.frame.width * 0.5, dy: 0))!
//        imageView?.frame = (imageView?.frame.offsetBy(dx: titleLabel!.frame.width * 0.5, dy: 0))!
        
        //Swift允许直接修改一个对象的结构体属性的成员
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.width
        
    }
    
}
