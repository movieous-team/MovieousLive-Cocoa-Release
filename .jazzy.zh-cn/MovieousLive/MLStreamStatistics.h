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
 * 流状态统计结果。
 */
@interface MLStreamStatistics : NSObject

/**
 * 流状态统计周期。
 */
@property (nonatomic, assign) NSTimeInterval interval;

/**
 * 统计周期内音视频发送的总字节数。
 */
@property (nonatomic, assign) double bytesSent;

/**
 * 统计周期内的音视频总码率。
 */
@property (nonatomic, assign, readonly) double bitrate;

/**
 * 统计周期内视频发送的字节数。
 */
@property (nonatomic, assign) double videoBytesSent;

/**
 * 统计周期内的视频码率。
 */
@property (nonatomic, assign, readonly) double videoBitrate;

/**
 * 统计周期内的视频采集总帧数。
 */
@property (nonatomic, assign) double videoFramesCaptured;

/**
 * 统计周期内的视频采集帧率。
 */
@property (nonatomic, assign, readonly) double videoFPSCaptured;

/**
 * 统计周期内的视频发送总帧数。
 */
@property (nonatomic, assign) double videoFramesSent;

/**
 * 统计周期内的视频发送帧率。
 */
@property (nonatomic, assign, readonly) double videoFPSSent;

/**
 * 统计周期内的音频发送总字节数。
 */
@property (nonatomic, assign) double audioBytesSent;

/**
 * 统计周期内的音频码率。
 */
@property (nonatomic, assign, readonly) double audioBitrate;

/**
 * 统计周期内的音频采集帧数（一帧为 1024 个采样点）。
 */
@property (nonatomic, assign) double audioFramesCaptured;

/**
 * 统计周期内的音频采集帧率。
 */
@property (nonatomic, assign, readonly) double audioFPSCaptured;

/**
 * 统计周期内音频的发送帧数。
 */
@property (nonatomic, assign) double audioFramesSent;

/**
 * 统计周期内音频的发送帧率。
 */
@property (nonatomic, assign, readonly) double audioFPSSent;

/**
 * 初始化一个 MLStreamStatistics 对象。
 *
 * @params interval 统计周期。
 */
- (instancetype)initWithInterval:(NSTimeInterval)interval;

@end

NS_ASSUME_NONNULL_END
