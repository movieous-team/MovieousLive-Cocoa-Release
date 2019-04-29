//
//  MLStreamStatistics.h
//  MovieousLive
//
//  Created by Chris Wang on 2019/4/3.
//  Copyright © 2019 Movieous Team. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Statistics result.
 */
@interface MLStreamStatistics : NSObject

/**
 * The interval for the statistics.
 */
@property (nonatomic, assign) NSTimeInterval interval;

/**
 * The bytes of total(audio & video) data sent by the streamer.
 */
@property (nonatomic, assign) double bytesSent;

/**
 * The total(audio & video) bitrate for streamer.
 */
@property (nonatomic, assign, readonly) double bitrate;

/**
 * The bytes of video data sent by the streamer.
 */
@property (nonatomic, assign) double videoBytesSent;

/**
 * The video bitrate for streamer.
 */
@property (nonatomic, assign, readonly) double videoBitrate;

/**
 * The video frames captured within the statistic duration.
 */
@property (nonatomic, assign) double videoFramesCaptured;

/**
 * The video frames captured per seconds.
 */
@property (nonatomic, assign, readonly) double videoFPSCaptured;

/**
 * The total video frames sent.
 */
@property (nonatomic, assign) double videoFramesSent;

/**
 * The total video frames sent per seconds.
 */
@property (nonatomic, assign, readonly) double videoFPSSent;

/**
 * The audio data sent in bytes.
 */
@property (nonatomic, assign) double audioBytesSent;

/**
 * The audio bitrate.
 */
@property (nonatomic, assign, readonly) double audioBitrate;

/**
 * The audio frames captured.
 */
@property (nonatomic, assign) double audioFramesCaptured;

/**
 * The audio frames capotured per seconds.
 */
@property (nonatomic, assign, readonly) double audioFPSCaptured;

/**
 * The audio frames sent.
 */
@property (nonatomic, assign) double audioFramesSent;

/**
 * The audio frames sent per seconds.
 */
@property (nonatomic, assign, readonly) double audioFPSSent;

/**
 * Initialize the MLStreamStatistics object.
 *
 * @params interval Total interval.
 */
- (instancetype)initWithInterval:(NSTimeInterval)interval;

@end

NS_ASSUME_NONNULL_END
