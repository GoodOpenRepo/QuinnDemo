//
//  ViewController.swift
//  RealmDemo
//
//  Created by Quinn on 2018/12/12.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//
//        // 检索 Realm 数据库，找到小于 2 岁 的所有狗狗
//        let puppies = realm.objects(Dog.self).filter("age < 2")
//        // => 0 因为目前还没有任何狗狗被添加到了 Realm 数据库中
//        print(puppies.count)
//        // 数据存储十分简单
//        try! realm.write {
//            puppies.forEach({ (dog) in
//                dog.name = "xiaobai"
//            })
//        }
        
        
        
//        // 像常规 Swift 对象一样使用
//        let myDog = Dog()
//        myDog.name = "Rex"
//        myDog.age = 1
//        print("name of dog: \(myDog.name)")
//
//        // 检索 Realm 数据库，找到小于 2 岁 的所有狗狗
//        let puppies = realm.objects(Dog.self).filter("age < 2")
//        // => 0 因为目前还没有任何狗狗被添加到了 Realm 数据库中
//        print(puppies.count)
//        // 数据存储十分简单
//        try! realm.write {
//            realm.add(myDog)
//        }
//        // => 1 因为狗狗被添加到了 Realm 数据库中
//        print(puppies.count)
//
//        let myDog1 = Dog()
//        myDog1.name = "DDD"
//        myDog1.age = 3
//        print("name of dog: \(myDog1.name)")
//
//        try! realm.write {
//            realm.add(myDog1)
//        }
//        let myDog2 = Dog()
//        myDog2.name = "DDDGG"
//        myDog2.age = 5
//        print("name of dog2: \(myDog2.name)")
//        try! realm_runtime.write {
//            realm_runtime.add(myDog2)
//        }
//        let dogs = realm_runtime.objects(Dog.self).filter("name == 'DDDGG'")
//        print(dogs.first?.name,dogs.first?.age)
        try! realm.write {
            realm.create(Dog.self, value: ["name": "zz"], update: true)
        }

    }
    
    @IBAction func changeUser(_ sender: UIButton) {
    
        switch sender.tag {
        case 1:
            setDefaultRealmForUser(username: "Quinn")
        case 2:
            setDefaultRealmForUser(username: "Muxnnii")

        case 3:
            setDefaultRealmForUser(username: "Lindon")

        default:
            break
        }
    }
}

