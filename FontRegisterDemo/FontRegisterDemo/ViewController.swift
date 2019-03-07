//
//  ViewController.swift
//  FontRegisterDemo
//
//  Created by Quinn on 2019/1/23.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //下载字体
    //自定义字体
    //注册字体
    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        downLoadFont()
        print(self.textLabel.font.fontName)
        print(self.textLabel.font.description)
        
        
    }

    func downLoadFont(){
        let libPath = FileManager.default.urls(for: .allLibrariesDirectory, in: .userDomainMask).first!
        let path = libPath.appendingPathComponent("zzzz.ttf")
        print("path-->",path)
        try? UIFont.register(url: path)
        return
        let urlSession = URLSession.init(configuration: URLSessionConfiguration.default)
        let url = URL.init(string: "https://github.com/quinn0809/QuinnDemo/raw/master/zzztest.ttf")
        let task = urlSession.dataTask(with: url!) { [weak self](data, response, error) in
            try? data?.write(to: path)
            
            //先注册
            try? UIFont.register(url: path)
//            //再使用
            DispatchQueue.main.async {[weak self]in
                print(self?.textLabel.font.fontName)
                print(self?.textLabel.font.description)

//                self?.textLabel.font = UIFont.init(name: "DFFunnyEnglish", size: 18)
                self?.textLabel.text = "FHJKBVCVBNM"
            }
            
            
            //发送通知
            
            //sticker reload init 方法中
        }
        task.resume()
    }

}
extension String: Error {}
extension UIFont {
    static func register(url: URL) throws {
        guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
            throw "Could not create font data provider for \(url)."
        }
        #if swift(>=4.0)
        guard let font = CGFont(fontDataProvider) else {
            throw "Could not create font for \(url)."
        }
        #else
        let font = CGFont(fontDataProvider)
        
        #endif
        print(font.fullName)
        print(font.postScriptName)

        var error: Unmanaged<CFError>?
        guard CTFontManagerRegisterGraphicsFont(font, &error) else {
            throw error!.takeUnretainedValue()
        }
    }
}
