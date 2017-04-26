//
//  HomeTableViewCell.swift
//  LKWeiBo
//
//  Created by 888 on 2017/3/30.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {

    /// 配图视图
    @IBOutlet weak var pictureCollectionView: LKPictureView!
    /// 头像
    @IBOutlet weak var iconImageView: UIImageView!
    /// 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    /// 会员图标
    @IBOutlet weak var vipImageView: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 正文
    @IBOutlet weak var contentLabel: UILabel!
    /// 底部视图
    @IBOutlet weak var footerView: UIView!
    /// 转发正文
    @IBOutlet weak var forwardLabel: UILabel!
    
    /// 模型数据
    var statusViewModel: StatusViewModel?
    {
        didSet
        {
            // 设置头像
            iconImageView.sd_setImage(with: statusViewModel?.iocn_url)
            // 设置认证图标
            verifiedImageView.image = statusViewModel?.verified_image
            // 设置昵称
            nameLabel.text = statusViewModel?.status.user?.screen_name
            // 设置会员图标
            vipImageView.image = nil
            nameLabel.textColor = UIColor.black
            if let image = statusViewModel?.mbrankImage {
                vipImageView.image = image
                nameLabel.textColor = UIColor.purple
            }
            // 设置时间
            timeLabel.text = statusViewModel?.created_Time
            // 设置来源
            sourceLabel.text = statusViewModel?.source_Text
            // 设置正文
            contentLabel.text = statusViewModel?.status.text
            // 设置配图
            pictureCollectionView.statusViewModel = statusViewModel
            // 转发微博
            if let text = statusViewModel?.forwardText
            {
                forwardLabel.text = text
                // 设置转发正文最大宽度
                forwardLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 20
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置正文最大宽度
        contentLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 20
        
    }

    // MARK: - 外部控制方法
    func calculateRowHeight(viewModel: StatusViewModel) -> CGFloat
    {
        self.statusViewModel = viewModel
        self.layoutIfNeeded()
        return footerView.frame.maxY
    }
    
}




