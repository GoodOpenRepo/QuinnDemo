
//
//  SwingPlayer.swift
//  ThreeDSwing
//
//  Created by leiming du on 17/1/19.
//  Copyright © 2017年 Xhey. All rights reserved.
//

import UIKit

protocol SwingPlayable: class {
    
    func playProcess(_ playerInstance: SwingPlayer, Process process: Double, Frames frames: Int)
    func playAngleDiff(_ playerInstance: SwingPlayer, angleDiff: Double)
    func playSwayState(_ playerInstance: SwingPlayer, isSwaying: Bool)
    func playStartDrag(_ playerInstance: SwingPlayer)
    func playEndDrag(_ playerInstance: SwingPlayer)
}

extension SwingPlayable {
    func playAngleDiff(_ playerInstance: SwingPlayer, angleDiff: Double) {}
    func playSwayState(_ playerInstance: SwingPlayer, isSwaying: Bool) {}
    func playStartDrag(_ playerInstance: SwingPlayer) {}
    func playEndDrag(_ playerInstance: SwingPlayer) {}
}

let SwingPlayerStartPlayImagesNum: Int = 40

class SwingPlayer {
    
    fileprivate weak var swingImageView: UIImageView?
    fileprivate let gyro : Gyro
    fileprivate var lastProcess : Double = 0
    fileprivate var lastTime : TimeInterval = 0
    fileprivate var direction: SwingDirection?
    fileprivate var startRegion: Double = 0
    fileprivate var endRegion: Double = 1
    weak var playable : SwingPlayable?
    var isActive: Bool
    var lastIndex = -1
    fileprivate var lock: NSLock
    fileprivate let queue = DispatchQueue(label: "com.threedswing.readimageData")
    fileprivate var panGesture: UIPanGestureRecognizer?
    fileprivate var lastPanPoint :CGPoint = CGPoint(x: 0, y: 0)
    fileprivate var panGestureInProgress :Bool
    fileprivate var lookupNum: Int = 0
    fileprivate var hitNum: Int = 0
    var isShortVideo: Bool = false
    fileprivate var angleRates = [Double]()
    var imageProvider = SwingImageProvider()

