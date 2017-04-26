//
//  UserModel.swift
//  LKWeiBo
//
//  Created by 888 on 2017/3/30.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

class UserModel: NSObject
{
    /// 字符串型的用户UID
    var idstr: String?
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像字符串地址（中图），50×50像素
    var profile_image_url: String?
    
    /// 认证类型 -1: 没有认证 0: 个人认证用户 2,3,5: 企业认证 220: 达人
    var verified_type: Int = -1
    
    /// 会员等级
    var mbrank: Int = -1
    
    
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String
    {
        let property = ["idstr", "screen_name", "profile_image_url", "verified_type", "mbrank", "iocn_url"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }
    
}
