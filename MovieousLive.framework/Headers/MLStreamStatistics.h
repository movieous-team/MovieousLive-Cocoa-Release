//
//  MLStreamStatistics.h
//  MovieousLive
//
//  Created by Chris Wang on 2019/4/3.
//  Copyright © 2019 Movieous Team. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLStreamStatistics : NSObject

/**
 * @brief The interval for the statistics
 */
@property (nonatomic, assign) NSTimeInterval interval;

/**
 * @brief The bytes of total(audio & video) data sent by the streamer
 */
@property (nonatomic, assign) double bytesSent;

/**
 * @brief The total(audio & video) bitrate for streamer
 */
@property (nonatomic, assign, readonly) double bitrate;

/**
 * @brief The bytes of video data sent by the streamer
 */
@property (nonatomic, assign) double videoBytesSent;

/**
 * @brief The video bitrate for streamer
 */
@property (nonatomic, assign, readonly) double videoBitrate;

/**
 * @brief The video frames captured within the statistic duration
 */
@property (nonatomic, assign) double videoFramesCaptured;

/**
 * @brief The video frames captured per seconds
 */
@property (nonatomic, assign, readonly) double videoFPSCaptured;

/**
 * @brief The total video frames sent
 */
@property (nonatomic, assign) double videoFramesSent;

/**
 * @brief The total video frames sent per seconds
 */
@property (nonatomic, assign, readonly) double videoFPSSent;

/**
 * @brief The audio data sent in bytes
 */
@property (nonatomic, assign) double audioBytesSent;

/**
 * @brief The audio bitrate
 */
@property (nonatomic, assign, readonly) double audioBitrate;

/**
 * @brief The audio frames captured
 */
@property (nonatomic, assign) double audioFramesCaptured;

/**
 * @brief The audio frames capotured per seconds
 */
@property (nonatomic, assign, readonly) double audioFPSCaptured;

/**
 * @brief The audio frames sent
 */
@property (nonatomic, assign) double audioFramesSent;

/**
 * @brief The audio frames sent per seconds
 */
@property (nonatomic, assign, readonly) double audioFPSSent;

/**
 * @brief Initialize the MLStreamStatistics object
 * @params interval Total interval
 */
- (instancetype)initWithInterval:(NSTimeInterval)interval;

@end

NS_ASSUME_NONNULL_END
