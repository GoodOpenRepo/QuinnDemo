//
//  AlbumPreviewDataPovider.swift
//  PhotoCollection(相簿)
//
//  Created by Quinn on 2018/10/8.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit
import Photos

class AlbumPreviewDataPovider: NSObject {
    
    var fetchVideos: PHFetchResult<PHAsset>?
    
    func createPhotosData(completed:@escaping ()->()) {
        PhotoMaker.default()?.requestPhotosPermision({ (error) in
            self.fetchVideos = PhotoMaker.default()?.getALLphotos(usingPohotKit: true)
            completed()
        })
    }
    
    
    
    
}
