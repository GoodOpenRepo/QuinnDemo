//
//  ViewController.swift
//  CurryingDemo
//
//  Created by Quinn on 2019/3/7.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let str = append("a")("b")
        
        let result = verify(nil)("123456789")
        
        email126(account: "xoxo_x@126.com", password: "xiaohuang")
        email163(account: "xoxo_x@126.com", password: "xiaohuang")

    }

    func append(_ left:String) -> ((_ right:String)->String){
        let new:(String) -> String = { aa in
            
            return left + aa
        }
        
        return new
    }

    
    func verify(_ phone:String?) -> ((_ password:String) -> Bool){
        
        let verifyPassword:(String) -> Bool = { pass in
            if phone == nil{
                return false
            }else{
                return true
            }
        }
        
        return verifyPassword
    }
    
    func email126(account:String,password: @autoclosure ()->String){
        guard account == "xoxo_x@126.com" else{
            return
        }
        if password() == "xiaohuang"{
            print("right")
        }else{
            print("error")
        }
    }
    
    func email163(account:String,password:String){
        guard account == "xoxo_x@126.com" else{
            return
        }
        if password == "xiaohuang"{
            print("right")
        }else{
            print("error")
        }
    }
    
}

