//
//  ViewController.swift
//  PhotoCollection(相簿)
//
//  Created by Quinn on 2018/10/8.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}





func Screen_2_1()->Bool{
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    return CGFloat(width/height) <= 0.5
}


let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let WIDTH_SCALE:CGFloat = {
    if  Screen_2_1(){
        return UIScreen.main.bounds.size.width/375
        
    }else{
        return UIScreen.main.bounds.size.width/375
        
    }
}()

let HEIGHT_SCALE :CGFloat = {
    if  Screen_2_1(){
        return UIScreen.main.bounds.size.height/667
    }else{
        return UIScreen.main.bounds.size.height/812
    }
}()
