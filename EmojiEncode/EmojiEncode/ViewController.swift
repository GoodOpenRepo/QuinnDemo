//
//  ViewController.swift
//  EmojiEncode
//
//  Created by Quinn on 2019/1/11.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let txt = "我❤️🌸你😄你是🐶，哈哈哈 i love you"
        
        printEmoji(str:txt)
    }

    
    func printEmoji(str:String) {
        
        let encode =  str.encodeEmoji()
        print("encode",encode)
        let decode = encode.decodeEmoji()
        print("decode",decode)

    }
    
    
    
}


extension String{
    func encodeEmoji() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    func decodeEmoji() -> String? {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
}
