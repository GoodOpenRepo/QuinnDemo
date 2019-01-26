
//
//  SwingHelper.swift
//  SwingRecordDemo
//
//  Created by Quinn on 2019/1/24.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit


func fullFilePath(_ path: String) -> String {
    if path.hasPrefix("/") {
        return NSHomeDirectory() + path
    } else {
        return NSHomeDirectory() + "/" + path
    }
    
}
