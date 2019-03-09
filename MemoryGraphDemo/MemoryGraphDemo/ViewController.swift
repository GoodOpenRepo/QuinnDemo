//
//  ViewController.swift
//  MemoryGraphDemo
//
//  Created by Quinn on 2019/3/7.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let father = Father()
    let son = Son()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        father.son = son
        son.father = father
        
        
        
    }


}

class Father: NSObject {
    var son:Son?
}
class Son: NSObject {
    var father:Father?
    
}
