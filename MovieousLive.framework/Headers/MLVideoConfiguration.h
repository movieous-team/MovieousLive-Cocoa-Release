//
//  MLVideoConfiguration.h
//  MovieousLive
//
//  Created by Chris Wang on 2019/3/22.
//  Copyright © 2019 Movieous Team. All rights reserved.
//

#import "MLTypeDefines.h"
#import <MovieousBase/MovieousBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLVideoConfiguration : NSObject
<
MovieousCameraConfiguration
>

/**
 * @brief Video input source, the default is MLAudioSourceMicrophone
 */
@property (nonatomic, assign) MLVideoSource source;

#pragma mark - camera configurations
/**
 * @brief   Video resolution when encoding. The default is (1280, 720)
 * @discussion It should be noted that this parameter affects the resolution of the video encoding, rather than the preview size of the data captured by the camera. When the image size passed to the encoder is different from this size, it will be generated in the same way The video ensures that the image does not appear to be compressed (but the cropping phenomenon occurs when the ratio of the encoded video is different from the ratio of the captured video).
 */
@property (nonatomic, assign) CGSize size;

/**
 * @brief Effects applied to recorder.
 */
@property (nonatomic, strong) NSArray<id<MovieousCaptureEffect>> *captureEffects;

/**
 * The scaling mode you want to use if the aspect ratio of cameraResolution and size are not equal
 * The default is MovieousScalingModeAspectFill
 */
@property (nonatomic, assign) MovieousScalingMode previewScalingMode;

/*!
 * Turn mirrorFrontPreview means preview for front camera will be mirrored
 * The default is YES
 */
@property (nonatomic, assign) BOOL mirrorFrontPreview;

/*!
 * Turn mirrorBackPreview means preview for back camera will be mirrored
 * The default is NO
 */
@property (nonatomic, assign) BOOL mirrorBackPreview;

/*!
 * Turn mirrorFrontStream means stream broadcasted for front camera will be mirrored
 * The default is NO
 */
@property (nonatomic, assign) BOOL mirrorFrontEncoded;

/*!
 * Turn mirrorBackStream means stream broadcasted for back camera will be mirrored
 * The default is NO
 */
@property (nonatomic, assign) BOOL mirrorBackEncoded;

/**
 * @brief Whether to enable touch to focus and exposure the specified point in the preview
 */
@property (nonatomic, assign) BOOL touchToFocusExposureEnabled;

/**
 * @brief Whether to open the internal focus view, the default is NO
 */
@property (nonatomic, assign) BOOL innerFocusViewEnabled;

/**
 * @brief Specify the preferred torch mode to use on camera, what needs to note is that the preferredTorchMode is not guaranteed to be applied succesfully, the actual torch mode can be accessed by the property torchMode
 */
@property (nonatomic, assign) AVCaptureTorchMode preferredTorchMode;

/**
 * @brief Specify the preferred minimum frames per second on camera, what needs to note is that the preferredMinFrameRate is not guaranteed to be applied succesfully, the actual minimum frames per second can be accessed by the property minFrameRate
 */
@property (nonatomic, assign) Float64 preferredMinFrameRate;

/**
 * @brief Specify the preferred maximum frames per second on camera, what needs to note is that the preferredMaxFrameRate is not guaranteed to be applied succesfully, the actual maximum frames per second can be accessed by the property maxFrameRate
 */
@property (nonatomic, assign) Float64 preferredMaxFrameRate;

/**
 * @brief Specify the resolution for capturing, what needs to note is that the preferredSessionPreset is not guaranteed to be applied succesfully, the actual resolution can be accessed by the property sessionPreset
 */
@property (nonatomic, strong) AVCaptureSessionPreset preferredSessionPreset;

/**
 * @brief Specify the Camera position for capturing, what needs to note is that the preferredDevicePosition is not guaranteed to be applied succesfully, the actual Camera position can be accessed by the property devicePosition
 */
@property (nonatomic, assign) AVCaptureDevicePosition preferredDevicePosition;

/**
 * @brief Specify the orientation of the camera, what needs to note is that the preferredVideoOrientation is not guaranteed to be applied succesfully, the actual Camera orientation can be accessed by the property videoOrientation
 */
@property (nonatomic, assign) AVCaptureVideoOrientation preferredVideoOrientation;

/**
 * @brief Specify the video zoom factor of the camera, what needs to note is that the preferredVideoZoomFactor is not guaranteed to be applied succesfully, the actual video zoom factor can be accessed by the property videoZoomFactor
 */
