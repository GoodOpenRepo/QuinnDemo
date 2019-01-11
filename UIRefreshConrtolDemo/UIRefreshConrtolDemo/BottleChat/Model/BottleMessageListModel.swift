//
//  BottleMessageListModel.swift
//  UIRefreshConrtolDemo
//
//  Created by Quinn on 2019/1/7.
//  Copyright © 2019 Quinn. All rights reserved.
//

import Foundation
class NewBottleMessage: Codable {
    var time : String!
    var content : String!
    var source : Int!
}

class NewBottleInfo : Codable{
    var addr : String!
    var bottle_id : Int!
    var bottlet_text : String!
    var first_txt : String!
    var dst_regid : String!
    var image_url : String!
    var is_read : Bool!
    var reply_icon : Int!
    var last_txt : String!
    var sex : Int!
    var src_regid : String!
    var time : String!

}
let regid = "111111"

func requestBottleList(completed:@escaping([NewBottleInfo]?)->()){
    var list:[NewBottleInfo] = [NewBottleInfo]()
    for i in (0...1){
        let info = NewBottleInfo()
        info.last_txt = "这是第\(i)条消息，猫咪~"
        info.addr = "北京海淀区第\(i)公寓"
        info.bottle_id = i + 1001
        info.bottlet_text = "哈哈哈，想不想看我，\(i)"
        info.dst_regid = "222222"
        info.is_read = (i%2 == 0) ? true : false
        info.image_url = "https://raw.githubusercontent.com/quinn0809/p-i-c/master/8.jpg"
        info.first_txt = "我是你叭叭"
        info.reply_icon = Int(arc4random())%4
        info.sex = Int(arc4random())%3
        list.append(info)
    }
//    for i in (0...3){
//        let info = NewBottleInfo()
//        info.last_txt = "哈哈，最后一次，这是第\(i)条消息，猫咪~"
//        info.addr = "北京海淀区第\(i)公寓"
//        info.bottle_id = i + 1001
//        info.bottlet_text = "哈哈哈，想不想看我，\(i)"
//        info.src_regid = "111111"
//        info.is_read = (i%2 == 0) ? true : false
//        info.image_url = "https://raw.githubusercontent.com/quinn0809/p-i-c/master/8.jpg"
//        info.first_txt = ""
//        info.reply_icon = Int(arc4random())%4
//        info.sex = Int(arc4random())%3
//        list.append(info)
//    }
//    for i in (0...3){
//        let info = NewBottleInfo()
//        info.last_txt = ""
//        info.addr = "北京海淀区第\(i)公寓"
//        info.bottle_id = i + 1001
//        info.bottlet_text = "哈哈哈，想不想看我，\(i)"
//        info.dst_regid = "222222"
//        info.is_read = (i%2 == 0) ? true : false
//        info.image_url = "https://raw.githubusercontent.com/quinn0809/p-i-c/master/8.jpg"
//        info.first_txt = "哈哈，第一次这是第\(i)条消息，猫咪~"
//        info.reply_icon = Int(arc4random())%4
//        info.sex = Int(arc4random())%3
//        list.append(info)
//    }
    completed(list)
}
