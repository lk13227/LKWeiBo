//
//  StatusModel.swift
//  LKWeiBo
//
//  Created by 888 on 2017/3/29.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

class StatusModel: NSObject
{
    /// 微博创建时间
    var created_at: String?

    /// 字符串型的微博ID
    var idstr: String?
    
    /// 微博来源
    var source: String?

    /// 微博信息内容
    var text: String?
    
    /// 微博作者的用户信息
    var user: UserModel?
    
    /// 配图数组
    var pic_urls: [[String: AnyObject]]?

    /// 转发微博
    var retweeted_status: StatusModel?
    
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeys(dict)
    }
    
    /// KVC 的 setValuesForKeys 方法内部会调用该方法
    override func setValue(_ value: Any?, forKey key: String) {
        // 拦截 user 赋值操作
        if key == "user"
        {
            user = UserModel(dict: value as! [String : AnyObject])
            return
        }
        
        // 拦截 retweeted_status 赋值操作
        if key == "retweeted_status"
        {
            retweeted_status = StatusModel(dict: value as! [String : AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String
        {
        let property = ["created_at", "idstr", "source", "text"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }
    
}
