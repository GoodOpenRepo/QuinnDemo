//
//  OCUtil.h
//  ThreeDSwing
//
//  Created by Yuguo Lee on 16/7/2.
//  Copyright © 2016年 Xhey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class GPUImageTwoInputFilter;
@interface OCUtil : NSObject
+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;
@end
