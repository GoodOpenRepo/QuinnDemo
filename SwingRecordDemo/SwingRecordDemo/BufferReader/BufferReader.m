//
//  BufferReader.m
//  FaceDetectionProcessor
//
//  Created by Vitaliy Malakhovskiy on 7/3/14.
//  Copyright (c) 2014 Vitaliy Malakhovskiy. All rights reserved.
//

#import "BufferReader.h"
#import <AVFoundation/AVFoundation.h>

@interface BufferReader () {
    struct DelegateMethods {
        unsigned int didGetNextVideoSample   : 1;
        unsigned int didGetErrorRedingSample : 1;
        unsigned int didFinishReadingSample  : 1;
    } _delegateMethods;
}

@property (strong) AVAssetReader *reader;

@end

@implementation BufferReader

- (instancetype)initWithDelegate:(id<BufferReaderDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _delegateMethods.didGetNextVideoSample = [self.delegate respondsToSelector:@selector(bufferReader:didGetNextVideoSample:)];
        _delegateMethods.didGetErrorRedingSample = [self.delegate respondsToSelector:@selector(bufferReader:didGetErrorRedingSample:)];
        _delegateMethods.didFinishReadingSample = [self.delegate respondsToSelector:@selector(bufferReader:didFinishReadingAsset:)];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@: dealloc",self);
}

- (void)startReadingAsset:(AVAsset *)asset error:(NSError *)error {
    NSError *err;
    self.reader = [[AVAssetReader alloc] initWithAsset:asset error:&err];
    if (err) {
        if (_delegateMethods.didGetErrorRedingSample) {
            [self.delegate bufferReader:self didGetErrorRedingSample:err];
        }
        return;
    }

    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if (!videoTracks.count) {
        error = [NSError errorWithDomain:@"AVFoundation error" code:-1 userInfo:@{ NSLocalizedDescriptionKey : @"Can't read video track" }];
        NSLog(@"%@",error);
        if (_delegateMethods.didGetErrorRedingSample) {
            [self.delegate bufferReader:self didGetErrorRedingSample:err];
        }
        return;
    }

    AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
    AVAssetReaderTrackOutput *trackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:CVPixelFormatOutputSettings()];
	if ([self.reader canAddOutput:trackOutput]) {
		[self.reader addOutput:trackOutput];
	}

    NSLog(@"Edward debug log. self:%@, reader. status:%ld",self,(long)self.reader.status);
    if (self.reader.status != AVAssetReaderStatusReading && self.reader.status != AVAssetReaderStatusCancelled ) {
        [self.reader startReading];
    }

    CMSampleBufferRef buffer = NULL;
    BOOL continueReading = YES;
    while (continueReading) {
        AVAssetReaderStatus status = [self.reader status];
        switch (status) {
            case AVAssetReaderStatusUnknown: {
            } break;
            case AVAssetReaderStatusReading: {
                buffer = [trackOutput copyNextSampleBuffer];

                if (!buffer) {
                    buffer = NULL;
                    break;
                }

                if (_delegateMethods.didGetNextVideoSample) {
                    [self.delegate bufferReader:self didGetNextVideoSample:buffer];
                }
            } break;
            case AVAssetReaderStatusCompleted: {
                if (_delegateMethods.didFinishReadingSample) {
                    [self.delegate bufferReader:self didFinishReadingAsset:asset];
                }
                continueReading = NO;
            } break;
            case AVAssetReaderStatusFailed: {
                if (_delegateMethods.didGetErrorRedingSample) {
                    [self.delegate bufferReader:self didGetErrorRedingSample:err];
                }
                [self.reader cancelReading];
                continueReading = NO;
            } break;
            case AVAssetReaderStatusCancelled: {
                continueReading = NO;
            } break;
        }
        if (buffer) {
            CMSampleBufferInvalidate(buffer);
            CFRelease(buffer);
            buffer = NULL;
        }
    }
}

- (void)cancelReadingAsset {
	[self.reader cancelReading];
}

NS_INLINE NSDictionary *CVPixelFormatOutputSettings() {
    return @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] };
}

@end
