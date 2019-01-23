//
//  UIFont+Register.m
//  FontRegisterDemo
//
//  Created by Quinn on 2019/1/23.
//  Copyright © 2019 Quinn. All rights reserved.
//

#import "UIFont+Register.h"
#import <CoreText/CoreText.h>

@implementation UIFont (Register)
+(UIFont*)customFontWithFontUrl:(NSURL*)customFontUrl size:(CGFloat)size
    {
        NSURL *fontUrl = customFontUrl;
        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
        CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
        CGDataProviderRelease(fontDataProvider);
        CFErrorRef error;
        bool isSuccess = CTFontManagerRegisterGraphicsFont(fontRef, &error);
        if(!isSuccess){
            //如果注册失败,则不使用
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
        }
        NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
        UIFont *font = [UIFont fontWithName:fontName size:size];
        CGFontRelease(fontRef);
        return font;
    }
@end
