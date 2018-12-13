//
//  CustomBabyChooseCollectionFlowLayout.swift
//  CustomBabyChooseViewController
//
//  Created by Quinn on 2018/10/26.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class CustomBabyChooseCollectionFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        setupSelf()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSelf()
    }
    
    func setupSelf(){
        itemSize = CGSize.init(width: 240, height: 110)
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }

}
