//
//  NewfeatureViewController.swift
//  LKWeiBo
//
//  Created by 888 on 2017/3/28.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit
import SnapKit

class NewfeatureViewController: UIViewController {

    /// 新特性页面的个数
    var maxCount = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension NewfeatureViewController: UICollectionViewDataSource
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newfeaturecell", for: indexPath) as! LKNewfeatureCell
        
        cell.index = indexPath.item
        
        return cell
        
    }
    
}

extension NewfeatureViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // 传入的 cell 是上一页的
        // 手动获取当前显示的 cell 对应的 indexPath
        let index = collectionView.indexPathsForVisibleItems.last!
        // 根据指定的索引 获取当前显示的 cell
        let currentCell = collectionView.cellForItem(at: index) as! LKNewfeatureCell
        // 判断当前是否是最后一页
        if index.item == maxCount - 1
        {
            // 按钮动画
            currentCell.startAniamtion()
        }
    }
}

// MARK: - 自定义cell
class LKNewfeatureCell: UICollectionViewCell
{
    var index: Int = 1
        {
        didSet{
            // 生成图片名称
            let name = "new_feature_\(index + 1)"
            // 设置图片
            iconView.image = UIImage(named: name)
            // 设置开始按钮
            startBtn.isHidden = true
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    // MARK: - 外部控制方法
    func startAniamtion()
    {
        startBtn.isHidden = false
        startBtn.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        startBtn.isUserInteractionEnabled = false
        // 执行放大动画
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
            
            self.startBtn.transform = CGAffineTransform.identity
            
        }, completion: { (_) in
            self.startBtn.isUserInteractionEnabled = true
        })
    }
    
    // MARK: - 内部控制方法
    func setupUI()
    {
        // 添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(startBtn)
        // 布局子控件
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        startBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-160)
        }
        
    }
    
    // 进入微博按钮
    func startBtnClick()
    {
        // 跳转到主界面
        /**
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        UIApplication.shared.keyWindow?.rootViewController = vc
         */
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LKSwitchRootViewController), object: true)
    }
    
    // MARK: -  懒加载
    /// 图片
    private lazy var iconView = UIImageView()
    /// 开始按钮
    private lazy var startBtn: UIButton = {
        let btn = UIButton(imageName: nil, backgroundImageName: "new_feature_button")
        btn.addTarget(self, action: #selector(LKNewfeatureCell.startBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
}

// MARK: - 自定义布局
class LKNewfeatureLayout: UICollectionViewFlowLayout
{
    // 准备布局
    override func prepare() {
        // 设置每个 cell 的尺寸
        itemSize = UIScreen.main.bounds.size
        // 设置 cell 的间隙
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        // 设置滚动方向
        scrollDirection = UICollectionViewScrollDirection.horizontal
        // 设置分页
        collectionView?.isPagingEnabled = true
        // 禁用弹簧效果
        collectionView?.bounces = false
        // 去除滚动条
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
    }
}
