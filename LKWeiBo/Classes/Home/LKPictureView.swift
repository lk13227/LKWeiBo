//
//  LKPcitureView.swift
//  LKWeiBo
//
//  Created by 888 on 2017/4/12.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit
import SDWebImage

class LKPictureView: UICollectionView {

    /// 配图布局对象
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    /// 配图高度约束
    @IBOutlet weak var pictureCollectionViewHeightCons: NSLayoutConstraint!
    /// 配图宽度约束
    @IBOutlet weak var pictureCollectionViewWidthCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        self.dataSource = self
    }
    
    /// 模型数据
    var statusViewModel: StatusViewModel?
    {
        didSet
        {
            // 更新配图
            reloadData()
            // 更新配图的尺寸
            let (itemSize, clvSize) = calculateSize()
            if itemSize != CGSize.zero
            {
                flowLayout.itemSize = itemSize
                //flowLayout.itemSize = CGSize(width: 90, height: 90)
            }
            pictureCollectionViewHeightCons.constant = clvSize.height
            pictureCollectionViewWidthCons.constant = clvSize.width
        }
        
    }
    
    // MARK: - 内部控制方法
    /// 计算 cell 和 collectionview 的尺寸
    func calculateSize() -> (CGSize, CGSize)
    {
        
        // 配图个数
        let count = statusViewModel?.thumbnail_pic?.count ?? 0
        
        // 没有配图
        if count == 0
        {
            return (CGSize.zero, CGSize.zero)
        }
        
        // 一张配图
        if count == 1
        {
            let key = statusViewModel?.thumbnail_pic?.first?.absoluteString
            // 从缓存中获取已经下载好的图片, key 就是图片的 url
            if let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: key)
            {
                return (image.size, image.size)
            } else {
                return (CGSize.zero, CGSize.zero)
            }
            
        }
        
        // 图片的宽
        let imageWidth: CGFloat = 90
        // 图片的高
        let imageHeight: CGFloat = 90
        // 图片之间的间隙
        let imageMargin: CGFloat = 10
        
        // 四张配图
        if count == 4
        {
            // 列
            let col = 2
            // 行
            let row = col
            // collectionview 宽
            let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
            // collectionview 高
            let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
            
            return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
        }
        
        // 其他配图
        // 列
        let col = 3
        // 行
        let row = (count - 1) / 3 + 1
        // collectionview 宽
        let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
        // collectionview 高
        let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
        
        return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
    }

    
}

extension LKPictureView: UICollectionViewDataSource, UICollectionViewDelegate
{
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 获取点击图片的 url
        let url = statusViewModel?.large_pic?[indexPath.item]
        // 取出被点击的 cell
        let cell = collectionView.cellForItem(at: indexPath) as! HomePictureCell
        
        // 下载图片 显示进度
        SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions(rawValue: 0), progress: { (curren, total, _) in
            
            cell.customIconImageView.progress = CGFloat(curren) / CGFloat(total)
            
        }) { (_, _, error, _, _, _) in
            
            // 注册通知 用来打开图片浏览区
            NotificationCenter.default.post(name: Notification.Name(rawValue: LKShowPhotoBrowserController), object: self, userInfo: ["large_pic": self.statusViewModel?.large_pic! ?? [URL](), "indexPath": indexPath])
            
        }
        
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statusViewModel?.thumbnail_pic?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! HomePictureCell
        
        cell.url = statusViewModel?.thumbnail_pic![indexPath.item]
        
        return cell
    }
}

/// 自定义 cell
class HomePictureCell: UICollectionViewCell
{
    // 图片
    @IBOutlet weak var customIconImageView: LKProgressImageView!
    // gif 标识
    @IBOutlet weak var gifImageView: UIImageView!
    
    // 给图片赋值
    var url: URL?
    {
        didSet
        {
            // 设置图片
            customIconImageView.sd_setImage(with: url)
            // 控制 gif 标识的隐藏
            if let flag = url?.absoluteString.localizedLowercase.hasSuffix("gif")
            {
                gifImageView.isHidden = !flag
            }
        }
    }
    
}
