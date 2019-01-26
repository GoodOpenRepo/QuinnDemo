//
//  FrameReaderProtocol.swift
//  ThreeDSwing
//
//  Created by BingBing on 17/1/11.
//  Copyright © 2017年 Xhey. All rights reserved.
//

import Foundation
protocol FrameReaderProtocol {
    var delegate: FrameReaderDelegate? { get set }
    
    var model: FrameReaderModelProtocol { get }
    
    func start()
    
    func cancel()
}
