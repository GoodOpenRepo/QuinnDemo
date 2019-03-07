//
//  PlayViewController.swift
//  SwayingImgPlayDemo
//
//  Created by Quinn on 2019/1/24.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit
import AVFoundation
class PlayViewController: UIViewController {
    fileprivate let musicURL = Bundle.main.url(forResource: "login_back_music", withExtension: "mp3")!
    fileprivate var playerController: SwingPlayer?
    var swingImageView      : UIImageView!
    fileprivate var rotateView: SwingRotateBarView!
    fileprivate var framesNum: Int = 0
    fileprivate var player:AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBackImages()
        playMP3()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
        player = nil
    }
    
    private func playMP3(){
        player = AVPlayer(url: musicURL)
        player?.play()
    }
    
    
    fileprivate func setupUI() {
        
        swingImageView = UIImageView(frame: UIScreen.main.bounds)
        self.view.addSubview(swingImageView)

        rotateView = SwingRotateBarView()
        rotateView.hiddenRoll(false)
        view.addSubview(rotateView)
        rotateView.direction = .fromLeft
        rotateView.cellType = .homePageType
        rotateView.y = 607 * HEIGHT_SCALE
        rotateView.updateFrame()
        
    }
    
    
    func loadBackImages() {
        
        playerController = SwingPlayer(direction: SwingDirection.fromLeft, swingImageView: swingImageView)
        playerController?.playable = self
        
        let bundleURL = Bundle.main.url(forResource: "swingPic", withExtension: "bundle")
        
        if let bundleURL = bundleURL {
            
            let fm = FileManager.default
            let imageArray = try? fm.contentsOfDirectory(atPath: bundleURL.path).sorted()
            framesNum = imageArray?.count ?? 0
            DispatchQueue.global().async {
                
                for (index, fileRelPath) in imageArray!.enumerated() {
                    print(fileRelPath)
                    let imagePath = bundleURL.appendingPathComponent(fileRelPath).path
                    let imageData = try! Data(contentsOf: bundleURL.appendingPathComponent(fileRelPath))
                    
                    DispatchQueue.main.async {[weak self] in
                        
                        self?.playerController?.loadSwingData(imageData, localPath:imagePath, index: index)
                        self?.rotateView.progress = CGFloat(index)/CGFloat(imageArray!.count)
                        
                    }
                }
                
                DispatchQueue.main.async {[weak self] in
                    self?.rotateView.setRotateProgress(progress: 0.0, frames: (self?.framesNum)!)
                }
            }
        }
    }
    

}
extension PlayViewController : SwingPlayable {
    
    func playProcess(_ playerInstance: SwingPlayer, Process process: Double, Frames frames: Int) {
        
        rotateView.setRotateProgress(progress: CGFloat(process), frames: frames)
        if process >= 0.5 {
            print("progress more than 0.5")
        }
        
    }
    
}

