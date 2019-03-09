//
//  PixelTool.m
//  XCamera
//
//  Created by 周晓林 on 2018/4/8.
//  Copyright © 2018年 xhey. All rights reserved.
//

#import "XLHelpClass.h"
#include <sys/utsname.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import <UIKit/UIKit.h>
#define PixelPoint 128
@implementation AColor

@end
@implementation XLHelpClass

+ (UIImage*) readImageFromFBO: (int) width height:(int) height orient:(int) orient
{
    CGSize size = CGSizeMake(width, height);
    NSUInteger totalBytesForImage = width * height * 4;
    GLubyte *rawImagePixels;
    CGDataProviderRef dataProvider = NULL;
    rawImagePixels = (GLubyte *)malloc(totalBytesForImage);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, rawImagePixels);
    dataProvider = CGDataProviderCreateWithData(NULL, rawImagePixels, totalBytesForImage, dataProviderReleaseCallback);
    
    CGColorSpaceRef defaultRGBColorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImageFromBytes = CGImageCreate(width, height, 8, 32, 4 * width, defaultRGBColorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaLast, dataProvider, NULL, NO, kCGRenderingIntentDefault);
    
    CIImage* ciImage = [CIImage imageWithCGImage:cgImageFromBytes];
    CGImageRef videoImage;
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];

    if (orient == 3) {
        ciImage = [ciImage imageByApplyingOrientation:6];
        videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, height, width)];
    }
    if (orient == 4) {
        ciImage = [ciImage imageByApplyingOrientation:8];
        videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, height, width)];
    }
    
    if (orient == 2) {
        ciImage = [ciImage imageByApplyingOrientation:1];
        videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, width, height)];
    }
    
    if (orient == 1 || orient == 5) {
        ciImage = [ciImage imageByApplyingOrientation:3];
        videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, width, height)];
    }
    

    UIImage *finalImage = [UIImage imageWithCGImage:videoImage scale:1.0 orientation:(UIImageOrientationUp)];
    
//    finalImage = [UIImage imageWithData:UIImageJPEGRepresentation(finalImage, 0.6)];
    
    CGImageRelease(videoImage);
    temporaryContext = nil;
    ciImage = nil;
    CGImageRelease(cgImageFromBytes);
    CGColorSpaceRelease(defaultRGBColorSpace);
    CGDataProviderRelease(dataProvider);
    
    return finalImage;
}

void dataProviderReleaseCallback (void *info, const void *data, size_t size)
{
    free((void *)data);
}

+ (void) updateTextureWithView:(GLuint)textureId view:(UIView *)mView
{
    CALayer* layer = mView.layer;
    layer.contentsScale = [UIScreen mainScreen].scale;
    CGSize pointSize = layer.bounds.size;
    CGSize layerPixelSize = CGSizeMake(layer.contentsScale * pointSize.width, layer.contentsScale * pointSize.height);
    GLubyte *imageData = (GLubyte*)calloc(1, (int)layerPixelSize.width * (int)layerPixelSize.height * 4);
    CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef imageContext = CGBitmapContextCreate(imageData, (int)layerPixelSize.width, (int)layerPixelSize.height, 8, (int)layerPixelSize.width * 4, genericRGBColorspace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGContextTranslateCTM(imageContext, 0.0f, layerPixelSize.height);
    CGContextScaleCTM(imageContext, layer.contentsScale, - layer.contentsScale);
    [layer renderInContext:imageContext];
    CGContextRelease(imageContext);
    CGColorSpaceRelease(genericRGBColorspace);
    
    glBindTexture(GL_TEXTURE_2D, textureId);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)layerPixelSize.width, (int)layerPixelSize.height, 0, GL_BGRA, GL_UNSIGNED_BYTE, imageData);
    glBindTexture(GL_TEXTURE_2D, 0);
    free(imageData);

}

