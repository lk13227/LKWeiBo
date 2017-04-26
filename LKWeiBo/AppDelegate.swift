//
//  AppDelegate.swift
//  LKWeiBo
//
//  Created by Kai Liu on 17/3/2.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit
//import QorumLogs

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //开启自定义log
//        QorumLogs.enabled = true
        //设置打印的最低级别
//        QorumLogs.minimumLogLevelShown = 1
        //指定哪一个类可以打印log
//        QorumLogs.onlyShowThisFile(ViewController)

        
        //创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        // 注册监听
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.chageRootViewController(notice:)), name: NSNotification.Name(rawValue: LKSwitchRootViewController), object: nil)
        //设置根控制器
        window?.rootViewController = defaultViewController()
        //显示window
        window?.makeKeyAndVisible()
 
        
        // 设置导航条按钮颜色
        UINavigationBar.appearance().tintColor = UIColor.orange
        // 设置 tabbar 的按钮颜色
        UITabBar.appearance().tintColor = UIColor.orange
        
        LKLog(message: isNewVersion())
        
        return true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension AppDelegate
{
    /// 切换根控制器
    func chageRootViewController(notice: NSNotification)
    {
        if notice.object as! Bool
        {
            // 切换到首页
            //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
            window?.rootViewController = R.storyboard.main.instantiateInitialViewController()!
        } else {
            // 切换到欢迎界面
            //let vc = UIStoryboard(name: "Welcome", bundle: nil).instantiateInitialViewController()!
            window?.rootViewController = R.storyboard.welcome.instantiateInitialViewController()
        }
    }
    
    /// 返回默认界面
    func defaultViewController() -> UIViewController
    {
        
        // 判断是否登录
        if UserAccount.isLogin()
        {
            if isNewVersion() {
                //let vc = UIStoryboard(name: "Newfeature", bundle: nil).instantiateInitialViewController()!
                return R.storyboard.newfeature.instantiateInitialViewController()!
            } else {
                //let vc = UIStoryboard(name: "Welcome", bundle: nil).instantiateInitialViewController()!
                return R.storyboard.welcome.instantiateInitialViewController()!
            }
        }
        
        // 没有登录界面
        //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        return R.storyboard.main.instantiateInitialViewController()!
        
    }
    
    /// 判断是否有新版本
    func isNewVersion() -> Bool
    {
        // 加载 info.plist获取当前的版本号
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        // 获取以前的版本号
        let sanboxVersion = UserDefaults.standard.object(forKey: "currentVersion") as? String ?? "0.0"
        // 比较版本号
        if currentVersion.compare(sanboxVersion) == ComparisonResult.orderedDescending
        {
            LKLog(message: "有新版本")
            // 储存新版本
            let defaults = UserDefaults.standard
            defaults.setValue(currentVersion, forKey: "currentVersion")
            defaults.synchronize()
            
            return true
        }
        
        return false
    }
}


func LKLog<T>(fileName: String = #file, methodName: String = #function, lineNumber: Int = #line, message: T)
{
//    print("\((fileName as NSString).pathComponents.last!).\(methodName).[\(lineNumber)] : \(message)")
    #if DEBUG
    print("\((fileName as NSString).pathComponents.last!).[\(lineNumber)] : \(message)")
    #endif
}

