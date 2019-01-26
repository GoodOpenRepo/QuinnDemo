//
//  VideoOperationManager.swift
//  ThreeDSwing
//
//  Created by 孙凡 on 16/9/19.
//  Copyright © 2016年 Xhey. All rights reserved.
//

import Foundation
class VideoOperationManager {
    static let sharedInstance = VideoOperationManager()

    private let decodeQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private init() {}
    
    func startDecode(forModel: FrameReaderModelProtocol, andDelegate: FrameReaderDelegate?, cancelOtherOpertaions: Bool) -> Operation {
        if cancelOtherOpertaions {
           decodeQueue.cancelAllOperations()
        }
        let operation: Operation
        if forModel.isDecodeFinished {
            let reader = FrameFileReader(forModel: forModel)
            reader.delegate = andDelegate
            operation = reader
        } else {
            let model = FrameDecodeModel(forId:forModel.id, andVideoFile: forModel.inputUrl, andFramesCount: forModel.framesCount, andOutputURL: forModel.outputUrl)
            let reader = FrameDecoder(forModel: model)
            reader.delegate = andDelegate
            operation = reader
        }
        decodeQueue.addOperation(operation)
        return operation
    }
    
    func cancelAll() {
        decodeQueue.cancelAllOperations()
    }
}
