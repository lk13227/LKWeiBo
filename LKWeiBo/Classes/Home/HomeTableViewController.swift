//
//  HomeTableViewController.swift
//  LKWeiBo
//
//  Created by Kai Liu on 17/3/3.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class HomeTableViewController: BaseTableViewController {
    
    /// 保存所有微博数据
    var statusListModel: StatusListModel = StatusListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 判断用户是否登录
        if !isLogin
        {
            // 设置访客视图
            visitorView?.setupVisitorInfo(imageName: nil, title: "严于律己，宽以待人")
            return
        }
        
        // 初始化导航条
        setupNav()
        
        // 注册标题按钮通知
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.titleChange), name: Notification.Name(rawValue: LKPresentaionManagerDidPresented), object: animatorManager)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.titleChange), name: Notification.Name(rawValue: LKPresentaionManagerDidDismissed), object: animatorManager)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.showBrowser(notice:)), name: Notification.Name(rawValue: LKShowPhotoBrowserController), object: nil)
        
        // 获取微博数据
        loadData()
        
        // 删除分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // 下拉下拉刷新
        refreshControl = LKRefreshControl()
        refreshControl?.addTarget(self, action: #selector(HomeTableViewController.loadData), for: UIControlEvents.valueChanged)
        refreshControl?.beginRefreshing()
        
        // 在导航条上添加提醒文字
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        
    }
    
    deinit {
        // 销毁通知
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 初始化导航条
    private func setupNav()
    {
        // 添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
        
        // 添加标题按钮
        navigationItem.titleView = titleButton
    }
    
    // MARK: - 内部控制方法
    /// 标题按钮点击
    @objc private func titleBtnClick(btn: TitleButton)
    {
        //修改按钮箭头状态
        //btn.isSelected = !btn.isSelected
        
        //显示菜单
        //let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = R.storyboard.popover.instantiateInitialViewController() else
        {
            return
        }
        
        //自定义转场动画
        menuView.transitioningDelegate = animatorManager
        menuView.modalPresentationStyle = UIModalPresentationStyle.custom
        
        present(menuView, animated: true, completion: nil)
    }
    
    /// 左按钮点击
    @objc private func leftBtnClick()
    {
        
    }
    
    /// 右按钮点击
    @objc private func rightBtnClick()
    {
        // 二维码
        let vc = R.storyboard.qRCode.instantiateInitialViewController()!
        
        present(vc, animated: true, completion: nil)
    }
    
    /// 标题按钮状态改变的通知接收后调用的方法
    @objc private func titleChange()
    {
        titleButton.isSelected = !titleButton.isSelected
    }
    
    /// 获取微博数据
    func loadData()
    {
        
        statusListModel.loadData(lastStatus: lastStatus) { (models, error) in
            
            // 安全校验
            if error != nil
            {
                SVProgressHUD.showError(withStatus: "获取微博数据失败")
                return
            }
            
            // 停止刷新状态
            self.refreshControl?.endRefreshing()
            
            // 显示刷新提醒
            self.showRefreshStatus(count: models!.count)
            
            // 刷新表格
            self.tableView.reloadData()
            
        }
        
    }
    
    /// 显示刷新提醒
    func showRefreshStatus(count: Int)
    {
        // 设置提醒文本
        tipLabel.text = (count == 0) ? "没有更多数据" : "刷新到\(count)条微博"
        tipLabel.isHidden = false
        // 执行动画
        UIView.animate(withDuration: 1.0, animations: { 
            self.tipLabel.transform = CGAffineTransform.init(translationX: 0, y: 44)
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 2.0, options: UIViewAnimationOptions(rawValue: 0), animations: { 
                self.tipLabel.transform = CGAffineTransform.identity
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
        }
    }
    
    /// 弹出图片浏览器
    func showBrowser(notice: Notification)
    {
        // 注意  从通知或者网络获取的数据 一定要安全校验
        guard let pictures = notice.userInfo!["large_pic"] as? [URL] else
        {
            SVProgressHUD.showError(withStatus: "没有图片")
            return
        }
        guard let index = notice.userInfo!["indexPath"] as? IndexPath else
        {
            SVProgressHUD.showError(withStatus: "没有索引")
            return
        }
        
        // 弹出图片浏览器
        let vc = BrowserViewController(large_pic: pictures, indexPath: index)
        
        present(vc, animated: true, completion: nil)
        
    }
    
    
    // MARK: - 懒加载
    private lazy var animatorManager: LKPresentaionManager = {
        let manager = LKPresentaionManager()
        manager.presentFrame = CGRect(x: 100, y: 55, width: 200, height: 300)
        return manager
    }()

    /// 标题按钮
    private lazy var titleButton: TitleButton = {
        let btn = TitleButton()
        let title = UserAccount.loadUserAccount()?.screen_name
        btn.setTitle(title, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    /// 缓存行高
    var rowHeightCaches = [String: CGFloat]()
    
    /// 刷新提醒视图
    private lazy var tipLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = UIColor.orange
        lb.text = "没有更多数据"
        lb.textAlignment = NSTextAlignment.center
        lb.textColor = UIColor.white
        let width = UIScreen.main.bounds.size.width
        lb.frame = CGRect(x: 0, y: 0, width: width, height: 44)
        lb.isHidden = true
        return lb
    }()
    
    /// 最后一条微博标记
    lazy var lastStatus = false
    
}

extension HomeTableViewController
{
    /// 行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statusListModel.statuses?.count ?? 0
    }
    
    /// cell 样式
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 获取对应的模型
        let viewModel = statusListModel.statuses![indexPath.row]
        // 获取显示 cell 的标识
        let identifier = (viewModel.status.retweeted_status != nil) ? "forwardCell" : "homeCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HomeTableViewCell
        
        cell.statusViewModel = viewModel
        
        // 判断是否是最后一条微博
        if indexPath.row == (statusListModel.statuses!.count - 1)
        {
            self.lastStatus = true
            loadData()
        }
        
        return cell
    }
    
    // 行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 从缓存中获取行高
        let viewModel = statusListModel.statuses![indexPath.row]
        // 获取显示 cell 的标识
        let identifier = (viewModel.status.retweeted_status != nil) ? "forwardCell" : "homeCell"
        
        guard let height = rowHeightCaches[viewModel.status.idstr ?? "-1"] else
        {
            // 获取当前行对应的 cell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! HomeTableViewCell
            // 缓存行高
            let temp = cell.calculateRowHeight(viewModel: viewModel)
            rowHeightCaches[viewModel.status.idstr ?? "-1"] = temp
            // 返回 cell 的高度
            return temp
        }
        
        // 缓存中有就直接返回缓存中的高度
        return height
    }
    
    /// 内存警告
    override func didReceiveMemoryWarning() {
        // 释放缓存数据
        rowHeightCaches.removeAll()
    }
    
}

