//
//  FrameDecoder.swift
//  ThreeDSwing
//
//  Created by BingBing on 17/1/10.
//  Copyright © 2017年 Xhey. All rights reserved.
//

import Foundation

class FrameDecoder: Operation, BufferReaderDelegate, FrameReaderProtocol {
    
    weak var delegate: FrameReaderDelegate?
    
    var delegateQueue: OperationQueue = OperationQueue.main
    
    var model: FrameReaderModelProtocol {
        return _model
    }
    
    enum Status: Equatable {
        case None
        case Running
        case Cancelled
        case FinishedDecode
        case FinishedSave(frameCount: Int)
        case Error(error: Error?)
        
        public static func ==(lhs: Status, rhs: Status) -> Bool {
            switch (lhs, rhs) {
            case (.None, .None),
                 (.Running, .Running),
                 (.Cancelled, .Cancelled),
                 (.FinishedDecode, .FinishedDecode),
                 (.FinishedSave, .FinishedSave),
                 (.Error, .Error):
                return true
            default:
                return false
            }
        }
    }
    
    static var fileSaveQueue: OperationQueue = {
        let queue = OperationQueue()
        let dispatchQueue = DispatchQueue(label: "com.xhey.threedswing.filewriter")
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .background
        queue.underlyingQueue = dispatchQueue
        return queue
    }()
    
    private let _model: FrameDecoderModelProtocol
    private var _decodeImageCount = 0
    private var _savedFileCount = 0
    private var _frameIndex = -1
    private var _bufferReader: BufferReader?
    
    private var _isFinished: Bool = false
    private var _isExecuting: Bool = false
    
    private let _frameCounter: FrameCounter
    
    var saveToFile: Bool = true
    
    private let cancelLock = NSLock()
    
