//
//  StatusViewModel.swift
//  LKWeiBo
//
//  Created by 888 on 2017/3/31.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject
{
    /// 模型对象
    var status: StatusModel
    
    init(status: StatusModel)
    {
        self.status = status
        
        // 处理头像
        iocn_url = URL(string: self.status.user?.profile_image_url ?? "")
        
        // 处理会员图标
        if (status.user?.mbrank)! >= 1 && (status.user?.mbrank)! <= 6
        {
            mbrankImage = UIImage(named: "common_icon_membership_level\(self.status.user!.mbrank)")
        }
        
        // 处理认证图片
        switch self.status.user?.verified_type ?? -1
        {
        case 0:
            verified_image = R.image.avatar_vip()
        case 2,3,5:
            verified_image = R.image.avatar_enterprise_vip()
        case 220:
            verified_image = R.image.avatar_grassroot()
        default:
            verified_image = nil
        }
        
        // 处理来源
        if let sourceStr: NSString = status.source as NSString?, sourceStr != ""
        {
            // 获取开始截取的位置
            let startIndex = sourceStr.range(of: ">").location + 1
            // 获取截取长度
            let length = sourceStr.range(of: "<", options: NSString.CompareOptions.backwards).location - startIndex
            // 截取字符串
            let rest = sourceStr.substring(with: NSMakeRange(startIndex, length))
            // 给来源赋值
            source_Text = "来自: \(rest)"
        }
        
        // 处理时间
        if let timeStr = status.created_at, status.created_at != ""
        {
            // 将服务器返回的时间格式化为 Date
            let createDate = Date().createDate(timeStr: timeStr, formatterStr: "EE MM dd HH:mm:ss Z yyyy")
            // 生成发布微博时间对应的字符串
            created_Time = createDate.descriptionStr()
        }
        
        // 处理配图 url
        // 从模型中取出配图数组
        if let picurls = (status.retweeted_status != nil) ? status.retweeted_status?.pic_urls : status.pic_urls
        {
            thumbnail_pic = [URL]()
            large_pic = [URL]()
            // 遍历配图数组下载图片
            for dict in picurls
            {
                // 取出图片的 url 字符串
                guard var urlStr = dict["thumbnail_pic"] as? String else
                {
                    continue
                }
                // 根据字符串创建 url
                let url = URL(string: urlStr)!
                thumbnail_pic?.append(url)
                
                // 处理大图
                urlStr = urlStr.replacingOccurrences(of: "thumbnail", with: "large")
                large_pic?.append(URL(string: urlStr)!)
                
            }
        }
        
        // 处理转发
        if let text = status.retweeted_status?.text
        {
            let name = status.retweeted_status?.user?.screen_name ?? ""
            forwardText = "@" + name + ": " + text
        }
        
    }
    
    /// 用户认证图片
    var verified_image: UIImage?
    
    /// 会员图片
    var mbrankImage: UIImage?
    
    /// 用户头像url地址
    var iocn_url: URL?
    
    /// 微博格式化之后的创建时间
    var created_Time: String = ""
    
    /// 微博格式化之后的来源
    var source_Text: String = ""
    
    /// 保存所有配图的 url
    var thumbnail_pic: [URL]?
    
    /// 保存所有配图大图的 url
    var large_pic: [URL]?
    
    /// 转发微博格式化之后的正文
    var forwardText: String?
}
