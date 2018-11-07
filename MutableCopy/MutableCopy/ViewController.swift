//
//  ViewController.swift
//  MutableCopy
//
//  Created by Quinn on 2018/11/2.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let img = UIImage.init(named: "16.jpg"){
            print("had img")
            saveBaby(result: img)

        }
    }
    func saveBaby(result:UIImage){
        if let img = result.mutableCopy() as? UIImage{
            UIImageWriteToSavedPhotosAlbum(result, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)

        }else{
            print("mutableCopy error")
        }
        

    }

    @objc func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if let _error = error {
            let desc = _error.localizedDescription
            let reason = _error.localizedFailureReason
            let suggestion = _error.localizedRecoverySuggestion
            let info = "描述：\(desc)\n" + "原因：\(reason)\n" + "建议：\(suggestion)\n"
            print(info)
            
        }else{
           
            print("ok")

        }
        
        
    }
}

extension UIImage:NSCopying{
    public func copy(with zone: NSZone? = nil) -> Any {
         return type(of: self).init(name: self.name)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return type(of: self).init(name: self.name)
    }
    
    func deepCopy(){
        
    }
}
