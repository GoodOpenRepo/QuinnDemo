//
//  FrameFileReader.swift
//  ThreeDSwing
//
//  Created by BingBing on 17/1/11.
//  Copyright © 2017年 Xhey. All rights reserved.
//

import Foundation

class FrameFileReader: Operation, FrameReaderProtocol {
    
    weak var delegate: FrameReaderDelegate?
    
    var delegateQueue: OperationQueue = OperationQueue.main
    
    var model: FrameReaderModelProtocol {
        return _model
    }
    
    private let _model: FrameReaderModelProtocol
    private var _decodeImageCount = 0
    
    private var _decoder: FrameDecoder?
    
    init(forModel model: FrameReaderModelProtocol) {
        _model = model
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _isFinished: Bool = false
    private var _isExecuting: Bool = false
    
    private var _isCacnelled: Bool = false
    
    private let _cancellLock = NSLock()
    
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
    
    override func main() {
        if let _delegate = delegate {
            delegateQueue.addOperation {
                _delegate.frameReader(self, startForModel: self._model)
            }
        }
        
        _decodeImageCount = 0
        
        let fm = FileManager.default
        let filesURL = _model.outputUrl
        
        if fm.fileExists(atPath: filesURL.path) {
            if let fileNames = try? fm.contentsOfDirectory(atPath: filesURL.path).sorted(), fileNames.count > 0 {
                for fileName in fileNames {
                    let imageURL = filesURL.appendingPathComponent(fileName)
                    
                    guard let imageData = try? Data(contentsOf: imageURL) else {
                        continue
                    }
                    
                    _cancellLock.lock()
                    if _isCacnelled {
                        _cancellLock.unlock()
                        return
                    }
                    if let _delegate = delegate {
                        delegateQueue.addOperation {
                            _delegate.frameReader(self, gotData:imageData, localPath:imageURL.path, ofIndex:self._decodeImageCount, forModel: self._model)
                            self._decodeImageCount += 1
                        }
                    }
                    _cancellLock.unlock()

                }
                _cancellLock.lock()
                if _isCacnelled {
                    _cancellLock.unlock()
                    return
                }
                if let _delegate = delegate {
                    delegateQueue.addOperation {
                        self.isFinished = true
                        self.isExecuting = false
                        _delegate.frameReader(self, finishedReadImagesWithImagesCount: self._decodeImageCount, forModel: self._model)
                    }
                }
                _cancellLock.unlock()
            }
        }
    }
    
    override func cancel() {
        _cancellLock.lock()
        _isCacnelled = true
        _cancellLock.unlock()
        isFinished = true
        isExecuting = false
        if let _delegate = delegate {
            delegateQueue.addOperation {
                _delegate.frameReader(self, canceledForModel: self._model)
            }
        }
        super.cancel()
    }
    
    deinit {
        print("FrameFileReader 死掉了")
    }
}
