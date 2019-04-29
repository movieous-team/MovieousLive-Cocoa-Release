//
//  MLTypeDefines.h
//  MovieousLive
//
//  Created by Chris Wang on 2019/3/22.
//  Copyright © 2019 Movieous Team. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 视频输入源类型。
 */
typedef NS_ENUM(NSInteger, MLVideoSource) {
    /**
     * 无视频源，请不要同时将视频和音频源设置为无。
     */
    MLVideoSourceNone,
    /**
     * 摄像头视频源。
     */
    MLVideoSourceCamera,
    /**
     * 外部视频源
     *
     * @warning 当你使用此输入源时，请使用 `writeVideoData:error:` 方法来写入视频数据，如果你使用 MSVVideoSourceExtern 但是又不写入视频数据，未知的错误将会产生。
     */
    MLVideoSourceExtern,
};

/**
 * 音频输入源。
 */
typedef NS_ENUM(NSInteger, MLAudioSource) {
    /**
     * 无音频输入源，请不要同时将视频和音频源设置为无。
     */
    MLAudioSourceNone,
    /**
     * 麦克风音频输入源。
     */
    MLAudioSourceMicrophone,
    /**
     * 外部音频输入源。
     *
     * @warning 当你使用此输入源时，请使用 `writeAudioData:error:` 方法来写入音频数据，如果你使用 MSVAudioSourceExtern 但是又不写入音频数据，未知的错误将会产生。
     */
    MLAudioSourceExtern,
};
