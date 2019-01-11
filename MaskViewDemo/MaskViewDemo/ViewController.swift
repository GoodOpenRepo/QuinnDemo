//
//  ViewController.swift
//  MaskViewDemo
//
//  Created by Quinn on 2018/12/28.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func addMaskView(){
        let maskView = UIView()
        maskView.frame = view.bounds
        maskView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.view.addSubview(maskView)
        let bezierPathL = UIBezierPath.init(rect: maskView.bounds)
        let bezierPathS = UIBezierPath.init(rect: CGRect.init(x: 0, y: maskView.bounds.height - 281, width: maskView.bounds.width, height: 181))
        bezierPathL.append(bezierPathS)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPathL.cgPath
        shapeLayer.fillRule = .evenOdd
        maskView.layer.mask = shapeLayer
        
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        addMaskView()
    }

}

