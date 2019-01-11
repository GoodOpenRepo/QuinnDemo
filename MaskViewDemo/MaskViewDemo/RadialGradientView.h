//
//  RadialGradientView.h
//  MaskViewDemo
//
//  Created by Quinn on 2018/12/29.
//  Copyright © 2018 Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
//enum GradientType{
//    GradientTypeNone,
//    GradientTypeLinear,
//    GradientTypeCircle
//};
typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeNone                 = 0,
    GradientTypeLinear               = 1,
    GradientTypeCircle               = 2
};


NS_ASSUME_NONNULL_BEGIN

@interface RadialGradientView : UIView
@property(nonatomic,assign)GradientType type ;
@end

NS_ASSUME_NONNULL_END
