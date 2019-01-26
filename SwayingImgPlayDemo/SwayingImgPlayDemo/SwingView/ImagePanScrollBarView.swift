//
//  ImagePanScrollBarView.swift
//  ThreeDSwing
//
//  Created by Yuguo Lee on 16/7/27.
//  Copyright © 2016年 Xhey. All rights reserved.
//

import UIKit

class ImagePanScrollBarView: UIView {
	
	var scrollBarLayer: CAShapeLayer?
    var icon: UIImageView!
    var label: UILabel!
    var gradientLayer: CAGradientLayer!
	
	var progress: CGFloat = 0 {
		didSet {
			configProgress()
		}
	}
    
    let gifImages: [UIImage] = {
        let bundle = Bundle.main.url(forResource: "loginGifImages", withExtension: "bundle")
        let fm = FileManager.default
        let imageArray = try? fm.contentsOfDirectory(atPath: bundle!.path).sorted()
        var images = [UIImage]()
        for fileRelPath in imageArray! {
            let imagePath = bundle!.appendingPathComponent(fileRelPath).path
            let image = UIImage(contentsOfFile: imagePath)
            images.append(image!)
        }
        return images
    }()

    
    
	fileprivate let barWidthPercent = 120 * WIDTH_SCALE / SCREEN_WIDTH
    fileprivate var isFirst = false
    
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        
        gradientLayer = CAGradientLayer()
		gradientLayer.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 310 * HEIGHT_SCALE, width: SCREEN_WIDTH, height: 310 * HEIGHT_SCALE)
		gradientLayer.colors = [UIColorFromHex(0x000000, alpha: 0.0).cgColor,
		                        UIColorFromHex(0x000000, alpha: 0.75).cgColor]
		gradientLayer.locations = [0, 1]
		self.layer.addSublayer(gradientLayer)
        
        let backView = UIView()
        backView.frame = gradientLayer.frame
        backView.backgroundColor = UIColor.clear
        addSubview(backView)
        
		//setScrollLayer()
		
        label = UILabel()
		label.font = UIFont.systemFont(ofSize: 20)
//        label.text = Localized("login_sway_phone")
		label.textColor = .white
		self.addSubview(label)
//        label.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self)
//
//            #if OVERSEA
//            make.bottom.equalTo(self).offset(-74)
//            #else
//            make.bottom.equalTo(self).offset(-14)
//            #endif
//        }
//
//
//
//        icon = UIImageView(image: UIImage(named: "new_guide_ direction_left_icon"))
//        backView.addSubview(icon)
//        icon.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self)
//
//            #if OVERSEA
//            make.bottom.equalTo(self).offset(-120)
//            #else
//            make.bottom.equalTo(self).offset(-60)
//            #endif
//            make.width.equalTo(64)
//            make.height.equalTo(92)
//        }
        
        icon.animationImages = gifImages
        icon.animationDuration = 2
        icon.animationRepeatCount = 0
        icon.startAnimating()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    private func setScrollLayer() {
        let scrollBarPath = UIBezierPath()
        let y = self.frame.height - 50
        scrollBarPath.move(to: CGPoint(x: 0, y: y))
        scrollBarPath.addLine(to: CGPoint(x: self.frame.width, y: y))
        
        let scrollBarBackgroundLayer = CAShapeLayer()
        scrollBarBackgroundLayer.path = scrollBarPath.cgPath
        scrollBarBackgroundLayer.lineWidth = 5
        scrollBarBackgroundLayer.strokeColor = UIColorFromHex(0xffffff, alpha: 0.1).cgColor
        scrollBarBackgroundLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(scrollBarBackgroundLayer)
        
        scrollBarLayer = CAShapeLayer()
        scrollBarLayer?.path = scrollBarPath.cgPath
        scrollBarLayer?.lineWidth = 5
        scrollBarLayer?.strokeColor = UIColorFromHex(0xfbda09).cgColor
        scrollBarLayer?.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(scrollBarLayer!)
    }
	
	func configProgress() {
		if self.progress < 0 {
			self.progress = 0
		} else if self.progress > 1 {
			self.progress = 1
		}
		
		scrollBarLayer?.strokeStart = self.progress * (1 - barWidthPercent)
		scrollBarLayer?.strokeEnd = self.progress * (1 - barWidthPercent) + barWidthPercent
	}
    
    func iconFrameChange() {
//        icon.snp.removeConstraints()
//        icon.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self)
//      
//            #if OVERSEA
//            make.bottom.equalTo(self).offset(-120)
//            #else
//            make.bottom.equalTo(self).offset(-60)
//            #endif
//            make.width.equalTo(42)
//            make.height.equalTo(60)
//        }
//        self.layoutIfNeeded()
    }
    
    deinit{
        print("死掉,没有内存泄露")
    }
}
