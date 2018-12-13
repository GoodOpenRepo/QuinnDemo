//
//  ViewController.swift
//  CustomBabyChooseViewController
//
//  Created by Quinn on 2018/10/26.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var customBabyChooseViewController:CustomBabyChooseViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func configureCustomBabyChooseViewController(){
        customBabyChooseViewController = CustomBabyChooseViewController()
        customBabyChooseViewController?.delegate = self
        customBabyChooseViewController?.view.frame = view.bounds
        customBabyChooseViewController?.sticker = UIView()
        //        customBabyChooseViewController?.showType = showType
        view.addSubview(customBabyChooseViewController!.view)
        customBabyChooseViewController?.animationBegin()
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if view.subviews.count == 0{
            configureCustomBabyChooseViewController()
        }
    }

}

extension ViewController:CustomBabyChooseViewControllerDelegate{
    func CustomBabyChooseViewControllerDelegateClickCancle() {
        
    }
    
    func CustomBabyChooseViewControllerDelegateClickSure(sticker: UIView?) {
        
    }
    
    
}
