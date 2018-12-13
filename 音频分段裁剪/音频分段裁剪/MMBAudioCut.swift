//
//  MMBAudioCut.swift
//  音频分段裁剪
//
//  Created by Quinn on 2018/11/23.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit
import AVFoundation
class MMBAudioCut: NSObject {

    
    let asset:AVAsset
    let composition:AVMutableComposition = AVMutableComposition()
    var exportSession:AVAssetExportSession?
    init(url:URL) throws {
        asset = AVAsset.init(url: url)
        super.init()
        do{
            try cofigureComposition()
        }catch{
            throw(error)
        }
    }
    //配置容器 设置音轨以及
    private func cofigureComposition() throws{
        let audioTrack = asset.tracks(withMediaType: .audio)
        let firstTrack = audioTrack.first
        
        guard let track = firstTrack else {
            let error = NSError.init(domain: "audio track is nil", code: -1, userInfo: nil)
            throw(error)
        }
        if let audioCompisitionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: 0){
            do{
                try audioCompisitionTrack.insertTimeRange(track.timeRange, of: track, at: .zero)

            }catch{
                throw(error)
            }
        }
    }
    //导出 裁剪范围 audio
    func exportAudio(start:Double,end:Double,destinationURL: URL,completeHandle:@escaping (_ output:URL,_ error: Error?)->()){
        let _start = CMTime.init(value: CMTimeValue(start)*Int64(asset.duration.timescale), timescale: asset.duration.timescale)
        let _end = CMTime.init(value: CMTimeValue(end)*Int64(asset.duration.timescale), timescale: asset.duration.timescale)
        // presetNames 本视频支持导出的格式   AVAssetExportPresetPassthrough 为模拟器支持格式
        let presetNames = AVAssetExportSession.exportPresets(compatibleWith: asset)
        if presetNames.contains(AVAssetExportPresetAppleM4A) {
            exportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetAppleM4A)
            
        }else{
            exportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetPassthrough)
        }
        exportSession?.timeRange = CMTimeRange.init(start: _start, duration: _end)
        exportSession?.outputURL = destinationURL
        exportSession?.outputFileType = AVFileType.m4a
        exportSession?.shouldOptimizeForNetworkUse = true
        exportSession?.exportAsynchronously(completionHandler: {[weak self]in
            completeHandle(destinationURL,self?.exportSession?.error)
        })
    }
}
