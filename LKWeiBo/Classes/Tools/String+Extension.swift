//
//  String+Extension.swift
//  LKWeiBo
//
//  Created by 888 on 2017/3/23.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import Foundation

extension String
{
    /// 快速生成缓存路径
    func cachesDir() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        // 生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = path! + "/" + name
        LKLog(message: filePath)
        return filePath
    }
    /// 快速生成文档路径
    func doctDir() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        // 生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = path! + "/" + name
        
        return filePath
    }
    /// 快速生成临时路径
    func tmpDir() -> String
    {
        let path = NSTemporaryDirectory()
        // 生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = path + name
        
        return filePath
    }
    
}
