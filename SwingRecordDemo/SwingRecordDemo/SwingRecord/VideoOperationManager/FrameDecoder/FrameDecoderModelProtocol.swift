//
//  FrameDecoderModelProtocol.swift
//  ThreeDSwing
//
//  Created by BingBing on 17/1/10.
//  Copyright © 2017年 Xhey. All rights reserved.
//

import Foundation

protocol FrameDecoderModelProtocol: FrameReaderModelProtocol {
    
    var asset: AVAsset { get }
    
    var savedImageCount: Int { get }
}

extension FrameDecoderModelProtocol {
    
    var savedImageCount: Int {
        let fm = FileManager.default
        if fm.fileExists(atPath: outputUrl.path){
            if let arr = try? fm.contentsOfDirectory(atPath: outputUrl.path) {
                return arr.count
            }
        }
        return 0
    }
    
}
