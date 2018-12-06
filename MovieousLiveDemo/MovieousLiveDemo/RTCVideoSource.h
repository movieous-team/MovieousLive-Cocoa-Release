//
//  RTCVideoSource.h
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2018/12/7.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTCVideoSource : NSObject
<
AgoraVideoSourceProtocol
>

- (void)consumePixelBuffer:(CVPixelBufferRef _Nonnull)pixelBuffer
             withTimestamp:(CMTime)timestamp
                  rotation:(AgoraVideoRotation)rotation;

@end

NS_ASSUME_NONNULL_END
