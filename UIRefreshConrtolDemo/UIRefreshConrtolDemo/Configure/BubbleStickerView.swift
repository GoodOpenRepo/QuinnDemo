//
//  BubbleStickerView.swift
//  StretchableImage
//
//  Created by Quinn_F on 2018/5/14.
//  Copyright © 2018年 Quinn. All rights reserved.
//

import UIKit

@IBDesignable

class BubbleStickerView: UIImageView {

    @IBInspectable var inset_top: CGFloat = 0{
        didSet{
            image = stretchableImage(stretchable: UIEdgeInsets(top: inset_top, left: inset_left, bottom: inset_bottom, right: inset_right), image: image)
        }
    }
    @IBInspectable var inset_left: CGFloat = 0{
        didSet{
            image = stretchableImage(stretchable: UIEdgeInsets(top: inset_top, left: inset_left, bottom: inset_bottom, right: inset_right), image: image)
        }
    }
    @IBInspectable var inset_bottom: CGFloat = 0{
        didSet{
            image = stretchableImage(stretchable: UIEdgeInsets(top: inset_top, left: inset_left, bottom: inset_bottom, right: inset_right), image: image)
        }
    }
    @IBInspectable var inset_right: CGFloat = 0{
        didSet{
            image = stretchableImage(stretchable: UIEdgeInsets(top: inset_top, left: inset_left, bottom: inset_bottom, right: inset_right), image: image)
        }
    }
    
    private func stretchableImage(stretchable insets:UIEdgeInsets,image:UIImage?) -> UIImage?{
        let image = image?.resizableImage(withCapInsets: insets, resizingMode: UIImage.ResizingMode.stretch)
        return image
    }
    
}
