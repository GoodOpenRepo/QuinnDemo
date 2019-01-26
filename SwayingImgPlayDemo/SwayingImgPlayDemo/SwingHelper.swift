//
//  SwingHelper.swift
//  SwayingImgPlayDemo
//
//  Created by Quinn on 2019/1/24.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit

//MARK: Enums

enum SwingDirection {
    case fromLeft
    case fromRight
    case fromUp
    case fromDown
    
    var directionX: Double {
        switch self {
        case .fromLeft:
            return 1
        case .fromRight:
            return -1
        default:
            return 0
        }
    }
    
    var directionY: Double {
        switch self {
        case .fromUp:
            return -1
        case .fromDown:
            return 1
        default:
            return 0
        }
    }
    
    var directions: (directionX: Double, directionY: Double) {
        return (directionX, directionY)
    }
    
    init(fromDirectionX x: Double, andDirectionY y: Double) {
        if abs(x) >= abs(y) {
            if x > 0 {
                self = .fromLeft
            } else {
                self = .fromRight
            }
        } else {
            if y >= 0 {
                self = .fromDown
            } else {
                self = .fromUp
            }
        }
    }
}

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let WIDTH_SCALE = UIScreen.main.bounds.size.width/375
let HEIGHT_SCALE = UIScreen.main.bounds.size.height/667


func UIColorFromHex(_ hex6: UInt32, alpha: CGFloat = 1) -> UIColor {
    let divisor = CGFloat(255)
    let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
    let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
    let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}


extension UIView {
    var x : CGFloat {
        get {
            return frame.origin.x
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x     = newVal
            frame                 = tmpFrame
        }
    }
    
    // y
    var y : CGFloat {
        get {
            return frame.origin.y
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y     = newVal
            frame                 = tmpFrame
        }
    }
    
    // height
    var height : CGFloat {
        get {
            return frame.size.height
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newVal
            frame                 = tmpFrame
        }
    }
    
    // width
    var width : CGFloat {
        get {
            return frame.size.width
        }
        set(newVal) {
            
            var tmpFrame : CGRect = frame
            tmpFrame.size.width   = newVal
            frame                 = tmpFrame
        }
    }
    
    // left
    var left : CGFloat {
        get {
            return x
        }
        set(newVal) {
            x = newVal
        }
    }
    
    // right
    var right : CGFloat {
        get {
            return x + width
        }
        set(newVal) {
            x = newVal - width
        }
    }
    
    // top
    var top : CGFloat {
        get {
            return y
        }
        set(newVal) {
            y = newVal
        }
    }
    
    // bottom
    var bottom : CGFloat {
        get {
            return y + height
        }
        set(newVal) {
            y = newVal - height
        }
    }
    
    var centerX : CGFloat {
        get {
            return center.x
        }
        set(newVal) {
            center = CGPoint(x: newVal, y: center.y)
        }
    }
    
    var centerY : CGFloat {
        get {
            return center.y
        }
        set(newVal) {
            center = CGPoint(x: center.x, y: newVal)
        }
    }
    
    var middleX : CGFloat {
        get {
            return width / 2
        }
    }
    
    var middleY : CGFloat {
        get {
            return height / 2
        }
    }
    
    var middlePoint : CGPoint {
        get {
            return CGPoint(x: middleX, y: middleY)
        }
    }
}
enum SwingCellType: Int {
    case homePageType
    case detailVCType
    case privateType
    case mainPageType
    case loginType
}
