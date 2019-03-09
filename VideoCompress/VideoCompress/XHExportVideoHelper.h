//
//  XHExportVideoHelper.h
//  VideoCompress
//
//  Created by Quinn on 2019/3/8.
//  Copyright © 2019 Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHExportVideoHelper : NSObject
@property (nonatomic, copy) void(^imageBlock)(UIImage * __nullable);

- (void)export:(AVURLAsset*)urlAsset withOutput:(NSURL*)outputFileURL handler:(void (^)(AVAssetExportSessionStatus status))handler;

@end

NS_ASSUME_NONNULL_END
