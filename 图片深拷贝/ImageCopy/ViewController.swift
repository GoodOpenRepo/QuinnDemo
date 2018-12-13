//
//  ViewController.swift
//  ImageCopy
//
//  Created by Quinn on 2018/11/12.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var img:UIImage?
    var img2:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        img = UIImage.init(named: "2")
        print("1")
        
//        let img3 = UIImage.copy(img!)
//
//        guard let cgimage = img?.cgImage else{
//            return
//        }
//        let newCgIm = CGImageMetadataCreateMutableCopy(cgimage as! CGImageMetadata)
//
//
//        let newImage = UIImage(CGImage: newCgIm, scale: imageView.image!.scale, orientation: imageView.image!.imageOrientation)
//
//
        guard let imgData = img?.pngData() else {
            return
        }
        //  指针拷贝
        let _img2 = UIImage.init(data: imgData)
        
        
        //  指针拷贝
        let _img3 = UIImage.init(cgImage: img!.cgImage!)
        
        //值拷贝
//        guard let _img2 = img?.mutableCopy() as? UIImage else{
//            return
//        }
//        img2 = _img2
        print("2")
        
        
        
        
    }


}

