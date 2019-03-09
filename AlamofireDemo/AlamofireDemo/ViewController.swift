//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by Quinn on 2019/1/30.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController {

    
    
//    let urlPath = "https://today-test.xhey.top:18000/swaying/uploadfile"
    
    let urlPath_http = "https://today-test.xhey.top:18000/swaying/v2/uploadfile"

//    let urlPath_hangge = "http://www.hangge.com/upload2.php"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
//
//        print(NSUUID().uuidString)
//        return
//        //字符串
//        let strData = "quinn0027.zip".data(using: String.Encoding.utf8)
//        //文件
//        let fileURL = Bundle.main.url(forResource: "swingZip", withExtension: "zip")
//
//
//        let fileData = try! Data.init(contentsOf: fileURL!)
//
//
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                multipartFormData.xheyAppend(strData!, withName: "file_name", mimeType: "application/octet-stream; charset=UTF-8")
//                multipartFormData.xheyAppend(fileData, withName: "file_content", fileName: "quinn0027.zip", mimeType: "application/octet-stream; charset=UTF-8")
//        },
//            to: urlPath_http,
//            method:.post,headers:["Content-Length":"UInt64(100000)"],
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        switch response.result{
//                        case .success(let json):
//                            print("quinn success",json)
//                            break
//                        case .failure(let error):
//                            print("quinn error",error)
//                        default:
//                            break
//                        }
//                    }
//                case .failure(let encodingError):
//                    print("quinn error2",encodingError)
//                }
//            }
//        )
        
        uploadZip { (error) in
            
        }
    }
    
    
    
    private func uploadZip(completed:@escaping(_ error:Error?)->()) {
        let uuid = NSUUID().uuidString
        let coverUIID = NSUUID().uuidString
        
        let fileName = uuid + ".zip"
        let coverName = coverUIID + ".jpg"
        let deviceName = "sensors_deviceId-hhaushdu"
        
        print("fileName",fileName)
        
        let img = UIImage.init(named: "1.jpg")
        let coverData = UIImagePNGRepresentation(img!)
        
        //文件
        let fileURL = Bundle.main.url(forResource: "swingZip", withExtension: "zip")
        let fileData = try! Data.init(contentsOf: fileURL!)
        
        
        let strData = fileName.data(using: String.Encoding.utf8)
        let coverStrData = coverName.data(using: String.Encoding.utf8)
        let deviceData = deviceName.data(using: String.Encoding.utf8)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.xheyAppend(strData!, withName: "file_name", mimeType: "application/octet-stream; charset=UTF-8")
                multipartFormData.xheyAppend(coverStrData!, withName: "cover_name", mimeType: "application/octet-stream; charset=UTF-8")
                multipartFormData.xheyAppend(deviceData!, withName: "device_id", mimeType: "application/octet-stream; charset=UTF-8")
                
                multipartFormData.xheyAppend(fileData, withName: "file_content", fileName: fileName, mimeType: "application/octet-stream; charset=UTF-8")
                multipartFormData.xheyAppend(coverData!, withName: "cover_content", fileName: fileName, mimeType: "application/octet-stream; charset=UTF-8")
        },
            to: urlPath_http,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { [weak self] response in
                        debugPrint(response)
                        switch response.result{
                        case .success(let json):
                            print("上传成功",json)
                            completed(nil)
                            break
                        case .failure(let error):
                            completed(error)
                            print("上传失败",error)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        
    }
    
    
}

extension MultipartFormData{
    private func xheyContentHeaders(withName name: String, fileName: String? = nil, mimeType: String? = nil) -> [String: String] {
        var disposition = "form-data; name=\"\(name)\""
        if let fileName = fileName { disposition += "; filename=\"\(fileName)\"" }
        
        var headers = ["Content-Disposition": disposition]
        if let mimeType = mimeType { headers["Content-Type"] = mimeType }
        
        return headers
    }
    public func xheyAppend(_ data: Data, withName name: String, mimeType: String) {
        var headers = xheyContentHeaders(withName: name, mimeType: mimeType)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)
        headers["Content-Length"] = "\(length)"
        print("ghjklkjhghjkl")
        append(stream, withLength: length, headers: headers)
    }
    public func xheyAppend(_ data: Data, withName name: String, fileName: String, mimeType: String) {
        var headers = xheyContentHeaders(withName: name, fileName: fileName, mimeType: mimeType)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)
        headers["Content-Length"] = "\(length)"
        
        append(stream, withLength: length, headers: headers)
    }
}


