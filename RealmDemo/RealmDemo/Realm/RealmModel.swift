//
//  RealmModel.swift
//  RealmDemo
//
//  Created by Quinn on 2018/12/12.
//  Copyright © 2018 Quinn. All rights reserved.
//

import Foundation
import RealmSwift
// 定义模型的做法和定义常规 Swift 类的做法类似
class Dog: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    @objc dynamic var id = 0
    override static func primaryKey() -> String? {
        return "id"
    }
}
class Person: Object {
    @objc dynamic var name = ""
    @objc dynamic var picture: Data? = nil // 支持可空值
    let dogs = List<Dog>()
}
