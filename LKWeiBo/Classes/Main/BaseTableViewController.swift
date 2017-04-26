//
//  BaseTableViewController.swift
//  LKWeiBo
//
//  Created by Kai Liu on 17/3/6.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    // 记录登录状态
    var isLogin = UserAccount.isLogin()
    
    // 访客视图
    var visitorView: VisitorView?
    
    
    override func loadView() {
        //判断用户是否登录
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    // MARK: - 内部控制方法
    func setupVisitorView()
    { 
        //创建访客视图
        visitorView = VisitorView.visitorView()
        view = visitorView
        //设置代理
        //visitorView?.delegate = self
        visitorView?.loginButton.addTarget(self, action: #selector(BaseTableViewController.loginBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        visitorView?.registerButton.addTarget(self, action: #selector(BaseTableViewController.registerBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        
        //添加导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseTableViewController.loginBtnClick(btn:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseTableViewController.registerBtnClick(btn:)))
    }
    
    /// 登录
    @objc private func loginBtnClick(btn: UIButton)
    {
        let vc = R.storyboard.oAuth.instantiateInitialViewController()!
        
        present(vc, animated: true, completion: nil)
    }
    
    /// 注册
    @objc private func registerBtnClick(btn: UIButton)
    {
        
    }
    
}

/**
// MARK: - 访客页面登录与注册按钮的代理方法
extension BaseTableViewController: VisitorViewDelegate
{
    func visitorViewDidClickLoginBtn(visitor: VisitorView)
    {
        
    }
    
    func visitorViewDidClickRegisterBtn(visitor: VisitorView)
    {
        
    }
}
 */
