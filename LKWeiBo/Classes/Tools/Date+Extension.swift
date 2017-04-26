//
//  NSDate+Extension.swift
//  LKWeiBo
//
//  Created by 888 on 2017/3/31.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

extension Date
{
    /// 根据一个字符串创建一个 NSDate
    func createDate(timeStr: String, formatterStr: String) -> Date
    {
        // 将服务器返回的时间格式化为 NSDate
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        formatter.locale = Locale(identifier: "en")
        let createDate = formatter.date(from: timeStr)!
        
        return createDate
    }
    
    /// 生成当前时间对应的字符串
    func descriptionStr() -> String
    {
        // 创建时间格式化对象
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        
        // 创建日历类
        let calendar = Calendar.current
        
        // 定义时间格式变量
        var formatterStr = "HH:mm"
        
        // 判断日期
        if calendar.isDateInToday(self)
        {
            // 比较两个时间的差值
            let interval = Int(Date().timeIntervalSince(self))
            
            if interval < 60 {
                return "刚刚"
            } else if interval < 60 * 60 {
                return "\(interval / 60)分钟前"
            } else if interval < 60 * 60 * 24 {
                return "\(interval / (60 * 60))小时前"
            }
        } else if calendar.isDateInYesterday(self) {
            // 昨天
            formatterStr = "昨天 " + formatterStr
        } else {
            // 该方法可以获得两个时间之间的差值
            let comps = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
            if comps.year! >= 1 {
                // 更早
                formatterStr = "yyyy-MM-dd " + formatterStr
            } else {
                // 一年内
                formatterStr = "MM-dd " + formatterStr
            }
        }
        
        formatter.dateFormat = formatterStr
        return formatter.string(from: self)
        
    }
}
