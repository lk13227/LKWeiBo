//
//  UIBarButtonItem+Extension.swift
//  LKWeiBo
//
//  Created by Kai Liu on 17/3/7.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

extension UIBarButtonItem
{
    convenience init(imageName: String, target: AnyObject?, action: Selector)
    {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControlState.normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        btn.sizeToFit()
        self.init(customView: btn)
    }
}
