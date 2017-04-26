//
//  LKBrowserCell.swift
//  LKWeiBo
//
//  Created by LiuKai on 2017/4/14.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit
import SDWebImage

class LKBrowserCell: UICollectionViewCell, UIScrollViewDelegate
{
    
    var imageURL: URL?
    {
        didSet
        {
            // 显示提醒
            indicatorView.startAnimating()
            
            // 重置容器的所有数据
            resetView()
            
            // 设置图片
            imageView.sd_setImage(with: imageURL, placeholderImage: nil, options: SDWebImageOptions.highPriority) { (image, error, _, _) in
                
                // 关闭提醒
                self.indicatorView.stopAnimating()
                
                // 获取屏幕的宽高
                let width = UIScreen.main.bounds.size.width
                let height = UIScreen.main.bounds.size.height
                // 计算当前图片的宽高比
                let scale = (image?.size.height)! / (image?.size.width)!
                // 利用宽高比乘以屏幕宽度，等比缩放图片
                let imageHeight = scale * width
                // 设置图片的 frame
                self.imageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: imageHeight))
                // 判断图片是否为长图
                if imageHeight < height
                {
                    // 短图
                    // 计算内边距
                    let offsetY = (height - imageHeight) * 0.5
                    // 设置内边距
                    self.scrollView.contentInset = UIEdgeInsets(top: offsetY, left: 0, bottom: offsetY, right: 0)
                } else {
                    // 长图
                    self.scrollView.contentSize = CGSize(width: width, height: imageHeight)
                }
                
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 内部控制方法
    private func setupUI()
    {
        // 添加子控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        contentView.addSubview(indicatorView)
        // 布局子控件
        scrollView.frame = UIScreen.main.bounds
        scrollView.backgroundColor = UIColor.darkGray
        indicatorView.center = contentView.center
    }
    
    private func resetView()
    {
        scrollView.contentSize = CGSize.zero
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        
        imageView.transform = CGAffineTransform.identity
    }
    
    // MARK: - 懒加载
    private lazy var scrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.maximumZoomScale = 4.0
        sc.minimumZoomScale = 0.5
        sc.delegate = self
        return sc
    }()
    lazy var imageView: UIImageView = UIImageView()
    /// 提示视图
    private lazy var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    // MARK: - UIScrollViewDelegate
    // 需要缩放的 view
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    // 缩放的过程中不断调用
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // 获取屏幕的宽高
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        // 计算上下内边距
        var offsetY = (height - imageView.frame.height) * 0.5
        // 计算左右内边距
        var offsetX = (width - imageView.frame.width) * 0.5
        
        offsetY = (offsetY > 0) ? offsetY : 0
        offsetX = (offsetX > 0) ? offsetX : 0
        
        // 设置边距
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
        
    }
}
