//
//  XHImageCrophelper.h
//  VideoCompress
//
//  Created by Quinn on 2019/3/9.
//  Copyright © 2019 Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface XHImageCrophelper : NSObject
+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
