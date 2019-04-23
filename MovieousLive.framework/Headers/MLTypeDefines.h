//
//  MLTypeDefines.h
//  MovieousLive
//
//  Created by Chris Wang on 2019/3/22.
//  Copyright © 2019 Movieous Team. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Video input souce type
 */
typedef NS_ENUM(NSInteger, MLVideoSource) {
    /**
     * @brief No video，please don't set both video source and audio source to none.
     */
    MLVideoSourceNone,
    /**
     * @brief Camera input source
     */
    MLVideoSourceCamera,
    /**
     * @brief UIView input source, when you use this input source please specify viewForRecording property in `startRecordingWithClipConfiguration:error:` method
     */
    MLVideoSourceUIView,
    /**
     * @brief External video source
     * @warning When you use this input source, please use `writeVideoData:error:` to write video data, if you choose external video source but don't input video data, unknown error may come out
     */
    MLVideoSourceExtern,
};

/**
 * @brief Audio input source
 */
typedef NS_ENUM(NSInteger, MLAudioSource) {
    /**
     * @brief No audio，please don't set both video source and audio source to none.
     */
    MLAudioSourceNone,
    /**
     * @brief Microphone input source.
     */
    MLAudioSourceMicrophone,
    /**
     * @brief External input source
     * @warning You must use `writeAudioData:error:` method to input audio data when use this input source, if you choose external audio source but don't input audio data, unknown error may come out
     */
    MLAudioSourceExtern,
};
