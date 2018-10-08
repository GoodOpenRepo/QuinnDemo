//
//  AlbumPreviewController.swift
//  PhotoCollection(相簿)
//
//  Created by Quinn on 2018/10/8.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class AlbumPreviewController: UIViewController {
    
    
    
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var backBt: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var albumPreviewDataPovider:AlbumPreviewDataPovider?
    
    @IBOutlet weak var changeStateBT: UIButton!
    
    @IBAction func changeState(_ sender: UIButton) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            self.changeStateToPhotos()
        case .denied:
            self.changeStateToSetting()
        case .notDetermined:
            self.changeStateToPhotos()
        case .restricted:
            self.changeStateToPhotos()
            
        }
    }
}

extension AlbumPreviewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
             changeStateToPhotos()
        case .denied:
             changeStateToSetting()
        default:
            break
        }
    }
    
    func creatData(){
        albumPreviewDataPovider = AlbumPreviewDataPovider()
        albumPreviewDataPovider?.createPhotosData(completed: {[weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        })
    }

}

//MARK: action
extension AlbumPreviewController{

    
    func changeStateToPhotos(){
        creatData()
    }
    func changeStateToSetting(){
        
        //            let url = URL.init(string: UIApplicationOpenSettingsURLString)
        //            UIApplication.shared.open(url!, options: [:]) { (bSuccess) in
        //            }
        
    }
}

extension AlbumPreviewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumPreViewCell", for: indexPath) as! AlbumPreViewCell
        cell.resetPHAsset(albumPreviewDataPovider?.fetchVideos?.object(at: indexPath.row))
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumPreviewDataPovider?.fetchVideos?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let asset = albumPreviewDataPovider?.fetchVideos?.object(at: indexPath.item) else{
            return
        }
        
        guard let cell = collectionView.cellForItem(at:indexPath) as? AlbumPreViewCell else {
            return
        }
        self.view.isUserInteractionEnabled = false
        cell.showActivityView()
        
        if asset.mediaType == .image{
            getOriginalImage(asset: asset) { (error, asset, image) in
                self.view.isUserInteractionEnabled = true
                cell.stopActivityView()
                
                //ToDo
                //save image and jump
                print("get image",image)
            }
        }
        if asset.mediaType == .video{
            getOriginalVideo(videoAsset: asset) { (error, asset, url) in
                //                XHProgressControllerView.shared.dissmiss(false)
                self.view.isUserInteractionEnabled = true
                cell.stopActivityView()
                
                print("get video",url)
                
                //                let info = createVideoInfo(videoFile: videoPath)
                //                info.video_from = .album
                //                self.videoInfo = info
                //
                //                self.templateCenter = nil
                //                if videoPath != nil {
                //                    XReport.loadVideoFromCameraRoll(videoPath!)
                //                    self.toPreView()
                //                }
                
                //ToDo
                //jump
            }
        }
    }
    
    func getOriginalImage(asset:PHAsset, completed:@escaping (_ error:Error?, _ asset:PHAsset, _ img:UIImage?)->()){
        PhotoMaker.default().getPhotoWithAsset(asset, completion: { (img, _, isDegraded) in
            if let image = img {
                if !isDegraded{
                    completed(nil,asset,image)
                }
            }else{
                completed(nil,asset,nil)
            }
        }, progressHandler: { (_, _, _, _) in
            
        }, networkAccessAllowed: true)
    }
    
    func getOriginalVideo(videoAsset:PHAsset, completed:@escaping (_ error:Error?, _ asset:PHAsset, _ videoURL:URL?)->()){
        var isFirst = true
        
        let option = PHVideoRequestOptions()
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .highQualityFormat
        option.version = .original
        
        option.progressHandler = { progress,_,_,info in
            DispatchQueue.main.async {
                //                if isFirst{
                //                    XHProgressControllerView.shared.showProgress("正在从iCloud下载该视频") {[weak self] (canceled, success) in}
                //                    isFirst = false
                //                }
                //                XHProgressControllerView.shared.changeProgress(Float(progress))
            }
        }
        
        PHImageManager.default().requestAVAsset(forVideo: videoAsset, options:option,resultHandler:{ asset, _, info in
            DispatchQueue.main.async {
                func errorReturn(){
                    self.view.isUserInteractionEnabled = true
                    self.showErrMessage("视频内容无法解析")
                    completed(nil,videoAsset,nil)
                    return
                }
                guard let _ = asset else{
                    errorReturn()
                    return
                }
                guard let strMessage = info?["PHImageFileSandboxExtensionTokenKey"] as? String else{
                    errorReturn()
                    return
                }
                
                guard let path = strMessage.components(separatedBy: ";").last else{
                    errorReturn()
                    return
                }
                let videoURL = URL(fileURLWithPath: path)
                completed(nil,videoAsset,videoURL)
            }
        })
    }
    
    
    func showErrMessage(_ message:String){
        //        DispatchQueue.main.async {
        //            SVProgressHUD.showError(withStatus: message)
        //            SVProgressHUD.dismiss(withDelay: 0.5)
        //        }
    }
    
}