@property (nonatomic, assign) CGFloat preferredVideoZoomFactor;

/**
 * @brief Specify the continuousAutoFocusEnable status of the camera, what needs to note is that the preferredContinuousAutoFocusEnable is not guaranteed to be applied succesfully, the actual continuousAutoFocusEnable can be accessed by the property continuousAutoFocusEnable
 */
@property (nonatomic, assign) BOOL preferredContinuousAutoFocusEnable;

/**
 * @brief Specify the preferredFocusPointOfInterest status of the camera, what needs to note is that the preferredFocusPointOfInterest is not guaranteed to be applied succesfully, the actual focusPointOfInterest can be accessed by the property focusPointOfInterest
 */
@property (nonatomic, assign) CGPoint preferredFocusPointOfInterest;

/**
 * @brief Specify the preferredContinuousAutoExposureEnable of the camera, what needs to note is that the preferredContinuousAutoExposureEnable is not guaranteed to be applied succesfully, the actual continuousAutoExposureEnable can be accessed by the property continuousAutoExposureEnable
 */
@property (nonatomic, assign) BOOL preferredContinuousAutoExposureEnable;

/**
 * @brief Specify the preferredExposurePointOfInterest of the camera, what needs to note is that the preferredExposurePointOfInterest is not guaranteed to be applied succesfully, the actual exposurePointOfInterest can be accessed by the property exposurePointOfInterest
 */
@property (nonatomic, assign) CGPoint preferredExposurePointOfInterest;

#pragma mark - encoder configurations
/**
 * @brief The long-term desired average bit rate in bits per second.
 * @discussion
 *  This is not a hard limit; the bit rate may peak above this.
 *  The value zero indicates that the video encoder
 *  should determine the size of compressed data.The default bit rate is 1024 * 1024
 */
@property (nonatomic, assign) NSUInteger averageVideoBitRate;

/**
 * @brief The maximum interval between key frames, also known as the key frame rate.
 * @discussion
 *  Key frames, also known as sync frames, reset inter-frame
 *  dependencies; decoding a key frame is sufficient to prepare a
 *  decoder for correctly decoding the difference frames that
 *  follow.
 *  Video encoders are allowed to generate key frames more frequently if
 *  this would result in more efficient compression.
 *  The default key frame interval is 0, which indicates that the
 *  video encoder should choose where to place all key frames. A key
 *  frame interval of 1 indicates that every frame must be a key
 *  frame, 2 indicates that at least every other frame must be a key
 *  frame, etc.
 *
 *  This key can be set in conjunction with
 *  maxKeyFrameIntervalDuration,
 *  and both limits will be enforced - requiring a keyframe every X
 *  frames or every Y seconds, whichever comes first.
 */
@property (nonatomic, assign) NSUInteger maxKeyframeInterval;

/**
 * @brief The maximum duration from one key frame to the next in seconds.
 * @discussion
 *  Zero by default, which means no limit.
 *  This property is particularly useful when the frame rate is variable.
 *  See maxKeyframeInterval for more discussion
 *  of key frames.
 *
 *  This key can be set in conjunction with
 *  maxKeyframeInterval,
 *  and both limits will be enforced - requiring a keyframe every X
 *  frames or every Y seconds, whichever comes first.
 */
@property (nonatomic, assign) NSUInteger maxKeyFrameIntervalDuration;

/**
 * @brief Hints to the video encoder that it should maximize power efficiency during encode.
 * @discussion
 *  For compression where the client is operating in the background, clients may set this property to YES, which indicates that
 *  the encoder can take steps to minimize impact on power usage and other system activity.
 *  By default, this property is NO.
 */
@property (nonatomic, assign) BOOL maximizePowerEfficiency API_AVAILABLE(macos(10.14), ios(12.0), tvos(12.0));

/**
 * @brief During H.264 encoding, the Profile Level will be used.
 * @discussion By default, AVVideoProfileLevelH264HighAutoLevel is used, if you have additional requirements for video encoding, you can change it yourself if understanding that the impacts  from this parameter.
 * @warning When you are not sure about the impact of this parameter change on resolution requirements, code rate, etc., please do not change it.
 */
@property (nonatomic, copy) NSString *videoProfileLevel;

/**
 * @brief Create a default configuration of the MLVideoConfiguration instance.
 * @return The created default MLVideoConfiguration object
 */
+ (instancetype)defaultConfiguration;

@end

NS_ASSUME_NONNULL_END
