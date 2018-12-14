//
//  Music.swift
//  RxDemo
//
//  Created by Quinn on 2018/12/13.
//  Copyright © 2018 Quinn. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
struct Music {
    let name :String
    let singer:String
    init(name:String,singer:String) {
        self.name = name
        self.singer = singer
    }
}

//struct MusicListViewModel {
//    let data = [
//        Music(name: "我爱的人", singer: "Quinn"),
//        Music(name: "爱人", singer: "Muinn"),
//        Music(name: "人的传说", singer: "Luinn"),
//        ]
//}

struct MusicListViewModel {
    let data = Observable.just([
        Music(name: "我爱的人", singer: "Quinn"),
        Music(name: "爱人", singer: "Muinn"),
        Music(name: "人的传说", singer: "Luinn"),
        ])
}