    override var isExecuting: Bool {
        get {
            return _isExecuting
        }
        
        set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isFinished: Bool {
        get {
            return _isFinished
        }
        
        set {
            willChangeValue(forKey: "isFinished")
            _isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    private var _currentStatus: Status {
        didSet {
            switch _currentStatus {
            case .Running:
                isExecuting = true
            case .Error, .Cancelled, .FinishedSave :
                isExecuting = false
                isFinished = true
            default:
                break
            }
            if let _delegate = delegate {
                switch _currentStatus{
                case .Running:
                    delegateQueue.addOperation {
                        _delegate.frameReader(self, startForModel:self.model)
                    }
                case .FinishedSave(let frameCount):
                    delegateQueue.addOperation {
                        _delegate.frameReader(self, finishedSaveImageFilesWithCount: frameCount, forModel: self._model)
                    }
                case .Cancelled:
                    delegateQueue.addOperation {
                        _delegate.frameReader(self, canceledForModel: self._model)
                    }
                case .FinishedDecode:
                    delegateQueue.addOperation {
                        _delegate.frameReader(self, finishedReadImagesWithImagesCount: self._decodeImageCount, forModel: self._model)
                    }
                case .Error(let error):
                    delegateQueue.addOperation {
                        _delegate.frameReader(self, getError: error, forModel: self._model)
                    }
                default: break
                }
            }
            
        }
    }
    
//    override var isFinished: Bool {
//        print("frame decoder isFinished: \(_currentStatus)")
//        switch _currentStatus {
//        case .Error, .FinishedSave, .Cancelled:
//            print("frame decoder isFinished: \(true)")
//            return true
//        default:
//            print("frame decoder isFinished: \(false)")
//            return false
//        }
//    }
//    
//    override var isExecuting: Bool {
//        switch _currentStatus {
//        case .Running, .FinishedDecode:
//            return true
//        default:
//            return false
//        }
//    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    init(forModel model: FrameDecoderModelProtocol) {
        _model = model
        _currentStatus = .None
        _frameCounter = FrameCounter(targetFramesNumber: _model.targetFramesCount, totalFramesNumber: _model.framesCount)
    }
    
    override func main() {
        assert(_currentStatus == .None, "decoder has started")
    
        _currentStatus = .Running
        
        if _model.isDecodeFinished {
            _currentStatus = .FinishedSave(frameCount: self._model.targetFramesCount)
            return
        }
        
        _bufferReader = BufferReader(delegate: self)
        let fm = FileManager.default
        if !fm.fileExists(atPath: _model.outputUrl.path) {
            do {
                try fm.createDirectory(at: _model.outputUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("LYG: create video folder failed")
            }
        }
        
        _savedFileCount = _model.savedImageCount
        _bufferReader?.startReading(_model.asset, error: nil)
    }

    override func cancel() {
        _bufferReader?.cancelReadingAsset()
        FrameDecoder.fileSaveQueue.cancelAllOperations()
        FrameDecoder.fileSaveQueue.waitUntilAllOperationsAreFinished()
        cancelLock.lock()
        _currentStatus = .Cancelled
        cancelLock.unlock()
        super.cancel()
    }
    
    func bufferReader(_ reader: BufferReader!, didFinishReading asset: AVAsset!) {
        if _currentStatus == .Cancelled { return }
        
        _currentStatus = .FinishedDecode
        
        if (_decodeImageCount == _savedFileCount || !saveToFile) {
            _currentStatus = .FinishedSave(frameCount: _savedFileCount)
        }
    }
    
    
    func bufferReader(_ reader: BufferReader!, didGetNextVideoSample bufferRef: CMSampleBuffer!) {
        if _currentStatus == .Cancelled {
            _bufferReader?.cancelReadingAsset()
            return
        }
        
        _frameIndex += 1
        
        if !_frameCounter.shouldTakeFrame(atIndex: _frameIndex) { return }
        
        _decodeImageCount += 1
        let index = _frameIndex
        let decodeIndex = _decodeImageCount - 1
        
        debugPrint("got image: \(decodeIndex)")
        var imageDataTemp: Data?
        autoreleasepool {
            guard let image = OCUtil.image(from: bufferRef) else {
                return
            }
            imageDataTemp = UIImageJPEGRepresentation(image, 0.4)
        }
        
        guard let imageData = imageDataTemp else {
            return
        }

        let imagePath = String(format: "%@/%@", _model.outputUrl.path, _model.pictureFileName(forIndex: index))

        cancelLock.lock()
        if _currentStatus == .Cancelled { return }
        if let _delegate = delegate {
            delegateQueue.addOperation {
                 _delegate.frameReader(self, gotData: imageData, localPath: imagePath, ofIndex: decodeIndex, forModel: self._model)
            }
        }
        cancelLock.unlock()
        
        if !saveToFile { return }
        
        FrameDecoder.fileSaveQueue.addOperation {[weak self] in
            guard let myself = self else { return }
            if myself._currentStatus == .Cancelled { return }

            let fm = FileManager.default
            let imagePath = String(format: "%@/%@", myself._model.outputUrl.path, myself._model.pictureFileName(forIndex: index))
            let imageURL = URL(fileURLWithPath: imagePath)
            
            var shouldSaveFile = true
            if index <= myself._savedFileCount - 1 {
                if fm.fileExists(atPath: imagePath) {
                    shouldSaveFile = false
                }
            } else {
                myself._savedFileCount += 1
                if fm.fileExists(atPath: imagePath) {
                    try? fm.removeItem(atPath: imagePath)
                }
            }
            
            if shouldSaveFile {
                do {
                   try imageData.write(to: imageURL, options: [.atomic])
                } catch  {
                    debugPrint("Edward debug write imageData error.")
                }
            }
            
            if myself._currentStatus == .FinishedDecode && myself._decodeImageCount == myself._savedFileCount {
                myself._currentStatus = .FinishedSave(frameCount: myself._savedFileCount)
            }
        }
    }
    
    func bufferReader(_ reader: BufferReader!, didGetErrorRedingSample error: Error!) {
        _currentStatus = .Error(error: error)
        FrameDecoder.fileSaveQueue.cancelAllOperations()
    }
    
    deinit {
        print("FrameDecoder 死掉了")
    }
}
