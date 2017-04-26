//
//  StatusListModel.swift
//  LKWeiBo
//
//  Created by 888 on 2017/4/12.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit
import SDWebImage

class StatusListModel: UIView {

    /// 保存所有微博数据
    var statuses: [StatusViewModel]?

    
    /// 获取微博数据
    func loadData(lastStatus: Bool, finished: @escaping( _ models: [StatusViewModel]?, _ error: NSError?)->())
    {
        
        // 获取微博 id
        var sinde_id = statuses?.first?.status.idstr ?? "0"
        var max_id = "0"
        if lastStatus
        {
            sinde_id = "0"
            max_id = statuses?.last?.status.idstr ?? "0"
            
        }
        
        // 发送请求
        NetworkTools.shareInstance.loadStatuses(since_id: sinde_id, max_id: max_id) { (arr, error) in
            
            // 安全校验
            if error != nil
            {
                // 报错 没有获取数据
                finished(nil, error)
                return
            }
            
            // 将字典数据转换为模型数组
            var models = [StatusViewModel]()
            for dict in arr!
            {
                let status = StatusModel(dict: dict)
                let viewModel = StatusViewModel(status: status)
                models.append(viewModel)
            }
            
            // 处理微博数据
            if sinde_id != "0"
            {
                self.statuses = models + self.statuses!
            } else if max_id != "0" {
                self.statuses = self.statuses! + models
            } else {
                self.statuses = models
            }
            
            // 缓存微博所有配图
            self.cachesImages(viewModels: models, finished: finished)
            
        }
    }
    
    /// 缓存微博配图
    func cachesImages(viewModels: [StatusViewModel], finished: @escaping( _ models: [StatusViewModel]?, _ error: NSError?)->())
    {
        
        // 创建一个组
        let group = DispatchGroup()
        
        for viewModel in viewModels
        {
            
            // 从模型中取出配图URL数组
            guard let picurls = viewModel.thumbnail_pic else
            {
                // 如果当前微博没有配图就跳过,继续下载下一个模型的
                continue
            }
            
            // 遍历配图数组下载图片
            for url in picurls
            {
                
                // 将当前的下载操作添加到组中
                group.enter()
                // 下载图片
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: SDWebImageDownloaderOptions(rawValue: 0), progress: nil, completed: { (image, data, error, _) in
                    
                    // 将当前下载操作从组中移除
                    group.leave()
                    
                })
                
            }
            
        }
        
        // 监听下载完成操作
        group.notify(queue: DispatchQueue.main) {
            finished(viewModels, nil)
        }
        
    }
    
}
