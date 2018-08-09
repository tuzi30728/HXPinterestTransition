//
//  HXTransition.swift
//  HXPinterestTransitionDemo
//
//  Created by HongXiangWen on 2018/8/8.
//  Copyright © 2018年 WHX. All rights reserved.
//

import UIKit

enum HXNavigationTransitionAnimationType {
    case push
    case pop
    case custom
    case none
}

enum HXPresentationTransitionAnimationType {
    case present
    case dismiss
    case none
}

extension UIView {
    
    // MARK: - 生成截图
    func getScreenImage(rect: CGRect = CGRect.zero, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        var targetRect = rect
        if rect.equalTo(CGRect.zero) {
            targetRect = bounds
        }
        // 获取整个区域图片
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        //按照给定的矩形区域进行剪裁
        guard let sourceImageRef = image.cgImage else { return nil }
        let newRect = CGRect(x: targetRect.origin.x * scale, y: targetRect.origin.y * scale, width: targetRect.size.width * scale, height: targetRect.size.height * scale)
        guard let newImageRef = sourceImageRef.cropping(to: newRect) else { return nil }
        //将CGImageRef转换成UIImage
        let newImage = UIImage(cgImage: newImageRef,scale: scale, orientation: .up)
        return newImage
    }
    
}