    init(direction: SwingDirection, swingImageView: UIImageView, disableSlide: Bool = false) {
        self.swingImageView = swingImageView
        self.gyro = Gyro()
        self.isActive = true
        self.direction = direction
        self.panGestureInProgress = false
        lock = NSLock()
        
        self.gyro.gyroDataProcessor = self
        if !disableSlide {
            self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
            
            self.swingImageView?.addGestureRecognizer(self.panGesture!)
        }

        self.swingImageView?.isUserInteractionEnabled = true

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleLowMemoryWarning),
            name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleGuideViewPanGesture),
            name: NSNotification.Name(rawValue: "guideViewPanGesture"),
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func handleGuideViewPanGesture(notification: NSNotification){
        if let recognizer = notification.userInfo?["gesture"] {
            handlePanGesture(recognizer as! UIPanGestureRecognizer)
        }
    }
    
    @objc func handleLowMemoryWarning(notification: NSNotification){
        imageProvider.release()
    }
    
    func loadSwingData(_ data: Data, localPath: String, index: Int = 0) {
        imageProvider.loadSwingData(data, localPath: localPath, index: index)
        lock.lock()
        if isActive {
            if index == 0 {
                switchImage(imageIndex: 0)
            }
        }
        lock.unlock()
    }
    
    func switchImage(imageIndex index : Int) {

        let image: UIImage? = imageProvider.image(forIndex: index)
        
        if image == nil {
            
        } else {
            hitNum += 1
        }

        if image != nil {
            swingImageView?.image = image
            lastIndex = index
        }
        lookupNum += 1
    }
    
    func pausePlay() {
        isActive = false
    }
    
    func resumePlay() {
        lastTime = Date().timeIntervalSince1970
        isActive = true
    }

    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        guard imageProvider.swingDataPaths.count > 0 else {
            return
        }
        
        let location = recognizer.translation(in: swingImageView)
        
        switch recognizer.state {
        case .began:
            lastPanPoint = location
            panGestureInProgress = true
            if isActive {
                playable?.playStartDrag(self)
            }
            return
        case .ended,.failed,.cancelled:
            panGestureInProgress = false
            if isActive {
                playable?.playEndDrag(self)
            }
        default:
            break
        }
        
        guard isActive else {
            return
        }
        
        let processDiff = SwingPlayerCaculate.caculateProgressDiffFromPoint(location, lastPanPoint, direction!)

        lastPanPoint = location
        
        handleProcessChange(processDiff)
    }
    
    func handleProcessChange(_ processDiff: Double) {

        if imageProvider.swingDataPaths.count < SwingPlayerStartPlayImagesNum && !isShortVideo{
            return
        }
        
        lastProcess = lastProcess + processDiff
        
        if lastProcess <= startRegion {
            lastProcess = startRegion
        }
        
        if lastProcess >= endRegion {
            lastProcess = endRegion
        }
 
        OperationQueue.main.addOperation { [weak self] in
            self?.playImage((self?.lastProcess)!)
        }
    }
    
    func handleSwayStateChange(_ angleRate: Double) {
        
        if angleRates.count >= SwingPlayerStartPlayImagesNum {
            angleRates.remove(at: 0)
        }
        angleRates.append(abs(angleRate) >= 0.1 ? 1 : 0)
        
        let totoal = angleRates.reduce(0, +)
        
        if totoal / Double(angleRates.count) > 0.85 {
            playable?.playSwayState(self, isSwaying: true)
        } else {
            playable?.playSwayState(self, isSwaying: false)
        }
    }

    func playImage(_ process: Double) {
            let imageIndex = SwingPlayerCaculate.getIndex(process, imageProvider.swingDataPaths.count)
            
            switchImage(imageIndex: imageIndex)
            
            if playable != nil {
                DispatchQueue.main.async(execute: {[weak self] in
                    self?.playable?.playProcess(self!, Process: (self?.lastProcess)!, Frames: (self?.imageProvider.swingDataPaths.count)!)
                })
            }
    }
    
    func setStartRegion(progress: Double) {
        startRegion = progress
        changeProgress(progress: progress)
    }
    
    func setEndRegion(progress: Double) {
        endRegion = progress
        changeProgress(progress: progress)
    }

    fileprivate func changeProgress(progress: Double) {
        lastProcess = progress
        playImage(progress)
    }
    
    func stopPlay() {
        lock.lock()
        isActive = false
        lock.unlock()

        if self.panGesture != nil {
           swingImageView?.removeGestureRecognizer(self.panGesture!)
        }

        swingImageView?.image = nil
        imageProvider = SwingImageProvider()
        
        lastPanPoint = CGPoint(x: 0, y: 0)
        lookupNum = 0
        hitNum = 0
    }
}

extension  SwingPlayer : GyroDataProcessing {
    
    func GyroDataProcess(_ gyroInstance: Gyro, rotateRateX x: Double, rotateRateY y: Double, rotateRateZ z: Double) {
        
        guard isActive else {
            return
        }

        if panGestureInProgress {
            lastTime = Date().timeIntervalSince1970
            return
        }
        
        let angleRate: Double = SwingPlayerCaculate.getAngleRate(rotateRateX: x, rotateRateY: y, rotateRateZ: z, direction: direction!)
        
        if abs(angleRate) < 0.05 {
            return
        }
    
        handleSwayStateChange(angleRate)
        
        let maxAngle: Double = SwingPlayerCaculate.getMaxAngle(imageProvider.swingDataPaths.count)
        
        let currentTime: Double = Date().timeIntervalSince1970
        
        let timeDiff: Double = lastTime == 0 ? 0 : currentTime - lastTime
        
        let processDiff: Double = SwingPlayerCaculate.calculateProgressDiffFromAngleRate(angleRate, timeDiff, maxAngle)
        
        lastTime = currentTime

        self.playable?.playAngleDiff(self, angleDiff: processDiff * maxAngle)

        handleProcessChange(processDiff)
    }
    
}
