//
//  UIFont+Register.h
//  FontRegisterDemo
//
//  Created by Quinn on 2019/1/23.
//  Copyright © 2019 Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Register)
+(UIFont*)customFontWithFontUrl:(NSURL*)customFontUrl size:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
