//
//  SwingRotateBarView.swift
//  SwingRotateBarView
//
//  Created by 孙凡 on 16/12/9.
//  Copyright © 2016年 Edward. All rights reserved.
//

import UIKit
let rollHeight         : CGFloat = 8*HEIGHT_SCALE
let backLineHeight     : CGFloat = 8*HEIGHT_SCALE

class SwingRotateBarView: UIView {
    
    fileprivate let progressView       : UIView = UIView()
    fileprivate let rollView           : UIView = UIView()
    fileprivate let pushAnimationView  : UIImageView = UIImageView()
    fileprivate let pushAnimationViewLeft : UIImageView = UIImageView()
    var direction: SwingDirection = .fromLeft
    var cellType: SwingCellType = .homePageType
    var progress: CGFloat = 0 {
        didSet {
            configProgress(progress)
        }
    }
    var maxHeight: CGFloat = SCREEN_HEIGHT
    var maxWidth: CGFloat = SCREEN_WIDTH
    
    /*determine by line state*/
    var maxLength: CGFloat = 180 * WIDTH_SCALE
    var miniLength: CGFloat = 90 * WIDTH_SCALE
    
    fileprivate let     minimumFrameNum: Int = 30
    fileprivate let         maxFrameNum: Int = 180
    fileprivate var minimumRotateLength: CGFloat = 60
    fileprivate var     maxRotateLength: CGFloat = 180
    fileprivate let progressBarBackground: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFrame() {
        self.updateFrame(direction, cellType: cellType)
    }

    deinit {
        
    }
}

// MARK: Private
extension SwingRotateBarView {
    fileprivate func setupUI(){
        
        self.backgroundColor = UIColor.clear

        progressBarBackground.frame = CGRect.zero
        self.addSubview(progressBarBackground)

        progressView.frame = CGRect.zero
        self.addSubview(progressView)
        
        rollView.frame = CGRect.zero
        rollView.backgroundColor = UIColorFromHex(0xfbda09)
        rollView.layer.cornerRadius = rollHeight * 0.5
        rollView.layer.masksToBounds = true
        self.addSubview(rollView)
        
        pushAnimationView.frame = CGRect.zero
        pushAnimationView.isHidden = true
        self.addSubview(pushAnimationView)
        
        pushAnimationViewLeft.frame = CGRect.zero
        pushAnimationViewLeft.isHidden = true
        self.addSubview(pushAnimationViewLeft)
        
    }
    
    fileprivate func updateFrame(_ state: SwingDirection, cellType: SwingCellType = .homePageType) {
        pushAnimationViewLeft.isHidden = true
        pushAnimationView.isHidden = true

        if cellType == .mainPageType {
            maxHeight = SCREEN_WIDTH * 1.2
        }

        let width = maxWidth
        let height = maxHeight
        switch state {
        case .fromLeft, .fromRight:
            if cellType == .homePageType {
                self.frame = CGRect(x: 0, y: 0, width: width, height: backLineHeight)
                progressView.backgroundColor = UIColorFromHex(0x000000, alpha: 0.2)
            } else if cellType == .loginType {
                self.frame = CGRect(x: 0, y: 607 * HEIGHT_SCALE, width: width, height: backLineHeight)
                progressView.backgroundColor = UIColorFromHex(0x000000, alpha: 0.2)
            }
            else {
                self.frame = CGRect(x: 0, y: 0, width: width, height: backLineHeight)
                progressView.backgroundColor = UIColorFromHex(0x000000, alpha: 0.2)
            }
            
            minimumRotateLength = miniLength
            maxRotateLength = maxLength
            
            pushAnimationView.frame = CGRect(x:width - 28 * WIDTH_SCALE, y:0, width: 30 * WIDTH_SCALE, height: 8 * HEIGHT_SCALE)
            pushAnimationView.image = UIImage(named: "progress_push_effect")?.imageRotatedByDegrees(degrees: 180, flip: true)
            pushAnimationViewLeft.frame = CGRect(x:-2, y:0, width: 28 * WIDTH_SCALE, height: 8 * HEIGHT_SCALE)
            let image = UIImage(named: "progress_push_effect")
            pushAnimationViewLeft.image = image?.imageRotatedByDegrees(degrees: -180, flip: false)
            
            progressBarBackground.image = UIImage(named: "progress_bar_background")
            progressBarBackground.frame = self.frame
            progressBarBackground.height = 20.0
            
        case .fromUp, .fromDown:

            if cellType == .homePageType {
                self.frame = CGRect(x: 0, y: 0, width: backLineHeight, height: height)
            } else {
                self.frame = CGRect(x: 0, y: 0, width: backLineHeight, height: height)
            }
            progressView.backgroundColor = UIColorFromHex(0x000000, alpha: 0.2)
            
            minimumRotateLength = 30/width*(height - 56*HEIGHT_SCALE)
            maxRotateLength = 180/width*(height - 56*HEIGHT_SCALE)
            
            let image = UIImage(named: "progress_push_effect_vertical")
            pushAnimationView.frame = CGRect(x: 0, y:0, width: backLineHeight, height: 30*HEIGHT_SCALE)
            pushAnimationView.image = image?.imageRotatedByDegrees(degrees: -180, flip: true)
            pushAnimationViewLeft.frame = CGRect(x:0, y:height - 30*HEIGHT_SCALE, width: backLineHeight, height: 30*HEIGHT_SCALE)
            pushAnimationViewLeft.image = image?.imageRotatedByDegrees(degrees: 0, flip: false)
            
            minimumRotateLength = miniLength/width*(height - 56*HEIGHT_SCALE)
            maxRotateLength = maxLength/width*(height - 56*HEIGHT_SCALE)
    
            let backImage = UIImage(named: "progress_bar_background")
            progressBarBackground.image = backImage?.imageRotatedByDegrees(degrees: -90, flip: false)

            progressBarBackground.frame = self.frame
            progressBarBackground.height = 20.0
        }
    }
}

