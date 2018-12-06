//
//  RTCVideoSource.m
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2018/12/7.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import "RTCVideoSource.h"

@implementation RTCVideoSource

@synthesize consumer = _consumer;

- (AgoraVideoBufferType)bufferType {
    return AgoraVideoBufferTypePixelBuffer;
}

- (BOOL)shouldInitialize {
    return YES;
}

- (void)shouldStart {
    
}

- (void)shouldStop {
    
}

- (void)shouldDispose {
    
}

- (void)consumePixelBuffer:(CVPixelBufferRef _Nonnull)pixelBuffer
             withTimestamp:(CMTime)timestamp
                  rotation:(AgoraVideoRotation)rotation {
    [_consumer consumePixelBuffer:pixelBuffer withTimestamp:timestamp rotation:rotation];
}

@end
