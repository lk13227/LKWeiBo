//
//  DiscoverTableViewController.swift
//  LKWeiBo
//
//  Created by Kai Liu on 17/3/3.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin
        {
            visitorView?.setupVisitorInfo(imageName: "visitordiscover_image_message", title: "严于律己宽以待人")
            return
        }
        
    }

    
}