// MARK: Open Action
extension SwingRotateBarView {
    
    func resetRoll() {
        rollView.frame = CGRect.zero
        pushAnimationView.isHidden = true
        pushAnimationViewLeft.isHidden = true
        progressBarBackground.isHighlighted = true
    }
    
    func hiddenRoll(_ b: Bool) {
        rollView.frame = CGRect.zero
        if rollView.isHidden == !b {
            rollView.isHidden = b
        }
        
        if pushAnimationViewLeft.isHidden == !b {
            pushAnimationViewLeft.isHidden = b
        }
        
        if pushAnimationView.isHidden == !b {
            pushAnimationView.isHidden = b
        }
    
        if progressBarBackground.isHidden == !b {
            progressBarBackground.isHidden = b
        }
    }
}

// MARK: RotateBar
extension SwingRotateBarView {
    func setRotateProgress(progress: CGFloat, frames: Int) {
        
        pushAnimationView.isHidden = true
        pushAnimationViewLeft.isHidden = true
        // filter infos
        var f = frames
        var p: CGFloat = progress
        if f < minimumFrameNum {
            f = minimumFrameNum
        } else if f > maxFrameNum {
            f = maxFrameNum
        }
        
        // calculate length
        let framesDiff: CGFloat = CGFloat(maxFrameNum - minimumFrameNum)
        let l: CGFloat = -CGFloat(f) * ((framesDiff-minimumRotateLength)/maxRotateLength) + framesDiff

        
        if p <= 0.05 {
            
            if direction == .fromLeft {
                p = p - 0.1
                pushAnimationViewLeft.y = 8 * HEIGHT_SCALE - 1
                //pushAnimationViewLeft.y = -(floor(4 * HEIGHT_SCALE  * pow((abs(p) + 1) * 1.1, 8)) + 1)
                pushAnimationViewLeft.height = floor(4 * HEIGHT_SCALE  * pow((abs(p) + 1) * 1.1, 8))
                
                pushAnimationViewLeft.isHidden = false
            } else if direction == .fromRight {
                p = p - 0.1
                pushAnimationView.y = (floor(4 * HEIGHT_SCALE  * pow((abs(p) + 1) * 1.1, 8)) + 1)
                pushAnimationView.y = 8 * HEIGHT_SCALE - 1
                pushAnimationView.height = floor(4 * HEIGHT_SCALE * pow((abs(p) + 1) * 1.1, 8))
                pushAnimationView.isHidden = false
            } else if direction == .fromDown {
                p = p - 0.1
                pushAnimationViewLeft.x = rollHeight - 1
                pushAnimationViewLeft.width = 8 * WIDTH_SCALE * pow((abs(p) + 1), 8)
                pushAnimationViewLeft.isHidden = false
            } else {
                p = p - 0.1
                pushAnimationView.x = rollHeight - 1
                pushAnimationView.width = 8 * WIDTH_SCALE * pow((abs(p) + 1), 8)
                pushAnimationView.isHidden = false
            }
        }else if p >= 0.95{
            if direction == .fromLeft {
                p = p * 1.1
                pushAnimationView.y = 8 * HEIGHT_SCALE - 1
                //pushAnimationView.y = -(floor(4 * HEIGHT_SCALE * pow(p * 1.1, 8)) + 1)
                pushAnimationView.height = floor(4 * HEIGHT_SCALE * pow(p * 1.1, 8))
                pushAnimationView.isHidden = false
            } else if direction == .fromRight {
                p = p * 1.1
                pushAnimationViewLeft.y = 8 * HEIGHT_SCALE - 1
                //pushAnimationViewLeft.y = -(floor(4 * HEIGHT_SCALE * pow(p * 1.1, 8)) + 1)
                pushAnimationViewLeft.height = floor(4 * HEIGHT_SCALE * pow(p * 1.1, 8))
                
                pushAnimationViewLeft.isHidden = false
            } else if direction == .fromDown {
                p = p * 1.1
                pushAnimationView.x = rollHeight - 1
                pushAnimationView.width = 8 * WIDTH_SCALE * pow(p, 8)
                pushAnimationView.isHidden = false
            } else {
                p = p * 1.1
                pushAnimationViewLeft.x = rollHeight - 1
                pushAnimationViewLeft.width = 8 * WIDTH_SCALE * pow(p, 8)
                pushAnimationViewLeft.isHidden = false
            }
        } else {
            pushAnimationView.isHidden = true
            pushAnimationViewLeft.isHidden = true
        }
        
        // calculate x
        let x = p * (self.width - l)
        // calculate y
        let y = p * (self.height - l)
        
        //        print("p:\(p)  f:\(f)")
        //        print("lenght:\(l)  x:\(x) y:\(y)")
        
        var rollRect: CGRect = CGRect.zero
        switch direction {
        case .fromLeft:
            var finalX = x
            if finalX > self.width - l / 2 {
                finalX =  (self.width - l / 2) + 8 * pow(p, 2)
            } else if finalX < -(l / 2) {
                finalX = -(l / 2) - 8 * pow((1 - p), 2)
            }
            rollRect = CGRect(x: finalX, y: 0, width: l, height: rollHeight)
        case .fromRight:
            var finalX = self.width - x - l
            if finalX > self.width -  l / 2 {
                finalX =  (self.width - l / 2) + 8 * pow(p, 2)
            } else if finalX < -(l / 2) {
                finalX = -(l / 2) + 8 * pow(1 - p, 2)
            }
            rollRect = CGRect(x: finalX, y: 0, width: l, height: rollHeight)
        case .fromUp:
            var finalY = y
            if finalY < -(l / 2) {
                finalY = -(l / 2) - 8 * pow(1 - p, 2)
            } else if finalY > self.height - l / 2 {
                finalY = self.height - l / 2 + 8 * pow(p, 2)
            }

            rollRect = CGRect(x: 0, y: finalY, width: rollHeight, height: l)
        case .fromDown:
            var finalY = self.height - y - l
            if finalY < -(l / 2) {
                finalY = -(l / 2) - 8 * pow (1 - p, 2)
            } else if finalY > self.height - l / 2 {
                finalY = self.height - l / 2 + 8 * pow(p, 2)
            }
            rollRect = CGRect(x: 0, y: finalY, width: rollHeight, height: l)
        }
        
        self.rollView.frame = rollRect
    }
    
}

// MARK: progressView
extension SwingRotateBarView {
    func configProgress(_ progress: CGFloat) {
        var p = progress
        if p >= 1 {
            p = 1
        } else if p < 0 {
            p = 0
        }
        var progressRect: CGRect = CGRect.zero
        switch direction {
        case .fromLeft, .fromRight:
            let w = p * self.width
            let h = backLineHeight
            let x = (self.width - w) * 0.5
            let y: CGFloat = 0
            progressRect = CGRect(x: x, y: y, width: w, height: h)
            break
        case .fromUp, .fromDown:
            let w = backLineHeight
            let h = p * self.height
            let x: CGFloat = 0
            let y = (self.height - h) * 0.5
            progressRect = CGRect(x: x, y: y, width: w, height: h)
            break
        }
        //        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
        //        }, completion: nil)
        self.progressView.frame = progressRect
    }
}

class SwingProgressModle {
    static let sharedManager = SwingProgressModle()
    var progressDict: [String: CGFloat] = [:]
}
