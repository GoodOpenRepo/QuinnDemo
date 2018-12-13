//
//  ViewController.swift
//  ImageInfoWriting
//
//  Created by Quinn on 2018/10/17.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit
import CoreImage
class ViewController: UIViewController {

    
//    var metaData: Metadata?

    var imageTool:GetImageInfoTool? = GetImageInfoTool()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadImage()
    }
    
    
    func loadImage(){
        
        let path = Bundle.main.path(forResource: "666", ofType: "jpg")
        let img = UIImage.init(contentsOfFile: path!)
        let url_0 = NSURL.fileURL(withPath:path!)

        imageTool?.getImageExifInfo(by: img!)
        imageTool?.getImageexifAndGPSInfo(url_0)
        
        //exif
        let exifContainer = ExifContainer()
        exifContainer.addMakeInfo("QuinnMade")
        exifContainer.addModelInfo("quinnmodel")
        exifContainer.addSoftwareInfo("XCamera")

        //add exif
        let data = img?.addExif(exifContainer)
        //write to url
        let url = NSURL.fileURL(withPath: NSTemporaryDirectory() + "666" + ".jpg")
        try? FileManager.default.removeItem(at: url)
        try? data?.write(to: url)
        print(url)

        let qimage = UIImage.init(contentsOfFile: url.path)

        imageTool?.getImageExifInfo(by: qimage!)
        imageTool?.getImageexifAndGPSInfo(url)


    }


}
