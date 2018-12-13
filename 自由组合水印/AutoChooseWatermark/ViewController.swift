//
//  ViewController.swift
//  AutoChooseWatermark
//
//  Created by Quinn on 2018/10/24.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var customCombinationChooseViewController:CustomCombinationChooseViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func configureCustomCombinationChooseViewController(){
        customCombinationChooseViewController = CustomCombinationChooseViewController()
        customCombinationChooseViewController?.delegate = self
        customCombinationChooseViewController?.view.frame = view.bounds
        customCombinationChooseViewController?.sticker = UIView()
//        customCombinationChooseViewController?.showType = showType
        view.addSubview(customCombinationChooseViewController!.view)
        customCombinationChooseViewController?.animationBegin()
    }



    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if view.subviews.count == 0{
            configureCustomCombinationChooseViewController()
        }
    }
}

extension ViewController:CustomCombinationChooseViewControllerDelegate{
    func CustomCombinationChooseViewControllerDelegateClickCancle() {
        
    }
    
    func CustomCombinationChooseViewControllerDelegateClickSure(sticker: UIView?) {
        
    }
    
    
}
