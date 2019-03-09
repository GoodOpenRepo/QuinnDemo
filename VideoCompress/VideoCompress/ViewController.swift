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
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    let floder = FileManager.default.urls(for: .allLibrariesDirectory, in: .userDomainMask).first!
    
//    let floder = URL.init(fileURLWithPath: "/Users/quinn/Documents/GitHub/QuinnDemo/VideoCompress/VideoCompress/images")

    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView1.image = UIImage(named: "9.jpg")

        
    }

    func saveImage(img:UIImage){
//        let image = UIImage(named: "9.jpg")!
        let image = img
        
        imageView2.image = XHImageCrophelper.thumbnail(with: image, size: CGSize(width: 500, height: 500))
        
        let uuid = NSUUID().uuidString
        let new_file = floder.appendingPathComponent("\(uuid).jpg")
        if let data = image.pngData(){
            do{
                try data.write(to: new_file)
            }catch{
                print(error)
            }
           
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        exportVideo()
        
    }
    
    func exportVideo(){
        let resource = Bundle.main.path(forResource: "1551171738863895", ofType: "MOV")
        let url = URL(fileURLWithPath: resource!, isDirectory: true)
        let asset = AVURLAsset.init(url: url)

        let uuid = NSUUID().uuidString
        let output = floder.appendingPathComponent("\(uuid).mov")
    
        print(output.path)
        if FileManager.default.isExecutableFile(atPath: output.path) {
            try? FileManager.default.removeItem(atPath: output.path)
        }
        exportHelper.imageBlock = { [weak self] img in
            if img != nil{
                DispatchQueue.main.async {
                    self?.saveImage(img: img!)
                }
            }
        }
        exportHelper.export(asset, withOutput: output) { status in
            
        }
        
    }

}

