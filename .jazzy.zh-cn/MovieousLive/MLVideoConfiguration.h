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

/**
 * Video configuration class
 */
@interface MLVideoConfiguration : NSObject
<
MovieousCameraConfiguration
>

/**
 * Video input source.
 * The default is MLAudioSourceMicrophone.
 */
@property (nonatomic, assign) MLVideoSource source;

#pragma mark - camera configurations
/**
 * Video 编码时的视频分辨率，默认 (1280, 720)。
 *
 * @discussion 需要注意的是，这个参数影响的是视频编码时的分辨率，而非摄像头采集到数据的预览大小，传递给编码器的图像尺寸与此尺寸不同时，会按照保持比例并填充的方式生成最终的视频，从而确保图像不会出现压缩的现象（但编码视频的比例与采集视频的比例不同时会出现裁剪的现象）。
 */
@property (nonatomic, assign) CGSize size;

/**
 * Effects applied to recorder.
 */
@property (nonatomic, strong) NSArray<id<MovieousCaptureEffect>> *captureEffects;

/**
 * The scaling mode you want to use if the aspect ratio of cameraResolution and size are not equal.
 * The default is MovieousScalingModeAspectFill.
 */
@property (nonatomic, assign) MovieousScalingMode previewScalingMode;

/*!
 * Turn mirrorFrontPreview means preview for front camera will be mirrored.
 * The default is YES.
 */
@property (nonatomic, assign) BOOL mirrorFrontPreview;

/*!
 * Turn mirrorBackPreview means preview for back camera will be mirrored.
 * The default is NO.
 */
@property (nonatomic, assign) BOOL mirrorBackPreview;

/*!
 * Turn mirrorFrontStream means stream broadcasted for front camera will be mirrored.
 * The default is NO.
 */
@property (nonatomic, assign) BOOL mirrorFrontEncoded;

/*!
 * Turn mirrorBackStream means stream broadcasted for back camera will be mirrored
 * The default is NO.
 */
@property (nonatomic, assign) BOOL mirrorBackEncoded;

/**
 * Whether to enable touch to focus and exposure the specified point in the preview.
 * The default is YES.
 */
@property (nonatomic, assign) BOOL touchToFocusExposureEnabled;

/**
 * Whether to open the internal focus view.
 * The default is NO.
 */
@property (nonatomic, assign) BOOL innerFocusViewEnabled;

/**
 * Specify the preferred torch mode to use on camera, what needs to note is that the preferredTorchMode is not guaranteed to be applied succesfully, the actual torch mode can be accessed by the property torchMode.
 * The default is AVCaptureTorchModeAuto
 */
@property (nonatomic, assign) AVCaptureTorchMode preferredTorchMode;

/**
 * Specify the preferred minimum frames per second on camera, what needs to note is that the preferredMinFrameRate is not guaranteed to be applied succesfully, the actual minimum frames per second can be accessed by the property minFrameRate.
 * The default is 24.
 */
@property (nonatomic, assign) Float64 preferredMinFrameRate;

/**
 * Specify the preferred maximum frames per second on camera, what needs to note is that the preferredMaxFrameRate is not guaranteed to be applied succesfully, the actual maximum frames per second can be accessed by the property maxFrameRate.
 * The default is 30.
 */
@property (nonatomic, assign) Float64 preferredMaxFrameRate;

/**
 * Specify the resolution for capturing, what needs to note is that the preferredSessionPreset is not guaranteed to be applied succesfully, the actual resolution can be accessed by the property sessionPreset.
 * The default is AVCaptureSessionPresetHigh.
 */
@property (nonatomic, strong) AVCaptureSessionPreset preferredSessionPreset;

/**
 * Specify the Camera position for capturing, what needs to note is that the preferredDevicePosition is not guaranteed to be applied succesfully, the actual Camera position can be accessed by the property devicePosition.
 * The default is AVCaptureDevicePositionFront.
 */
