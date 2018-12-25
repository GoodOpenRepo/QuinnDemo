//
//  ViewController.swift
//  PanGestureAnimation
//
//  Created by Quinn on 2018/12/25.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var bottomView: UIView!
    
    enum BottomViewAnimationState{
        case up
        case down
    }
    var endHeight:CGFloat = 200
    var overHeight:CGFloat = 150
    var animationDirection:BottomViewAnimationState = .up
    var upAnimationTime = 0.2
    var downAnimationTime = 0.1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func panGestureChanged(_ sender: UIPanGestureRecognizer) {
    
        let position = sender.translation(in: sender.view!)
        var newPositionY:CGFloat = 0
        if animationDirection == .up{
            var radio = (position.y/overHeight) * (position.y/overHeight) / 2
            radio = radio > 1 ? 1:radio
            newPositionY = position.y * abs(radio)
            // 开始时 已经在最低的地方 禁止上滑
            if newPositionY > 0 {
                return
            }
            
            // 如果向上滑动的距离太多，到达底部时，停止滑动
            if newPositionY < -endHeight {
                animationUp()
                return
            }
        }else{
            newPositionY = position.y - endHeight
            
            // 开始时 已经在最高的地方 禁止上滑
            if newPositionY < -endHeight {
                return
            }
            
            // 如果向下滑动的距离太多，到达底部时，停止滑动
            if newPositionY > 0 {
                animationDown()
                return
            }
        }
        imgView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: newPositionY)
        bottomView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: newPositionY)

        if sender.state == .ended{
            if newPositionY > -overHeight{
                animationDown()
            }else{
                animationUp()
                
            }
        }
    }
    
    func animationUp(){
        UIView.animate(withDuration: upAnimationTime) {
            self.imgView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.endHeight)
            self.bottomView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.endHeight)
            self.animationDirection = .down
        }
    }
    
    func animationDown(){
        UIView.animate(withDuration: downAnimationTime) {
            self.imgView.transform = CGAffineTransform.identity
            self.bottomView.transform = CGAffineTransform.identity
            self.animationDirection = .up
        }
    }
    @IBAction func tapButtonToAnimation(_ sender: UIButton) {
        if animationDirection == .up{
            animationUp()
        }else{
            animationDown()
        }
    }
    
}

