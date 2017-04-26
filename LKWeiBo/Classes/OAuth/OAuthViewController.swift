//
//  OAuthViewController.swift
//  LKWeiBo
//
//  Created by 888 on 2017/3/16.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    // 网页容器
    @IBOutlet weak var customWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 定义字符串保存登录界面 url
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_Uri)"
        // 创建 url
        guard let url = URL(string: urlStr) else
        {
            return
        }
        // 创建 request
        let request = NSURLRequest(url: url)
        
        // 加载登录界面
        customWebView.loadRequest(request as URLRequest)
        
    }

    // MARK: - 内部控制方法
    /// 返回按钮
    @IBAction func backBtnClick()
    {
        self.dismiss(animated: true, completion: nil)
    }
    /// 填充按钮
    @IBAction func autoBtnClick(_ sender: UIBarButtonItem)
    {
        let jsStr = "document.getElementById('userId').value = '18910711571'"
        let passwordStr = "document.getElementById('passwd').value = 'LiuKai19960822'"
        customWebView.stringByEvaluatingJavaScript(from: jsStr)
        customWebView.stringByEvaluatingJavaScript(from: passwordStr)
    }
}

extension OAuthViewController: UIWebViewDelegate
{
    /// 该方法每次请求都会调用
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        // 判断当前是否是授权回调页面
        guard let urlStr = request.url?.absoluteString else {
            return false
        }
        if !urlStr.hasPrefix(WB_Redirect_Uri) { // 不是授权回调页就显示
            return true
        }
        
        // 判断授权回调中是否包含 code
        let key = "code="
        guard let str = request.url?.query else {
            return false
        }
        if str.hasPrefix(key)
        {
            // 授权成功 获取 code 的内容
            let code = str.substring(from: key.endIndex)
            loadAccessToken(codeStr: code)
            
            return false
        }
        
        // 授权失败
        return false
    }
    
    /// 利用 RequestToken 换取 AccessToken
    func loadAccessToken(codeStr: String?)
    {
        
        guard let code = codeStr else {
            return
        }
        
        let path = "oauth2/access_token"
        
        let parameters = ["client_id": WB_App_Key, "client_secret": WB_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri": WB_Redirect_Uri]
        
        NetworkTools.shareInstance.post(path, parameters: parameters, progress: nil, success: { (take: URLSessionDataTask, objc: Any?) in
            
            // 将授权信息转换为模型
            let account = UserAccount(dict: objc as! [String : AnyObject])
            
            // 获取用户信息
            account.loadUserInfo(finished: { (account, error) in
                // 保存用户信息
                account?.saveAccount()
                // 跳转到欢迎界面
                /**
                let vc = UIStoryboard(name: "Welcome", bundle: nil).instantiateInitialViewController()!
                UIApplication.shared.keyWindow?.rootViewController = vc
                */
                
                // 发送通知打开首页
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LKSwitchRootViewController), object: false)
                
                // 关闭界面
                self.backBtnClick()
                
            })
            
        }) { (take: URLSessionDataTask?,error: Error) in
            LKLog(message: error)
        }
        
    }
    
    /// 网页开始加载
    func webViewDidStartLoad(_ webView: UIWebView) {
        // 显示提醒
        SVProgressHUD.showInfo(withStatus: "正在加载..")
    }
    /// 网页加载完毕
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // 关闭提醒
        SVProgressHUD.dismiss()
    }
}









