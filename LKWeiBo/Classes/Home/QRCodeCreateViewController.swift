//
//  QRCodeCreateViewController.swift
//  LKWeiBo
//
//  Created by 888 on 2017/3/11.
//  Copyright © 2017年 Kai Liu. All rights reserved.
//

import UIKit

class QRCodeCreateViewController: UIViewController {

    /// 二维码图片
    @IBOutlet weak var customImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // 创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        // 将需要生成的二维码数据添加到滤镜中
        filter?.setValue("liukai".data(using: String.Encoding.utf8), forKeyPath: "inputMessage")
        // 从滤镜中取出生成好的二维码图片
        guard let ciImage = filter?.outputImage else
        {
            return
        }
        
//        customImageView.image = UIImage(ciImage: ciImage)
        customImageView.image = createNonInterpolatedUIImageFormCIImage(image: ciImage, size: 500)
    }
    
    /**
     生成高清二维码
     
     - parameter image: 需要生成原始图片
     - parameter size:  生成的二维码的宽高
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        // 1.创建bitmap;
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale);
        bitmapRef.draw(bitmapImage, in: extent)
        // 2.保存bitmap到图片
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }

}
