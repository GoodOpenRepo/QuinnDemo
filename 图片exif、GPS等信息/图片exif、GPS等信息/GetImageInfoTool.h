//
//  GetImageInfoTool.h
//  XCamera
//
//  Created by 张泽 on 2018/9/20.
//  Copyright © 2018年 xhey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface GetImageInfoTool : NSObject
- (NSDictionary *)getImageexifAndGPSInfo:(NSURL *)url;
- (BOOL)isEditByXcamera:(NSURL *)url;
- (UIImage *)addImageexifAndGPSInfoToImage:(NSURL *)url Longitude:(float)longitude Latitude:(float)latitude Time:(float)time;
@end

NS_ASSUME_NONNULL_END
