//
//  PixelTool.h
//  XCamera
//
//  Created by 周晓林 on 2018/4/8.
//  Copyright © 2018年 xhey. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface AColor : NSObject
@property (nonatomic, assign) int red;
@property (nonatomic, assign) int green;
@property (nonatomic, assign) int blue;
@end
@interface XLHelpClass : NSObject
+ (UIImage*) readImageFromFBO: (int) width height:(int) height orient:(int) orient;

+ (int ) createTexture: (UIImage*) mBitmap;
+ (int ) createTextureWithView:(UIView *)mView;
+ (void) updateTextureWithView:(GLuint)textureId view:(UIView *)mView;

+ (GLuint) setupTexture: (UIImage*)image;

+ (BOOL) isLowerThaniPhone6;
+ (void) funcWithPixel:(CVPixelBufferRef) pixelBuffer color:(AColor*) color;
+ (NSMutableDictionary *)getTextAttributes:(NSTextAlignment)textAlignment font:(UIFont*)font subjectColor:(UIColor*)subjectColor;
+ (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef isFront:(BOOL) isFront;
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
+ (UIImage *)imageFromPixelBufferQuinn:(CVPixelBufferRef)pixelBufferRef;
+ (UIImage*)pixelBufferToImage:(CVPixelBufferRef) pixelBufffer;

@end
