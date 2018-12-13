//
//  GetImageInfoTool.m
//  XCamera
//
//  Created by 张泽 on 2018/9/20.
//  Copyright © 2018年 xhey. All rights reserved.
//

#import "GetImageInfoTool.h"
#import <ImageIO/ImageIO.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>
@implementation GetImageInfoTool
- (NSDictionary *)getImageexifAndGPSInfo:(NSURL *)url{
//    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);

    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    
    
    
    
    NSDictionary *imageInfo = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    
    NSMutableDictionary *metaDataDic = [imageInfo mutableCopy];
    NSMutableDictionary *exifDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyExifDictionary]mutableCopy];
    NSMutableDictionary *GPSDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyGPSDictionary]mutableCopy];
    NSMutableDictionary *TiffDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyTIFFDictionary]mutableCopy];

    NSString *altitude = GPSDic[@"Altitude"];
    NSString *longitude = GPSDic[@"Longitude"];
    NSString *dateTimeOriginal = exifDic[@"DateTimeOriginal"];
    NSString *software = TiffDic[@"Software"];
//    NSDictionary *dic = @{@"Altitude":altitude,@"Longitude":longitude,@"DateTimeOriginal":dateTimeOriginal};
    NSDictionary *dic = @{@"Altitude":@""};

    return dic;
}
- (NSDictionary *)getImageExifInfoByImage:(UIImage *)img{
    //    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    NSData *imageData = UIImageJPEGRepresentation(img, 1.0f);
    // create an imagesourceref
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef) imageData, NULL);
    
    NSDictionary *imageInfo = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    
    NSMutableDictionary *metaDataDic = [imageInfo mutableCopy];
    NSMutableDictionary *exifDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyExifDictionary]mutableCopy];
    NSMutableDictionary *GPSDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyGPSDictionary]mutableCopy];
    NSMutableDictionary *TiffDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyTIFFDictionary]mutableCopy];
    
    NSString *altitude = GPSDic[@"Altitude"];
    NSString *longitude = GPSDic[@"Longitude"];
    NSString *dateTimeOriginal = exifDic[@"DateTimeOriginal"];
    NSString *software = TiffDic[@"Software"];
//    NSDictionary *dic = @{@"Altitude":altitude,@"Longitude":longitude,@"DateTimeOriginal":dateTimeOriginal};
    NSDictionary *dic = @{@"Altitude":@""};

    return dic;
}

- (UIImage *)addImageexifAndGPSInfoToImage:(NSData *)data Longitude:(float)longitude Latitude:(float)latitude Time:(float)time{
    
//    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);

    NSDictionary *imageInfo = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);

    NSMutableDictionary *metaDataDic = [imageInfo mutableCopy];
    NSMutableDictionary *exifDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyExifDictionary]mutableCopy];
    NSMutableDictionary *GPSDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyGPSDictionary]mutableCopy];
    
    
    //修改
    [exifDic setObject:[NSNumber numberWithFloat:time] forKey:(NSString *)kCGImagePropertyExifExposureTime];
    [exifDic setObject:@"SenseTime" forKey:(NSString *)kCGImagePropertyExifLensModel];
    
    [GPSDic setObject:@"N" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    [GPSDic setObject:[NSNumber numberWithFloat:latitude] forKey:(NSString*)kCGImagePropertyGPSLatitude];
    
    [GPSDic setObject:@"E" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    [GPSDic setObject:[NSNumber numberWithFloat:longitude] forKey:(NSString*)kCGImagePropertyGPSLongitude];
    
    [metaDataDic setObject:exifDic forKey:(NSString*)kCGImagePropertyExifDictionary];
    [metaDataDic setObject:GPSDic forKey:(NSString*)kCGImagePropertyGPSDictionary];
    
    
    //写入图片
    CFStringRef UTI = CGImageSourceGetType(source);
    NSMutableData *newImageData = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)newImageData, UTI, 1,NULL);
    
    //add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef)metaDataDic);
    CGImageDestinationFinalize(destination);
    CIImage *newIma = [CIImage imageWithData:newImageData];
    
    UIImage *ima = [UIImage imageWithCIImage:newIma];
    
    return ima;
    
}
@end
