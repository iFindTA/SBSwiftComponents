//
//  UIImageExt.swift
//  SBSwiftComponents
//
//  Created by nanhu on 2018/9/4.
//  Copyright © 2018年 nanhu. All rights reserved.
//

import UIKit
import Foundation
import CoreFoundation

public enum GradientType {
    case top2Bottom
    case left2Right
    case leftTop2RightBottom
    case leftBottom2RightTop
}

public extension UIImage {
    
    // MARK: - Class Methods
    public class func sb_imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x:0,y:0,width:size.width,height:size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    public class func sb_gradient(_ size: CGSize, with start: UIColor, with end: UIColor, percentage: [CGFloat], type: GradientType = .left2Right) -> UIImage? {
        assert(percentage.count < 5, "too many args in percentage!")
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let startColorComponents = start.cgColor.components else { return nil}
        guard let endColorComponents = end.cgColor.components else { return nil}
        let colorComponents: [CGFloat]
            = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: percentage, count: 2)
        var start: CGPoint
        var end: CGPoint
        switch type {
        case .top2Bottom:
            start = CGPoint(x: size.width*0.5, y: 0.0)
            end = CGPoint(x: size.width*0.5, y: size.height)
        case .left2Right:
            start = CGPoint(x: size.width*0.5, y: size.height*0.5)
            end = CGPoint(x: size.width, y: size.height*0.5)
        case .leftTop2RightBottom:
            start = CGPoint(x: 0, y: 0)
            end = CGPoint(x: size.width, y: size.height)
        case .leftBottom2RightTop:
            start = CGPoint(x: 0, y: size.height)
            end = CGPoint(x: size.width, y: 0)
        }
        guard let layer = gradient else {
            debugPrint("empty layer!")
            return nil
        }
        ctx?.drawLinearGradient(layer, start: start, end: end, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        ctx?.restoreGState()
        UIGraphicsEndImageContext()
        return image
    }
    
    // MARK: - Instance Methods
    public func sb_resize(_ targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    public func sb_darkColor(color :UIColor, level :CGFloat) -> UIImage {
        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
        color.setFill()
        UIRectFill(imageRect)
        self.draw(in: imageRect, blendMode: .destinationAtop, alpha: level)
        
        let destimg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return destimg!
    }
    public func sb_roundCorner(_ radius: CGFloat) -> UIImage? {
        let size = self.size
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else {
            return nil
        }
        context?.setShouldAntialias(true)
        let corners =  UIRectCorner.allCorners
        let bezierPath = UIBezierPath(roundedRect: imageRect,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: radius, height: radius))
        bezierPath.close()
        bezierPath.addClip()
        self.draw(in: imageRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    public func sb_cirle() -> UIImage {
        //开始图形上下文
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        //获取图形上下文
        let contentRef = UIGraphicsGetCurrentContext()
        //设置圆形
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        //根据 rect 创建一个椭圆
        contentRef?.addEllipse(in: rect)
        //裁剪
        contentRef?.clip()
        //将原图片画到图形上下文
        self.draw(in: rect)
        //从上下文获取裁剪后的图片
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        //关闭上下文
        UIGraphicsEndImageContext()
        return newImage
    }
    public func sb_compress(_ bytes: Int) -> UIImage {
        // Compress by quality
        var compression: CGFloat = 1
        guard let tmp = UIImageJPEGRepresentation(self, compression), tmp.count > bytes else {
            return self
        }
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        var data: Data?
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = UIImageJPEGRepresentation(self, compression)
            if let d = data, Double(d.count) < Double(bytes) * 0.9 {
                min = compression
            } else if let d = data, Double(d.count) > Double(bytes) {
                max = compression
            } else {
                break
            }
        }
        guard let aData = data else {
            debugPrint("mpty")
            return UIImage()
        }
        var resultImage: UIImage! = UIImage(data: aData)
        if  aData.count < bytes {
            return resultImage
        }
        
        var tmpData = aData
        // Compress by size
        var lastDataLength: Int = 0
        while tmpData.count > bytes && tmpData.count != lastDataLength {
            lastDataLength = tmpData.count
            let ratio: Float = Float(bytes) / Float(tmpData.count)
            let size = CGSize(width: CGFloat(Int(resultImage.size.width * CGFloat(sqrtf(ratio)))), height: CGFloat(Int(resultImage.size.height * CGFloat(sqrtf(ratio))))) // Use NSUInteger to prevent white blank
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            tmpData = UIImageJPEGRepresentation(resultImage, compression)!
        }
        
        return resultImage
    }
    
    /// iconfont => UIImage
    public class func sb_image(_ unicode: String, size: Int, color: UIColor?=nil, fontName: String = "iconfont") -> UIImage {
        guard fontName.isEmpty == false else {
            return UIImage()
        }
        let fontColor = color == nil ? UIColor.white : color
        let scale = UIScreen.main.scale
        let font = UIFont(name: fontName, size: CGFloat(size) * scale)
        guard font != nil else {
            debugPrint("font name not found!")
            return UIImage()
        }
        var attributes = [NSAttributedStringKey: Any]()
        attributes[NSAttributedStringKey.font] = font
        attributes[NSAttributedStringKey.foregroundColor] = fontColor
        let bitmapSize = CGFloat(size) * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: bitmapSize, height: bitmapSize), false, scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor((fontColor?.cgColor)!)
        NSString(string: unicode).draw(at: .zero, withAttributes: attributes)
        let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        let image = UIImage(cgImage: cgImage!, scale: scale, orientation: .up)
        return image
    }
}
