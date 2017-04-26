//
//  NetworkTools.swift
//  LKWeiBo
//
//  Created by 888 on 2017/3/21.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager
{
    // Swift 中推荐此写法
    static let shareInstance: NetworkTools = {
        
        let baseURL = NSURL(string: "https://api.weibo.com/")
        let instance = NetworkTools(baseURL: baseURL! as URL, sessionConfiguration: URLSessionConfiguration.default)
        instance.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set
        return instance
    }()

    // MARK: - 外部控制方法
    /// 获取微博数据接口
    func loadStatuses(since_id: String?, max_id: String?, finished: @escaping(_ array: [[String: AnyObject]]?, _ error: NSError?)->())
    {
        // 警示
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后(获取access_token),才能获取微博数据")
        
        // 准备路径
        let path = "2/statuses/home_timeline.json"
        // 准备参数
        let temp = (max_id != "0") ? "\(Int(max_id!)! - 1)" : max_id
        let parameters = ["access_token": UserAccount.loadUserAccount()!.access_token, "since_id": since_id, "max_id": temp]
        // 发送请求
        get(path, parameters: parameters, progress: nil, success: { (task, objc) in
            
            // 返回数据给调用者
            guard let arr = (objc as! [String: AnyObject])["statuses"] as? [[String: AnyObject]] else {
                finished(nil, NSError(domain: "cn.ez360", code: 1000, userInfo: ["message": "没有数据"]))
                return
            }
            
            finished(arr, nil)
            
        }) { (task, error) in
            finished(nil, error as NSError?)
        }
        
    }
    
    /// 发一条微博接口
    func sendStatus(status: String, finished: @escaping(_ objc: Any?, _ error: Error?)->() )
    {
        
        // 准备路径
        let path = "2/statuses/update.json"
        // 准备参数
        let parameters = ["access_token": UserAccount.loadUserAccount()!.access_token, "status": status]
        // 发送请求
        post(path, parameters: parameters, progress: nil, success: { (task, objc) in
            
            finished(objc, nil)
            
        }) { (task, error) in
            finished(nil, error)
        }
        
    }
}
