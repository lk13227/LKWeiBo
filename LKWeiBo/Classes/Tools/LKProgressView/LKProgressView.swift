//
//  LKProgressView.swift
//  ProgressView
//
//  Created by 888 on 2017/4/14.
//  Copyright © 2017年 天高云展. All rights reserved.
//

import UIKit

class LKProgressView: UIView {

    /// 记录当前进度
    var progress: CGFloat = 0.0
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        // 判断是否需要继续绘制
        if progress >= 1.0
        {
            return
        }
        
        // 画圆准备数据
        let height = rect.height * 0.5
        let width = rect.width * 0.5
        let center = CGPoint(x: width, y: height)
        let radius = min(height, width)
        let start = -CGFloat(Double.pi / 2)
        let end = 2 * CGFloat(Double.pi) * progress + start
        
        // 绘制圆的路径
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        // 连接圆心
        path.addLine(to: center)
        // 关闭路径
        path.close()
        // 设置圆的颜色
        UIColor(white: 0.9, alpha: 0.5).setFill()
        // 开始绘制
        path.fill()
    }

}
