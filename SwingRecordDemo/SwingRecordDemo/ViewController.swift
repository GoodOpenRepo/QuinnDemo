//
//  ViewController.swift
//  SwingRecordDemo
//
//  Created by Quinn on 2019/1/24.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let input = Bundle.main.path(forResource: "1551425248084953", ofType: "MOV")
        let inputURL = URL.init(fileURLWithPath: input!)
        
        let userDirectory = FileManager.default.urls(for: .allLibrariesDirectory, in: .userDomainMask).first
        let outputURL = userDirectory!.appendingPathComponent("swingPic")
        if FileManager.default.fileExists(atPath: outputURL.path){
            try? FileManager.default.removeItem(at: outputURL)
        }
        try! FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
        
        let model = FrameReaderModel.init(id: "0", inputUrl: inputURL, outputUrl: outputURL, framesCount: 75)
        let _ = VideoOperationManager.sharedInstance.startDecode(forModel: model, andDelegate: self, cancelOtherOpertaions: true)
    }


}


extension ViewController:FrameReaderDelegate{
    func frameReader(_: FrameReaderProtocol, finishedSaveImageFilesWithCount: Int, forModel: FrameReaderModelProtocol) {
        print("保存完毕")
    }
}