+ (int ) createTextureWithView:(UIView *)mView
{
    CALayer* layer = mView.layer;
    layer.contentsScale = [UIScreen mainScreen].scale;
    CGSize pointSize = layer.bounds.size;
    CGSize layerPixelSize = CGSizeMake(layer.contentsScale * pointSize.width, layer.contentsScale * pointSize.height);
    GLubyte *imageData = (GLubyte*)calloc(1, (int)layerPixelSize.width * (int)layerPixelSize.height * 4);
    CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef imageContext = CGBitmapContextCreate(imageData, (int)layerPixelSize.width, (int)layerPixelSize.height, 8, (int)layerPixelSize.width * 4, genericRGBColorspace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGContextTranslateCTM(imageContext, 0.0f, layerPixelSize.height);
    CGContextScaleCTM(imageContext, layer.contentsScale, - layer.contentsScale);
    [layer renderInContext:imageContext];
    CGContextRelease(imageContext);
    CGColorSpaceRelease(genericRGBColorspace);
    
    GLuint textureHandle = 0;
    
    glGenTextures(1, &textureHandle);
    glBindTexture(GL_TEXTURE_2D, textureHandle);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)layerPixelSize.width, (int)layerPixelSize.height, 0, GL_BGRA, GL_UNSIGNED_BYTE, imageData);
    
    free(imageData);
    
    return textureHandle;
}

+ (int ) createTexture: (UIImage*) mBitmap
{
    GLuint textureHandle = 0;
    
    glGenTextures(1, &textureHandle);
    glBindTexture(GL_TEXTURE_2D, textureHandle);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    CGImageRef newImageSource = [mBitmap CGImage];
    int width = (int)CGImageGetWidth(newImageSource);
    int height = (int)CGImageGetHeight(newImageSource);
    
    GLubyte* imageData = (GLubyte*)calloc(1, width * height * 4);
    CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef imageContext = CGBitmapContextCreate(imageData, width, height, 8, width * 4, genericRGBColorspace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), newImageSource);
    CGContextRelease(imageContext);
    CGColorSpaceRelease(genericRGBColorspace);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_BGRA, GL_UNSIGNED_BYTE, imageData);
    
    free(imageData);
    
    return textureHandle;
}

+ (BOOL) isLowerThaniPhone6
{
    struct utsname systemInfo;
    int ret = 0;
    ret = uname(&systemInfo);
    NSString* machine = [NSString stringWithUTF8String:systemInfo.machine];
    if ([machine hasPrefix:@"iPhone7"]) {
        return TRUE;
    }
    if ([machine hasPrefix:@"iPhone6"]) {
        return TRUE;
    }
    if ([machine hasPrefix:@"iPhone5"]) {
        return TRUE;
    }
    if ([machine hasPrefix:@"iPad"]) {
        return TRUE;
    }
    
    return FALSE;
}
int median(int a, int b, int c)
{
    if ((a - b) * (b - c) > 0.0) return b;           //  a大于b 且 b大于c
    else if ((b - a) * (a - c) > 0.0) return a;       //   b 大于 a 且 a大于c
    else return c;
}


+ (GLuint) setupTexture: (UIImage*)image
{
    CGImage* newImageSource = [image CGImage];
    int width = (int)CGImageGetWidth(newImageSource);
    int height = (int)CGImageGetHeight(newImageSource);
    
    GLubyte *imageData = (GLubyte*)calloc(1, width*height*4);
    CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef imageContext = CGBitmapContextCreate(imageData, width, height, 8, width*4, genericRGBColorspace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), newImageSource);
    
    
    GLuint imageTexture = 0;
    glGenTextures(1, &imageTexture);
    glBindTexture(GL_TEXTURE_2D, imageTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_BGRA, GL_UNSIGNED_BYTE, imageData);
    CGContextRelease(imageContext);
    CGColorSpaceRelease(genericRGBColorspace);
    free(imageData);
    newImageSource = nil;
    
    return imageTexture;
}
+ (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef isFront:(BOOL) isFront
{
    
    
    CVPixelBufferLockBaseAddress(pixelBufferRef, 0);
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBufferRef];
    if (isFront == NO) {
        ciImage = [ciImage imageByApplyingOrientation:6];
    }else{
        ciImage = [ciImage imageByApplyingOrientation:5];
    }
    
    float height = CVPixelBufferGetWidth(pixelBufferRef);
    float width = CVPixelBufferGetHeight(pixelBufferRef);
    
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 width,
                                                 height)];
    
    UIImage *image = [UIImage imageWithCGImage:videoImage scale:1.0 orientation:(UIImageOrientationUp)];
//    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1.0)];
    CGImageRelease(videoImage);
    temporaryContext = nil;
    ciImage = nil;
    CVPixelBufferUnlockBaseAddress(pixelBufferRef, 0);
    return image;
}

