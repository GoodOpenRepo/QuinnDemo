//
//  FrameDecoderDelegate.swift
//  ThreeDSwing
//
//  Created by BingBing on 17/1/10.
//  Copyright © 2017年 Xhey. All rights reserved.
//

import Foundation

protocol FrameReaderDelegate: class {
    func frameReader(_ : FrameReaderProtocol, startForModel: FrameReaderModelProtocol)
    func frameReader(_ : FrameReaderProtocol, gotData: Data, localPath: String, ofIndex: Int, forModel: FrameReaderModelProtocol)
    func frameReader(_ : FrameReaderProtocol, canceledForModel: FrameReaderModelProtocol)
    func frameReader(_ : FrameReaderProtocol, finishedReadImagesWithImagesCount: Int, forModel: FrameReaderModelProtocol)
    func frameReader(_ : FrameReaderProtocol, getError: Error?, forModel: FrameReaderModelProtocol)
    func frameReader(_ : FrameReaderProtocol, finishedSaveImageFilesWithCount: Int, forModel: FrameReaderModelProtocol)
}

extension FrameReaderDelegate {
    func frameReader(_ : FrameReaderProtocol, startForModel: FrameReaderModelProtocol) {}
     func frameReader(_ : FrameReaderProtocol, gotData: Data, localPath: String, ofIndex: Int, forModel: FrameReaderModelProtocol) {}
    func frameReader(_ : FrameReaderProtocol, canceledForModel: FrameReaderModelProtocol) {}
    func frameReader(_ : FrameReaderProtocol, finishedReadImagesWithImagesCount: Int, forModel: FrameReaderModelProtocol) {}
    func frameReader(_ : FrameReaderProtocol, getError: Error?, forModel: FrameReaderModelProtocol) {}
    func frameReader(_ : FrameReaderProtocol, finishedSaveImageFilesWithCount: Int, forModel: FrameReaderModelProtocol) {}

}
