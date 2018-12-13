//
//  ViewController.swift
//  音频分段裁剪
//
//  Created by Quinn on 2018/11/23.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit
import CoreMedia
class ViewController: UIViewController {

    var cutTools:MMBAudioCut?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let path = Bundle.main.path(forResource: "任素汐 - 我要你", ofType: ".mp3") else {
            return
        }
        let url = URL.init(fileURLWithPath: path, isDirectory: true)
        cutTools =  try? MMBAudioCut.init(url: url)
        //信号量控制 防止一个操作未完成另一个操作已经开始
        let semaphoreSignal = DispatchSemaphore(value: 1)
        (0...5).forEach { (i) in
            let start = 5*i
            let end = 10*i + 5
            semaphoreSignal.wait()
            cutTools?.exportAudio(start: Double(start), end: Double(end), destinationURL: getAudioExportURL(number: i), completeHandle: { (output,error)  in
                print(error)
                print(output.path)
                print("\n\n")
                semaphoreSignal.signal()
            })
        }

    }

    //获取destination url
    func getAudioExportURL(number:Int)->URL{
        let path =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "Quinn_export_\(number)" + ".m4a"
        let url = path.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: url.path){
            try? FileManager.default.removeItem(at: url)
        }
        print("quinn",url)
        return url
    }
    

}

