
//
//  FrameReader.swift
//  ThreeDSwing
//
//  Created by BingBing on 17/1/11.
//  Copyright © 2017年 Xhey. All rights reserved.
//

import Foundation
class FrameReader: Operation, FrameReaderProtocol {
    
    weak var delegate: FrameReaderDelegate? {
        didSet {
            switch _from {
            case .Decoder:
                _decoder?.delegate = delegate
            case .File:
                _fileReader?.delegate = delegate
            }
        }
    }
    
    var delegateQueue: OperationQueue = OperationQueue.main {
        didSet {
            switch _from {
            case .Decoder:
                _decoder?.delegateQueue = delegateQueue
            case .File:
                _fileReader?.delegateQueue = delegateQueue
            }
        }
    }
    
    override var isAsynchronous: Bool {
        return _operation.isAsynchronous
    }
    
    var model: FrameReaderModelProtocol {
        return _model
    }
    
    private enum From {
        case File
        case Decoder
    }
    
    private let _model: FrameReaderModelProtocol
    
    private var _from: From
    
    private var _decoder: FrameDecoder?
    private var _fileReader: FrameFileReader?
    
    private var _operation: Operation
    
    private var _isFinished: Bool = false
    private var _isExecuting: Bool = false
    
    private var _context = 0
    
    var saveToFile: Bool = true {
        didSet {
            _decoder?.saveToFile = saveToFile
        }
    }
    
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

    
    init(forModel model: FrameReaderModelProtocol) {
        _model = model
        if _model.isDecodeFinished {
            _from = .File
            let fileReader = FrameFileReader(forModel: _model)
            fileReader.delegate = delegate
            fileReader.delegateQueue = delegateQueue
            _operation = fileReader
            _fileReader = fileReader
        } else {
            _from = .Decoder
            let decodeModel = FrameDecodeModel(forId:_model.id, andVideoFile: _model.inputUrl, andFramesCount: _model.framesCount, andOutputURL: _model.outputUrl)
            let decoder = FrameDecoder(forModel: decodeModel)
            decoder.delegateQueue = delegateQueue
            decoder.delegate = delegate
            _operation = decoder
            _decoder = decoder
        }
        super.init()
        _operation.addObserver(self, forKeyPath: "isExecuting", options: .new, context: &_context)
        _operation.addObserver(self, forKeyPath: "isFinished", options: .new, context: &_context)
    }
    
    override func main() {
        _operation.start()
    }
    
    override func cancel() {
        _operation.cancel()
        super.cancel()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &_context {
            if let newValue = change?[NSKeyValueChangeKey.newKey] as? Bool {
                if let path = keyPath {
                    if path == "isExecuting" {
                        isExecuting = newValue
                    } else if path == "isFinished" {
                        isFinished = newValue
                    }
                }
            }
            
        }
    }
    
    deinit {
        _operation.removeObserver(self, forKeyPath: "isExecuting", context: &_context)
        _operation.removeObserver(self, forKeyPath: "isFinished", context: &_context)
        print("任务结束")
    }
}