+(UIImage*)pixelBufferToImage:(CVPixelBufferRef) pixelBufffer{
    CVPixelBufferLockBaseAddress(pixelBufffer, 0);// 锁定pixel buffer的基地址
    void * baseAddress = CVPixelBufferGetBaseAddress(pixelBufffer);// 得到pixel buffer的基地址
    size_t width = CVPixelBufferGetWidth(pixelBufffer);
    size_t height = CVPixelBufferGetHeight(pixelBufffer);
    size_t bufferSize = CVPixelBufferGetDataSize(pixelBufffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBufffer);// 得到pixel buffer的行字节数
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();// 创建一个依赖于设备的RGB颜色空间
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    CGImageRef cgImage = CGImageCreate(width,
                                       height,
                                       8,
                                       32,
                                       bytesPerRow,
                                       rgbColorSpace,
                                       kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrderDefault,
                                       provider,
                                       NULL,
                                       true,
                                       kCGRenderingIntentDefault);//这个是建立一个CGImageRef对象的函数
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);  //类似这些CG...Ref 在使用完以后都是需要release的，不然内存会有问题
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgbColorSpace);
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);//1代表图片是否压缩
    image = [UIImage imageWithData:imageData];
    CVPixelBufferUnlockBaseAddress(pixelBufffer, 0);   // 解锁pixel buffer
    
    return image;
}
+ (UIImage *)imageFromPixelBufferQuinn:(CVPixelBufferRef)pixelBufferRef {
    CVImageBufferRef imageBuffer =  pixelBufferRef;
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, rgbColorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrderDefault, provider, NULL, true, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgbColorSpace);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return image;
}
#if 0
+ (void)funcWithPixel:(CVPixelBufferRef)pixelBuffer color:(AColor *)color{
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);

    int bufferWidth = (int)CVPixelBufferGetWidth( pixelBuffer );
    int bufferHeight = (int)CVPixelBufferGetHeight( pixelBuffer );
    
    
    OSType pixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer);
    
    if (pixelFormat == kCVPixelFormatType_32BGRA) {
        NSLog(@"%s %d kCVPixelFormatType_32BGRA",__func__,__LINE__);
        const int kBytesPerPixel = 4;

        
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow( pixelBuffer );
        uint8_t *baseAddress = CVPixelBufferGetBaseAddress( pixelBuffer );
        
        
        int r = 0,g = 0,b = 0,numberCount = 0;
        
        for ( int row = 0; row < bufferHeight; row += PixelPoint )
        {
            uint8_t *pixel = baseAddress + row * bytesPerRow;
            for ( int column = 0; column < bufferWidth; column += 1 )
            {
                numberCount++;
                b += pixel[0];
                g += pixel[1];
                r += pixel[2];
                
                pixel += kBytesPerPixel;
            }
        }
        
        int red = r/numberCount;
        int green = g/numberCount;
        int blue = b/numberCount;
        
        
        color.red  = MAX(MAX(red, green), blue);
        color.green  = median(red, green, blue);
        color.blue = MIN(MIN(red, green), blue);
    }
    if (pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange || pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange) {
        const int kBytesPerPixel = 4;
        
        
        size_t width = bufferWidth;
        size_t height = bufferHeight;
        
        uint8_t* data = (uint8_t*)malloc(width * height * 4);
        
        uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
        
        // UV数据
        uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
        NV12ToARGB(y_frame, width, uv_frame, width, data, width * 4, width, height);
#pragma clang diagnostic pop

        int r = 0,g = 0,b = 0,numberCount = 0;
        
        for ( int row = 0; row < bufferHeight; row += PixelPoint )
        {
            uint8_t *pixel = data + row * width * 4;
            for ( int column = 0; column < bufferWidth; column += 1 )
            {
                numberCount++;
                b += pixel[0];
                g += pixel[1];
                r += pixel[2];
                
                pixel += kBytesPerPixel;
            }
        }
        
        int red = r/numberCount;
        int green = g/numberCount;
        int blue = b/numberCount;
        
        
        color.red  = MAX(MAX(red, green), blue);
        color.green  = median(red, green, blue);
        color.blue = MIN(MIN(red, green), blue);
        
        free(data);

        
        
        
        
    }
   
    
    
   
    
    
    
    CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
    
}
#endif

+ (NSMutableDictionary *)getTextAttributes:(NSTextAlignment)textAlignment font:(UIFont*)font subjectColor:(UIColor*)subjectColor
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = textAlignment;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    [attrs setObject:font forKey:NSFontAttributeName];
    [attrs setObject:subjectColor forKey:NSForegroundColorAttributeName];
    [attrs setObject:style forKey:NSParagraphStyleAttributeName];
    return [attrs mutableCopy];
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newPic;
}

@end
