//
//  ProfileTableViewController.swift
//  LKWeiBo
//
//  Created by Kai Liu on 17/3/3.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin
        {
            visitorView?.setupVisitorInfo(imageName: "visitordiscover_image_profile", title: "严于律己宽以待人")
        }
        
    }

    
}
