//
//  PhotoMaker.h
//  PhotoImageShow
//
//  Created by Quinn_F on 2018/8/31.
//  Copyright © 2018年 quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PhotoMaker : NSObject
+ (instancetype)manager NS_SWIFT_NAME(default());
- (int32_t)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;
- (int32_t)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;
- (PHFetchResult<PHAsset *> *)getAllPhotosAssetInAblumCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;
- (PHFetchResult<PHAsset *> *)GetALLphotosUsingPohotKit:(BOOL)includeVideo;
- (void)requestPhotosPermision:(void (^)(NSError *error))completion;

@end