@property (nonatomic, assign) AVCaptureDevicePosition preferredDevicePosition;

/**
 * Specify the orientation of the camera, what needs to note is that the preferredVideoOrientation is not guaranteed to be applied succesfully, the actual Camera orientation can be accessed by the property videoOrientation.
 * The default is AVCaptureVideoOrientationPortrait.
 */
@property (nonatomic, assign) AVCaptureVideoOrientation preferredVideoOrientation;

/**
 * Specify the video zoom factor of the camera, what needs to note is that the preferredVideoZoomFactor is not guaranteed to be applied succesfully, the actual video zoom factor can be accessed by the property videoZoomFactor.
 * The default is 1.
 */
@property (nonatomic, assign) CGFloat preferredVideoZoomFactor;

/**
 * Specify the continuousAutoFocusEnable status of the camera, what needs to note is that the preferredContinuousAutoFocusEnable is not guaranteed to be applied succesfully, the actual continuousAutoFocusEnable can be accessed by the property continuousAutoFocusEnable.
 * The default is YES.
 */
@property (nonatomic, assign) BOOL preferredContinuousAutoFocusEnable;

/**
 * Specify the preferredFocusPointOfInterest status of the camera, what needs to note is that the preferredFocusPointOfInterest is not guaranteed to be applied succesfully, the actual focusPointOfInterest can be accessed by the property focusPointOfInterest.
 * The default is CGPointMake(0.5, 0.5).
 */
@property (nonatomic, assign) CGPoint preferredFocusPointOfInterest;

/**
 * Specify the preferredContinuousAutoExposureEnable of the camera, what needs to note is that the preferredContinuousAutoExposureEnable is not guaranteed to be applied succesfully, the actual continuousAutoExposureEnable can be accessed by the property continuousAutoExposureEnable.
 * The default is YES.
 */
@property (nonatomic, assign) BOOL preferredContinuousAutoExposureEnable;

/**
 * Specify the preferredExposurePointOfInterest of the camera, what needs to note is that the preferredExposurePointOfInterest is not guaranteed to be applied succesfully, the actual exposurePointOfInterest can be accessed by the property exposurePointOfInterest.
 * The default is CGPointMake(0.5, 0.5).
 */
@property (nonatomic, assign) CGPoint preferredExposurePointOfInterest;

#pragma mark - encoder configurations
/**
 * Average video encoding rate.
 * The default is 1024 * 1024(1 mbps).
 *
 * @discussion unit is bps(Bits per Second). The parameters of the video encoding are not constant values in the actual process, so the average video encoding rate can be set only.
 */
@property (nonatomic, assign) NSUInteger averageVideoBitRate;

/**
 * The maximum interval between key frames, also known as the key frame rate.
 *
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
 * The maximum duration from one key frame to the next in seconds.
 *
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
 * Hints to the video encoder that it should maximize power efficiency during encode.
 *
 * @discussion
 * For compression where the client is operating in the background, clients may set this property to YES, which indicates that
 *  the encoder can take steps to minimize impact on power usage and other system activity.
 *  By default, this property is NO.
 */
@property (nonatomic, assign) BOOL maximizePowerEfficiency API_AVAILABLE(macos(10.14), ios(12.0), tvos(12.0));

/**
 * During H.264 encoding, the Profile Level will be used.
 * The default is AVVideoProfileLevelH264HighAutoLevel.
 *
 * @discussion By default, AVVideoProfileLevelH264HighAutoLevel is used, if you have additional requirements for video encoding, you can change it yourself if understanding that the impacts  from this parameter.
 *
 * @warning When you are not sure about the impact of this parameter change on resolution requirements, code rate, etc., please do not change it.
 */
@property (nonatomic, copy) NSString *videoProfileLevel;

/**
 * Create a default configuration of the MLVideoConfiguration instance.
 *
 * @return The created default MLVideoConfiguration object
 */
+ (instancetype)defaultConfiguration;

@end

NS_ASSUME_NONNULL_END
