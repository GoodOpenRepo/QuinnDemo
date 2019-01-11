//
//  ViewController.swift
//  CIImage马赛克
//
//  Created by Quinn on 2018/12/26.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit
import CoreImage
class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    let aNamed = UIImage(named: "pixellateImage.jpg")!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageView.image = getMosaicImage(image: aNamed, scale: 40.5)
    }

    @IBAction func valueChanged(_ sender: UISlider) {

        imageView.image = getMosaicImage(image: aNamed, scale: 1)
    }
    
    
    
}





















func getMosaicImage(image:UIImage,scale:Float)->UIImage{
    let filter = CIFilter(name: "CIPixellate")!
    let ciImage = CIImage(image: image)
    filter.setValue(ciImage, forKey: kCIInputImageKey)
    filter.setValue(scale, forKey: kCIInputScaleKey) //值越大马赛克就越大
    let fullPixellatedImage = filter.outputImage
    let context = CIContext(options: nil)
    let cgImage = context.createCGImage(fullPixellatedImage!, from: fullPixellatedImage!.extent)
    return UIImage(cgImage: cgImage!)
}
