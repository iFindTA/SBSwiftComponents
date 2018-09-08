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
    public class func sb_gradient(_ size: CGSize, startColor start: UIColor, endColor end: UIColor, percentage: [CGFloat], type: GradientType = .left2Right) -> UIImage? {
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
}
