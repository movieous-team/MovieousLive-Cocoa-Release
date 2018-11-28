//
//  MLAudioConfiguration.h
//  MovieousLive
//
//  Created by Chris Wang on 2018/8/29.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MLTypeDefines.h"

@interface MLAudioConfiguration : NSObject
<
NSCopying
>

/*!
 * Whether to enable audio broadcast
 * Default to YES
 */
@property (nonatomic, assign) BOOL enable;

/*!
 * The input source for audio
 * Default to MLAudioSourceMicrophone
 */
@property (nonatomic, assign) MLAudioSource source;

/*!
 * Whether to allow mix with other audio
 * Default to YES
 */
@property (nonatomic, assign) BOOL allowMixWithOthers;

/*!
 * Turn on this function to avoid acoustic echo.
 * Default to NO
 */
@property (nonatomic, assign) BOOL acousticEchoCancellationEnable;

/*!
 * The encoded audio bitrate
 * Default to MLAudioBitRate96Kbps
 */
@property (nonatomic, assign) MLAudioBitRate audioBitRate;

/*!
 * The default configuration
 * @return The initialized default configuration
 */
+ (instancetype)defaultConfiguration;

@end
