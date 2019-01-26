//
//  FrameCounter.swift
//  ThreeDSwing
//
//  Created by BingBing on 17/1/10.
//  Copyright © 2017年 Xhey. All rights reserved.
//

import Foundation

struct FrameCounter {
    var targetFramesNumber: Int
    var totalFramesNumber: Int
    
    func shouldTakeFrame(atIndex index: Int) -> Bool {
        if index <= 0 || index > totalFramesNumber || totalFramesNumber <= targetFramesNumber || totalFramesNumber <= 1 {
            return true
        }
        let step = Double(targetFramesNumber - 1) / Double(totalFramesNumber - 1)
        
        let lastProgress = step * Double(index - 1)
        let progress = step * Double(index)
        
        let lastNumber = floor(lastProgress)
        let number = floor(progress)
        
        let diff = progress - number
        
        if lastNumber != number {
            let lastDiff = lastNumber - lastProgress
            if abs(diff) <= abs(lastDiff) {
                return true
            }
        }
        
        let nextProgress = step * Double(index + 1)
        let nextNumber = floor(nextProgress)

        if number != nextNumber {
            let nextDiff = nextProgress - nextNumber
            if abs(diff) < abs(nextDiff) {
                return true
            }
        }
        
        return false
    }
}
