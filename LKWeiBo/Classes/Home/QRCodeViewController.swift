//
//  QRCodeViewController.swift
//  LKWeiBo
//
//  Created by Kai Liu on 17/3/9.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

import AVFoundation

class QRCodeViewController: UIViewController {

    /// 容器视图
    @IBOutlet weak var customContaineView: UIView!
    /// 底部工具条
    @IBOutlet weak var customTabbar: UITabBar!
    /// 容器的高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    /// 冲击波顶部的约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    /// 冲击波图片
    @IBOutlet weak var scanLineImageView: UIImageView!
    /// 结果文本
    @IBOutlet weak var customLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置 tabbar 的默认选中
        customTabbar.selectedItem = customTabbar.items?.first
        
        // 添加监听,监听底部工具条的点击
        customTabbar.delegate = self
        
        // 开始扫描二维码
        scanQRCode()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        starAnimation()
    }
    
    // MARK: - 内部控制方法
    /// 开始执行冲击波动画
    func starAnimation()
    {
        // 设置冲击波的约束
        scanLineCons.constant = -containerHeightCons.constant
        
        // 强制更新下约束,让冲击波从正确的方向出来
        view.layoutIfNeeded()
        
        // 执行扫描的动画
        UIView.animate(withDuration: 2.0) {
            // 无限次循环动画
            UIView.setAnimationRepeatCount(MAXFLOAT)
            
            self.scanLineCons.constant = self.containerHeightCons.constant
            
            self.view.layoutIfNeeded()
        }
    }
    
    /// 扫描二维码
    func scanQRCode()
    {
        // 1.判断输入能否添加到会话中
        if !session.canAddInput(input)
        {
            return
        }
        // 2.判断输出能否添加到会话中
        if !session.canAddOutput(output)
        {
            return
        }
        // 3.添加输入输出到会话中
        session.addInput(input)
        session.addOutput(output)
        // 4.设置输出能够解析的数据类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        // 5.设置监听解析到的数据
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // 6.添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds
        // 7.添加容器图层
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        // 8.开始扫描
        session.startRunning()
    }
    
    /// 关闭按钮点击
    @IBAction func closeBtnClick(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    /// 相册按钮点击
    @IBAction func photoBtnClick(_ sender: Any)
    {
        // 是否能够打开相册
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            return
        }
        // 创建相册控制器
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        // 弹出相册控制器
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    /// 输入对象
    private lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        return try? AVCaptureDeviceInput(device: device)
    }()
    /// 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    /// 输出对象
    private lazy var output: AVCaptureMetadataOutput =
    {
        let out = AVCaptureMetadataOutput()
        // 设置输出对象解析数据时感兴趣的范围
        let viewRect = self.view.bounds
        let containerRect = self.customContaineView.bounds
        let x = containerRect.origin.y / viewRect.height
        let y = containerRect.origin.x / viewRect.width
        let width = containerRect.height / viewRect.height
        let height = containerRect.width / viewRect.width
        // 设置范围
//        out.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
        return out
    }()
    /// 预览图层
    lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    /// 保存描绘扫描结果的容器图层
    lazy var containerLayer: CALayer = CALayer()
}

extension QRCodeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    /// 选择相片回调
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        // 取出选中的图片
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        let ciImage = CIImage(image: image)!
        // 从选中的图片中读取二维码数据
        // 创建一个探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        // 利用探测器探测数据
        let results = detector?.features(in: ciImage)
        // 取出探测器取到的数据
        for result in results!
        {
            LKLog(message: (result as! CIQRCodeFeature).messageString!)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate
{
    /// 只要扫描到结果 就会调用该方法
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        // 显示扫描到的结果
        customLabel.text = (metadataObjects.last as AnyObject).stringValue
        
        // 绘制前先清空描边
        clearLayers()
        
        // 通过预览图层获取到扫描结果的边框位置
        guard let metadata = metadataObjects.last as? AVMetadataObject else
        {
            return
        }
        let objc = previewLayer.transformedMetadataObject(for: metadata)
        
        // 对扫描的二维码进行描边
        drawLines(objc: objc as! AVMetadataMachineReadableCodeObject)
    }
    
    /// 绘制描边
    private func drawLines(objc: AVMetadataMachineReadableCodeObject)
    {
        // 安全校验
        guard let array = objc.corners else {
            return
        }
        
        // 创建图层,用于保存绘制的矩形
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.clear.cgColor
        // 创建UIBezierPath,绘制矩形
        let path = UIBezierPath()
        
        // 获取起点
        var index = 0
        let point = CGPoint.init(dictionaryRepresentation: array[index] as! CFDictionary)
        index += 1
        
        // 将起点移动至某一点
        path.move(to: point!)
        
        // 连接其他线段
        while index < array.count
        {
            // 获取其余线段
            let point = CGPoint.init(dictionaryRepresentation: array[index] as! CFDictionary)
            index += 1
            path.addLine(to: point!)
        }
        
        // 闭合路径
        path.close()
        
        layer.path = path.cgPath
        // 将用于保存矩形的图层添加到界面上
        containerLayer.addSublayer(layer)
    }
    
    /// 清空描边
    private func clearLayers()
    {
        guard let subLayers = containerLayer.sublayers else
        {
            return
        }
        
        for layer in subLayers
        {
            layer.removeFromSuperlayer()
        }
        
    }
    
}

extension QRCodeViewController: UITabBarDelegate
{
    /// 点击某个 tabbarItem 调用
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        // 根据当前选中的按钮重新设置二维码容器的高度
        containerHeightCons.constant = (item.tag == 2) ? 100 : 200
        view.layoutIfNeeded()
        
        // 移除动画
        scanLineImageView.layer.removeAllAnimations()
        
        // 重新开启动画
        starAnimation()
    }
}
