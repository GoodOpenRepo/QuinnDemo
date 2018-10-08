//
//  AlbumPreviewCollectionFlowLayout.swift
//  PhotoCollection(相簿)
//
//  Created by Quinn on 2018/10/8.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class AlbumPreviewCollectionFlowLayout: UICollectionViewFlowLayout {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if Screen_2_1(){
            minimumLineSpacing = 14 * HEIGHT_SCALE
            minimumInteritemSpacing =  8 * WIDTH_SCALE
            sectionInset = .init(top: 0, left: 14*WIDTH_SCALE, bottom: 0, right: 14*WIDTH_SCALE)
            itemSize = .init(width: 108*WIDTH_SCALE, height: 108*WIDTH_SCALE)
        }else{
            minimumLineSpacing = 14 * HEIGHT_SCALE
            minimumInteritemSpacing =  8 * WIDTH_SCALE
            sectionInset = .init(top: 0, left: 14*WIDTH_SCALE, bottom: 0, right: 14*WIDTH_SCALE)
            itemSize = .init(width: 108*WIDTH_SCALE, height: 108*WIDTH_SCALE)
        }
       
        scrollDirection = .vertical
    }
}
