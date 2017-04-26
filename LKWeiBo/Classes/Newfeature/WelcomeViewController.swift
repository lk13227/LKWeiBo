//
//  WelcomeViewController.swift
//  LKWeiBo
//
//  Created by 888 on 2017/3/24.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    /// 头像图片
    @IBOutlet weak var iconImageView: UIImageView!
    /// 头像底部约束
    @IBOutlet weak var iconBottomCons: NSLayoutConstraint!
    /// 标题 label
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 使头像变成圆
        iconImageView.layer.cornerRadius = 45
        //
        iconImageView.layer.masksToBounds = true
        
        // 设置头像
        assert(UserAccount.loadUserAccount() != nil, "必须授权登录以后才会显示欢迎界面")
        guard let url = NSURL(string: UserAccount.loadUserAccount()!.avatar_hd!) else
        {
            return
        }
        iconImageView.sd_setImage(with: url as URL)
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        // 让头像执行动画
        iconBottomCons.constant = UIScreen.main.bounds.height - iconBottomCons.constant
        
        UIView.animate(withDuration: 2.0, animations: { 
            
            self.view.layoutIfNeeded()
            
        }) { (bool) in
            
            UIView.animate(withDuration: 2.0, animations: { 
                // 使标题逐渐变色
                self.titleLabel.alpha = 1.0
            }, completion: { (_) in
                // 跳转到主界面
                /**
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
                UIApplication.shared.keyWindow?.rootViewController = vc
                */
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LKSwitchRootViewController), object: true)
            })
            
        }
        
    }


}
