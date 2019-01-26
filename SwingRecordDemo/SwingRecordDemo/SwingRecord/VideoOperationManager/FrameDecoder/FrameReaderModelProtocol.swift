//
//  FrameDecoderModelProtocol.swift
//  ThreeDSwing
//
//  Created by BingBing on 17/1/10.
//  Copyright © 2017年 Xhey. All rights reserved.
//

import Foundation

protocol FrameReaderModelProtocol {
    var id: String { get }

    var inputUrl: URL { get }
    var outputUrl: URL { get }
    var framesCount: Int { get }


    var targetFramesCount: Int { get }
    var isDecodeFinished: Bool { get }
    func pictureFileName(forIndex: Int) -> String
    
}

extension FrameReaderModelProtocol {
    
    var targetFramesCount: Int {
        return framesCount > 90 ? 90 : framesCount
    }
    
    func pictureFileName(forIndex index: Int) -> String {
        let name = String(format: "%.3d.jpg", index)
        return name
    }
    
    var isDecodeFinished: Bool {
        let fm = FileManager.default
        if fm.fileExists(atPath: outputUrl.path){
            if let arr = try? fm.contentsOfDirectory(atPath: outputUrl.path), arr.count > 0 {
                let filesCount = arr.count
                if filesCount == targetFramesCount {
                    return true
                }
            }
        }
        return false
    }

}
