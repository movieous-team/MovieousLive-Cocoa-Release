//
//  MLAudioConfiguration.h
//  MovieousLive
//
//  Created by Chris Wang on 2019/3/22.
//  Copyright © 2019 Movieous Team. All rights reserved.
//

#import "MLTypeDefines.h"
#import <MovieousBase/MovieousBase.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 音频配置类
 */
@interface MLAudioConfiguration : NSObject
<
MovieousMicrophoneConfiguration
>

/**
 * 音频输入源类型。
 * 默认为 MLAudioSourceMicrophone。
 */
@property (nonatomic, assign) MLAudioSource source;

#pragma mark - microphone configurations

/**
 * 推流时是否静音。
 * 默认为 NO。
 */
@property (nonatomic, assign) BOOL mute;

#pragma mark - encoder configurations

/**
 * 音频编码码率。
 * 默认为 128 * 1024。
 */
@property (assign, nonatomic) UInt32 bitrate;

/**
 * 创建一个默认的 MLAudioConfiguration 对象。
 *
 * @return 创建完成的对象。
 */
+ (instancetype)defaultConfiguration;

@end

NS_ASSUME_NONNULL_END
