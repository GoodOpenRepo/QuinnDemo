//
//  SwingImageProvider.swift
//  ThreeDSwing
//
//  Created by BingBing on 2017/6/3.
//  Copyright © 2017年 Xhey. All rights reserved.
//

import Foundation
import UIKit
class SwingImageProvider {
    let cacheQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "swing_player_dataCache_queue"
        return queue
    }()
    
    var swingDataPaths: [String] = []

    private let dataCache: NSCache<NSString, NSData>
    private let imageCache: NSCache<NSString, UIImage>
    
    init() {
        dataCache = NSCache<NSString, NSData>()
        dataCache.countLimit = 200
        imageCache = NSCache<NSString, UIImage>()
        imageCache.countLimit = 20
    }

    func loadSwingData(_ data: Data, localPath: String, index: Int = 0) {
        swingDataPaths.append(localPath)
        dataCache.setObject(data as NSData, forKey: localPath as NSString, cost: 1)
    }
    
    func image(forIndex index: Int) -> UIImage? {
        var myIndex = index - 3
        if myIndex <= 0 {
            myIndex = 0
        }
        
        if swingDataPaths.count == 0 || myIndex >= swingDataPaths.count {
            return nil
        }
        
        var image: UIImage? = nil
        let imagePath = swingDataPaths[myIndex] as String
        image = imageCache.object(forKey: imagePath as NSString)
        
        if image == nil {
            if let imageData = dataCache.object(forKey: imagePath as NSString) {
                image = UIImage(data:imageData as Data,scale:1.0)
            } else {
                guard let img = UIImage(contentsOfFile: imagePath) else {
                    return nil
                }
                guard let imgTempData = try? Data(contentsOf: URL(fileURLWithPath: imagePath)) else {
                    return nil
                }
                let imgData = imgTempData as NSData
                image = img
                cacheQueue.addOperation({[weak self] in
                    self?.dataCache.setObject(imgData, forKey:imagePath as NSString, cost: 1)
                })
            }
            guard let img = image else { return nil }
            cacheQueue.addOperation({[weak self] in
                self?.imageCache.setObject(img, forKey:imagePath as NSString, cost: 1)
            })
        }
        
        return image
    }
    
    func release() {
        dataCache.removeAllObjects()
        imageCache.removeAllObjects()

    }
    
    deinit {
        release()
        swingDataPaths.removeAll()
    }
    
    
}
