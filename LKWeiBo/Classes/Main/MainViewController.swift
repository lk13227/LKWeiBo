//
//  MainViewController.swift
//  LKWeiBo
//
//  Created by Kai Liu on 17/3/3.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBar.addSubview(composeButton)
        //保存按钮的尺寸
        let rect = composeButton.frame.size
        //计算宽度
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        //设置按钮的位置
        composeButton.frame = CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
    }
    
    
    /// 加号按钮点击
    func compseBtnClick(btn: UIButton)
    {
        let vc = UIStoryboard(name: "Compose", bundle: nil).instantiateInitialViewController()!
        let nav = UINavigationController.init(rootViewController: vc)
        present(nav, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - 加号懒加载
    lazy var composeButton: UIButton = {
        () -> UIButton
        in
        
        let btn = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        
        btn.addTarget(self, action: #selector(MainViewController.compseBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
 
}
