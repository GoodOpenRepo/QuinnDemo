//
//  RealmManager.swift
//  RealmDemo
//
//  Created by Quinn on 2018/12/12.
//  Copyright © 2018 Quinn. All rights reserved.
//

import Foundation
import RealmSwift

// 获取默认的 Realm 数据库
var realm = try! Realm()

func setDefaultRealmForUser(username: String) {
    var config = Realm.Configuration()
    
    // 使用默认的目录，但是使用用户名来替换默认的文件名
    config.fileURL = config.fileURL!.deletingLastPathComponent()
        .appendingPathComponent("\(username).realm")
    config.schemaVersion = 1
    // 将这个配置应用到默认的 Realm 数据库当中
    Realm.Configuration.defaultConfiguration = config
    realm = try! Realm()
}


let realm_runtime = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "XCameraInMemoryRealm"))
