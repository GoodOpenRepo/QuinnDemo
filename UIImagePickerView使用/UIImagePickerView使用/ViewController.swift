//
//  ViewController.swift
//  UIImagePickerView使用
//
//  Created by Quinn on 2018/11/23.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    func getImageByImagePickerView(){
        let vc = UIImagePickerController()
        vc.allowsEditing = true
        vc.sourceType = .photoLibrary
        vc.delegate = self
        self.present(vc, animated: true) {
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        getImageByImagePickerView()
    }

}

extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let img = info[.editedImage] as? UIImage{
            self.view.backgroundColor = UIColor.init(patternImage: img)
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("cancle")
    }
    
}
