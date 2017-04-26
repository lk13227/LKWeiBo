//
//  UserAccount.swift
//  LKWeiBo
//
//  Created by 888 on 2017/3/22.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding {
    /// 令牌
    var access_token: String?
    /// 从授权后,多少秒后过期
    var expires_in: Int = 0
        {
            didSet{
                // 生成正在过期的时间
                expires_Date = NSDate(timeIntervalSinceNow: TimeInterval(expires_in))
        }
    }
    /// 过期时间
    var expires_Date: NSDate?
    /// 用户ID
    var uid: String?
    /// 用户头像地址
    var avatar_hd: String?
    /// screen_name
    var screen_name: String?
    
    // MARK: - 内部方法
    init(dict: [String: AnyObject])
    {
        super.init()
        self.setValuesForKeys(dict)
    }
    
    override var description: String
    {
        // 将模型转换为字典
        let property = ["access_token", "expires_in", "uid", "expires_Date"]
        let dict = dictionaryWithValues(forKeys: property)
        // 将字典转换为字符串
        return "\(dict)"
    }
    
    // kvc 找不到值得时候会调用
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    // MARK: - 外部控制方法
    /// 归档模型
    func saveAccount() -> Bool
    {
        // 归档对象
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
        
    }
    
    /// 定义属性保存授权模型
    static var userAccount: UserAccount?
    //static let filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! + "/useraccount.plist"
    static let filePath: String = "useraccount.plist".cachesDir()
    
    /// 解归档模型
    class func loadUserAccount() -> UserAccount?
    {
        // 判断是否加载过
        if userAccount != nil
        {
            return userAccount
        }
        
        // 读取解归档文件
        guard let account = NSKeyedUnarchiver.unarchiveObject(withFile: UserAccount.filePath) as? UserAccount else
        {
            LKLog(message: "还没授权过")
            return nil
        }
        
        // 校验 token 是否过期
        guard let date = account.expires_Date, date.compare(NSDate() as Date) != ComparisonResult.orderedAscending else
        {
            LKLog(message: "token 过期")
            return nil
        }
        
        userAccount = account
        return account
    }
    
    /// 获取用户信息
    func loadUserInfo(finished: @escaping (_ account: UserAccount?, _ error: NSError?) ->())
    {
        // 断言
        assert(access_token != nil, "使用该方法必须先授权")
        
        let path = "2/users/show.json"
        
        let parameters = ["access_token": access_token!, "uid": uid!]
        
        NetworkTools.shareInstance.get(path, parameters: parameters, progress: nil, success: { (task, objc) in
            
            let dict = objc as! [String: AnyObject]
            
            self.avatar_hd = dict["avatar_hd"] as? String
            self.screen_name = dict["screen_name"] as? String
            
            finished(self, nil)
            
        }) { (task, error) in
            finished(nil, error as NSError?)
            LKLog(message: error)
        }
        
    }
    
    /// 判断用户是否登录
    class func isLogin() -> Bool
    {
        return UserAccount.loadUserAccount() != nil
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(expires_Date, forKey: "expires_Date")
        aCoder.encode(avatar_hd, forKey: "avatar_hd")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    required init?(coder aDecoder: NSCoder)
    {
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        self.uid = aDecoder.decodeObject(forKey: "uid") as? String
        self.expires_in = aDecoder.decodeInteger(forKey: "expires_in")
        self.expires_Date = aDecoder.decodeObject(forKey: "expires_Date") as? NSDate
        self.avatar_hd = aDecoder.decodeObject(forKey: "avatar_hd") as? String
        self.screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
}

