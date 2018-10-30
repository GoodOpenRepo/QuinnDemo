//
//  ViewController.swift
//  EarthLocationTransform
//
//  Created by Quinn on 2018/10/30.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {

    var location = CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = CLLocation.init(latitude: CLLocationDegrees.init(40.036627), longitude: CLLocationDegrees.init(116.311336))
        let coord = location.locationEarthFromMars()
        let lat = coord.coordinate.latitude
        let long = coord.coordinate.longitude
        
        print("lat:: \(lat) \n,long::\(long)\n")
    }


}

