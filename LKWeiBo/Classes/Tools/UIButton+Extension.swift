//
//  UIButton+Extension.swift
//  LKWeiBo
//
//  Created by Kai Liu on 17/3/4.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

extension UIButton
{
    
    convenience init(imageName: String?, backgroundImageName: String?)
    {
        
        self.init()
        
        if let name = imageName
        {
            setImage(UIImage(named: name), for: UIControlState.normal)
            setImage(UIImage(named: name + "_highlighted"), for: UIControlState.highlighted)
        }
        
        if let backgroundName = backgroundImageName
        {
            setBackgroundImage(UIImage(named: backgroundName), for: UIControlState.normal)
            setBackgroundImage(UIImage(named: backgroundName + "_highlighted"), for: UIControlState.highlighted)
        }
        
        sizeToFit()
        
    }
    
}
