//
//  UIImage+Extension.swift
//  ThreeDSwing
//
//  Created by Yuguo Lee on 16/7/20.
//  Copyright © 2016年 Xhey. All rights reserved.
//

import UIKit

extension UIImage {
    
    
    class func imageFromColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    class func imageWithColor(_ color: UIColor, width: CGFloat = 100, height: CGFloat = 100) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    var containsAlphaComponent: Bool {
        let alphaInfo = cgImage?.alphaInfo
        
        return (
            alphaInfo == .first ||
                alphaInfo == .last ||
                alphaInfo == .premultipliedFirst ||
                alphaInfo == .premultipliedLast
        )
    }
    
    /// Returns whether the image is opaque.
    var isOpaque: Bool { return !containsAlphaComponent }
    
    func scaledToSize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    func scaledToRatioSize(_ ratio: CGFloat) -> UIImage {
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        let scaledImage = self.scaledToSize(newSize)
        return scaledImage
    }
    
    func clipSquareFromCenter() -> UIImage? {
        let x: CGFloat = 0
        let y: CGFloat = (667-375)*0.5
        let size: CGFloat = 375
        let rect = CGRect(x: x, y: y, width: size, height: size)
        return clip(rect: rect, fromSize: CGSize(width: 375, height: 667))
    }
    
    func clip(rect: CGRect, fromSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(fromSize)
        self.draw(in: CGRect(x: 0, y: 0, width: fromSize.width, height: fromSize.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let cgImage = img?.cgImage?.cropping(to: rect) {
            let clipImage = UIImage(cgImage: cgImage)
            return clipImage
        }
        return nil
    }
    
    func merge(myRect: CGRect? = nil ,image: UIImage, inRect: CGRect, totalSize: CGSize? = nil) -> UIImage? {
        let size = totalSize ?? self.size
        let _myRect = myRect ?? CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        self.draw(in: _myRect)
        image.draw(in: inRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func snapchatCodeImageHollow() -> UIImage? {
        let size: CGFloat = 260
        let overlap = UIImage(named: "snapchat_cover")!
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        overlap.draw(in: rect, blendMode: .destinationOut, alpha: 1.0)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(M_PI))
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint(x:0, y:0), size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        bitmap!.rotate(by: degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        //CGContextDrawImage(bitmap, CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height), self.cgImage)
        bitmap?.draw(self.cgImage!, in: CGRect(x: -size.width / 2,y: -size.height / 2,width: size.width,height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
}
