//
//  Gyro.swift
//  ThreeDSwing
//
//  Created by Leiming Du on 17/1/19.
//  Copyright © 2017年 Xhey. All rights reserved.
//

import UIKit
import CoreMotion

protocol GyroDataProcessing: class{
    func GyroDataProcess(_ gyroInstance: Gyro, rotateRateX x: Double, rotateRateY y: Double, rotateRateZ z: Double)
}

class Gyro {

    fileprivate let queue: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        q.underlyingQueue = DispatchQueue(label: "com.threedswing.gyrodata", attributes: [])
        return q
    }()
    
    weak var gyroDataProcessor :GyroDataProcessing?
    
    fileprivate var motionManager: CMMotionManager
    
    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.deviceMotionUpdateInterval = 0.02
        self.startGyro()
        registerNotifications()
    }
    
    private func startGyro() {
        self.motionManager.startDeviceMotionUpdates(to: queue) { [weak self] (motionData, error:Error?) in
            guard let weakSelf = self, let rotateRate = motionData?.rotationRate else {
                return
            }
            weakSelf.gyroDataProcessor?.GyroDataProcess(weakSelf, rotateRateX: rotateRate.x, rotateRateY: rotateRate.y, rotateRateZ: rotateRate.z)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        motionManager.stopGyroUpdates()
        queue.cancelAllOperations()
        queue.waitUntilAllOperationsAreFinished()
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(enterApp), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    @objc func enterApp() {
        startGyro()
    }
    
    @objc func enterBackground() {
        motionManager.stopGyroUpdates()
    }
    
}


