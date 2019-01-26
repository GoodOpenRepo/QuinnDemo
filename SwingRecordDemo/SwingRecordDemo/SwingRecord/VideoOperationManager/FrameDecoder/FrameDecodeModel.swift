//
//  FrameDecodeModel.swift
//  ThreeDSwing
//
//  Created by BingBing on 17/1/10.
//  Copyright © 2017年 Xhey. All rights reserved.
//

import Foundation
import AVFoundation
struct FrameDecodeModel: FrameDecoderModelProtocol {
    var id: String
    var inputUrl: URL
    var framesCount: Int
    var outputUrl: URL
    
    var asset: AVAsset
    
    init(forId: String, andVideoFile: URL, andFramesCount: Int, andOutputURL: URL) {
        id = forId
        inputUrl = andVideoFile
        framesCount = andFramesCount
        outputUrl = andOutputURL
        asset = AVAsset(url: inputUrl)
    }
    
}
