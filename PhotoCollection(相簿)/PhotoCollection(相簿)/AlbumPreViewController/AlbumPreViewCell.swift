//
//  AlbumPreViewCell.swift
//  PhotoCollection(相簿)
//
//  Created by Quinn on 2018/10/8.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class AlbumPreViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var activityBGView: UIView!
    
    private var assetPHAsset : PHAsset?
    private var requestID : PHImageRequestID? = nil

    func resetPHAsset(_ assetPHAsset:PHAsset?){
        guard let assetPHAsset = assetPHAsset else{
            return
        }
        if(self.assetPHAsset===assetPHAsset){
            return
        }
        self.assetPHAsset = assetPHAsset

        //duration
        let duration : UInt = UInt(self.assetPHAsset!.duration)
        self.durationLabel?.text = String.init(format: "%02d:%02d", duration/60,duration%60)

        //thumbImage
        if(self.requestID != nil){
            PHImageManager.default().cancelImageRequest(self.requestID!)
        }
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .opportunistic
        let thumbWidth = self.thumbImageView.bounds.size.width * UIScreen.main.scale
        let thumbSize = CGSize(width: thumbWidth, height: thumbWidth)
        self.requestID = PHImageManager.default().requestImage(for: self.assetPHAsset!, targetSize: thumbSize, contentMode: .aspectFit, options: option) { image, _ in

            DispatchQueue.main.async {[weak self] in
                self?.thumbImageView?.image = image
                self?.thumbImageView.contentMode = .scaleAspectFill
            }
        }
        
    }
    
    func showActivityView() {
        activityBGView.isHidden = false
        activityView.startAnimating()
    }
    func stopActivityView() {
        activityBGView.isHidden = true
        activityView.stopAnimating()
    }
    
    
}
