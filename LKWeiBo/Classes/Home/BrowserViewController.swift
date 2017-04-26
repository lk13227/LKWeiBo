//
//  BrowserViewController.swift
//  LKWeiBo
//
//  Created by 888 on 2017/4/12.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class BrowserViewController: UIViewController {

    /// 图片模型
    var large_pic: [URL]
    /// 索引
    var indexPath: IndexPath
    
    init(large_pic: [URL], indexPath: IndexPath)
    {
        self.large_pic = large_pic
        self.indexPath = indexPath
        
        // 注意  自定义构造方法时需要调用当前类设计构造方法
        super.init(nibName: nil, bundle: nil)
        
        // 初始化 UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 将collectionView滚到指定页
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
    }
    
    // MARK: - 内部控制方法
    private func setupUI()
    {
        
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        // 布局子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        view.addConstraints(cons)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        let dict = ["closeButton": closeButton, "saveButton": saveButton]
        let closeHCons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[closeButton(100)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        let closeVCons = NSLayoutConstraint.constraints(withVisualFormat: "V:[closeButton(50)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        view.addConstraints(closeHCons)
        view.addConstraints(closeVCons)
        
        let saveHCons = NSLayoutConstraint.constraints(withVisualFormat: "H:[saveButton(100)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        let saveVCons = NSLayoutConstraint.constraints(withVisualFormat: "V:[saveButton(50)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        view.addConstraints(saveHCons)
        view.addConstraints(saveVCons)
        
    }
    
    @objc private func closeBtnClick()
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveBtnClick()
    {
        // 获取当前显示图片的索引
        let indexPath = collectionView.indexPathsForVisibleItems.last!
        // 获取当前显示的 cell
        let cell = collectionView.cellForItem(at: indexPath) as! LKBrowserCell
        // 获取当前显示的图片
        let image = cell.imageView.image!
        // 保存图片
        // - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(BrowserViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject?)
    {
        if didFinishSavingWithError != nil
        {
            SVProgressHUD.showError(withStatus: "保存图片失败")
            return
        }
        SVProgressHUD.showSuccess(withStatus: "保存图片成功")
    }
    
    // MARK: - 懒加载
    private lazy var collectionView: UICollectionView =
    {
        let clv = UICollectionView(frame: CGRect.zero, collectionViewLayout: LKBrowserLayout())
        clv.dataSource = self
        clv.register(LKBrowserCell.self, forCellWithReuseIdentifier: "browserCell")
        return clv
    }()
    
    private lazy var closeButton: UIButton =
    {
        let btn = UIButton()
        btn.setTitle("关闭", for: UIControlState.normal)
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        btn.addTarget(self, action: #selector(BrowserViewController.closeBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    private lazy var saveButton: UIButton =
    {
        let btn = UIButton()
        btn.setTitle("保存", for: UIControlState.normal)
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        btn.addTarget(self, action: #selector(BrowserViewController.saveBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()

}

/// 数据源方法 
extension BrowserViewController: UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return large_pic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browserCell", for: indexPath) as! LKBrowserCell
        
        cell.imageURL = large_pic[indexPath.item]
        
        return cell
        
    }
    
}

/// 自定义布局
class LKBrowserLayout: UICollectionViewFlowLayout
{
    override func prepare()
    {
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
