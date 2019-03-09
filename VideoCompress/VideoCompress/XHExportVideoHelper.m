//
//  XHExportVideoHelper.m
//  VideoCompress
//
//  Created by Quinn on 2019/3/8.
//  Copyright © 2019 Quinn. All rights reserved.
//

#import "XHExportVideoHelper.h"
#import <VideoToolbox/VideoToolbox.h>
#import "SDAVAssetExportSession.h"
#import "XLHelpClass.h"

@interface XHExportVideoHelper ()<SDAVAssetExportSessionDelegate>//遵循协议
@property (nonatomic,strong,nullable)  UIImage *firstImg;

@end

@implementation XHExportVideoHelper

- (NSDictionary *)getVideoInfo:(AVURLAsset*)urlAsset
{
    AVAssetTrack *videoTrack = nil;
    
    NSArray *videoTracks = [urlAsset tracksWithMediaType:AVMediaTypeVideo];
    
    if ([videoTracks count] > 0)
        videoTrack = [videoTracks objectAtIndex:0];
    
    CGSize trackDimensions = [videoTrack naturalSize];
    if (CGSizeEqualToSize(trackDimensions, CGSizeZero) || trackDimensions.width == 0.0 || trackDimensions.height == 0.0) {
        NSArray * formatDescriptions = [videoTrack formatDescriptions];
        CMFormatDescriptionRef formatDescription = NULL;
        if ([formatDescriptions count] > 0) {
            formatDescription = (__bridge CMFormatDescriptionRef)[formatDescriptions objectAtIndex:0];
            if (formatDescription) {
                trackDimensions = CMVideoFormatDescriptionGetPresentationDimensions(formatDescription, false, false);
            }
        }
    }
    
    int width = trackDimensions.width;
    int height = trackDimensions.height;
    
    float frameRate = [videoTrack nominalFrameRate];
    float bps = [videoTrack estimatedDataRate];
    
    return @{
             @"width":@(width),
             @"height":@(height),
             @"fps":@(frameRate),
             @"bitrate":@(bps)};
    
}

- (void)export:(AVURLAsset*)urlAsset withOutput:(NSURL*)outputFileURL handler:(void (^)(AVAssetExportSessionStatus status))handler{
    _firstImg = nil;
    NSDictionary *videoInfo = [self getVideoInfo:urlAsset];
    
    int width = [videoInfo[@"width"] intValue];
    int height = [videoInfo[@"height"] intValue];
    
    
    int max = MAX(width, height);
    if (max > 960) {
        if (width > 960){
            width = 960;
            height = height * 960.0/width;
        }else{
            width = width * 960.0/height;
            height = 960;
        }
    }
    
    //帧率
    float fps = [videoInfo[@"fps"] floatValue];
    
    if (fps > 30) {
        fps = 30;
    }
    
    //码率
    float bitrate = [videoInfo[@"bitrate"] floatValue];
    if (bitrate > 720000) {
        bitrate = 720000;
    }
    
    NSDictionary * prop = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInt:bitrate],kVTCompressionPropertyKey_AverageBitRate,
                           kVTProfileLevel_H264_High_AutoLevel,kVTCompressionPropertyKey_ProfileLevel,
                           [NSNumber numberWithInt:fps],kVTCompressionPropertyKey_MaxKeyFrameInterval,
                           nil];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   prop,AVVideoCompressionPropertiesKey,
                                   [NSNumber numberWithInt:width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:height], AVVideoHeightKey,
                                   nil];
    
    NSDictionary* audioOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey,
                                         [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                         [NSNumber numberWithFloat:44100], AVSampleRateKey,
                                         [NSNumber numberWithInt:128000], AVEncoderBitRateKey,
                                         nil];
    
    
    
    
    SDAVAssetExportSession *encoder = [SDAVAssetExportSession.alloc initWithAsset:urlAsset];
    encoder.outputFileType = AVFileTypeMPEG4;
    encoder.outputURL = outputFileURL;
    
    encoder.videoSettings = videoSettings;
    encoder.audioSettings = audioOutputSettings;

    [encoder exportAsynchronouslyWithCompletionHandler:^
    {
        if (encoder.status == AVAssetExportSessionStatusCompleted)
        {
            NSLog(@"Video export succeeded");
        }
        else if (encoder.status == AVAssetExportSessionStatusCancelled)
        {
            NSLog(@"Video export cancelled");
        }
        else
        {
            NSLog(@"Video export failed with error: %@ (%ld)", encoder.error.localizedDescription, (long)encoder.error.code);
        }
        handler(encoder.status);
    }];
    
    if (_firstImg ==  nil && _imageBlock != nil){
        UIImage *img = [self getVideoPreViewImage:urlAsset];
        _imageBlock(img);
    }
    
    
}
- (UIImage*) getVideoPreViewImage:(AVURLAsset *)asset
{
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}

@end
