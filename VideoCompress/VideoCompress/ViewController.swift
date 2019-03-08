//
//  ViewController.swift
//  VideoCompress
//
//  Created by Quinn on 2019/3/8.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit
import VideoToolbox
class ViewController: UIViewController {

    var exportHelper = XHExportVideoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        exportVideo()
    }
    
    func exportVideo(){
        let resource = Bundle.main.path(forResource: "1551171738863895", ofType: "MOV")
        let url = URL(fileURLWithPath: resource!, isDirectory: true)
        let asset = AVURLAsset.init(url: url)
        let floder = FileManager.default.urls(for: .allLibrariesDirectory, in: .userDomainMask).first!
        let time = Date().timeIntervalSince1970
        let output = floder.appendingPathComponent("outputURL\(time).mov")
    
        print(output.path)
        if FileManager.default.isExecutableFile(atPath: output.path) {
            try? FileManager.default.removeItem(atPath: output.path)
        }
        exportHelper.export(asset, withOutput: output) { status in
            
        }
    }

}

