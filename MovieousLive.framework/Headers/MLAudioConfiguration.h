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
 * Audio configuration class
 */
@interface MLAudioConfiguration : NSObject
<
MovieousMicrophoneConfiguration
>

/**
 * Audio input source, the default is MLAudioSourceMicrophone
 */
@property (nonatomic, assign) MLAudioSource source;

#pragma mark - microphone configurations

/**
 * Mute sound while recording, if you want to record a movie with no sound, you can specify source property in audioConfiguration to MLAudioSourceNone.
 * The default is NO.
 */
@property (nonatomic, assign) BOOL mute;

#pragma mark - encoder configurations

/**
 * Audio encoding rate bitRate.
 * The default is 128 * 1024.
 */
@property (assign, nonatomic) UInt32 bitrate;

/**
 * Create a default configuration of the MLAudioConfiguration instance
 *
 * @return Create a default object of MLAudioConfiguration
 */
+ (instancetype)defaultConfiguration;

@end

NS_ASSUME_NONNULL_END
