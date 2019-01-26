//
//  File.swift
//  ThreeDSwing
//
//  Created by Leiming Du on 2017/1/19.
//  Copyright © 2017年 Xhey. All rights reserved.
//

import Foundation
import UIKit
class SwingPlayerCaculate {
    
    class func getAngleRate(rotateRateX x: Double, rotateRateY y: Double, rotateRateZ z: Double, direction: SwingDirection) -> (Double) {
        
        var angleRate : Double = 0
        
        switch direction {
            
        case .fromLeft:
            angleRate = y
        case .fromRight:
            angleRate = -y
        case .fromUp:
            angleRate = x
        case .fromDown:
            angleRate = -x
        }
        
        if angleRate > Double.pi / 2 {
            angleRate = Double.pi / 2
        }
        
        if angleRate < -Double.pi / 2 {
            angleRate = -Double.pi / 2
        }
        
        return angleRate
    }
    
    class func getMaxAngle(_ imageCount: Int) -> (Double) {
        

        if imageCount >= 180 {
            return Double.pi / 3.6
        }else if imageCount <= 60 {
            return Double.pi / 6
        }else {
            return Double(imageCount) / 3 / 180 * Double.pi
        }
    }

    class func calculateProgressDiffFromAngleRate(_ angleRate: Double, _ timeDiff: Double, _ maxAngle: Double) -> (Double) {
        
        var angleDiff: Double = 0
        
        angleDiff = angleRate * timeDiff
        
        return angleDiff / maxAngle
    }
    
    class func caculateProgressDiffFromPoint(_ currentPoint: CGPoint, _ lastPoint: CGPoint, _ direction: SwingDirection) -> (Double) {
        var dis: CGFloat = 0
        var offset :CGFloat = 0
        
        switch direction {
        case .fromLeft, .fromRight:
            dis = currentPoint.x - lastPoint.x
            offset = dis / SCREEN_WIDTH
        case .fromUp, .fromDown:
            dis = currentPoint.y - lastPoint.y
            offset = dis / SCREEN_HEIGHT
        }

        return Double(offset)
    }
    
    class func getIndex(_ progress: Double, _ count: Int) -> (Int) {
        
        return Int( progress * Double(count))
        
    }
    
}
