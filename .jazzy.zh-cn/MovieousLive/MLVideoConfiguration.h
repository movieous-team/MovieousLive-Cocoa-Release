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
 * 录制视频配置对象
 */
@interface MLVideoConfiguration : NSObject
<
MovieousCameraConfiguration
>

/**
 * 视频输入源类型。
 * 默认为 MLAudioSourceMicrophone.
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
 * 采集时应用的特效组。
 */
@property (nonatomic, strong) NSArray<id<MovieousCaptureEffect>> *captureEffects;

/**
 * 当 size（编码时的视频分辨率） 和 preview 的尺寸比例不一致时使用的填充模式。
 * 默认为 MovieousScalingModeAspectFill。
 */
@property (nonatomic, assign) MovieousScalingMode previewScalingMode;

/*!
 * 是否对前置摄像头预览进行镜像处理。
 * 默认为 YES。
 */
@property (nonatomic, assign) BOOL mirrorFrontPreview;

/*!
 * 是否对后置摄像头预览进行镜像处理。
 * 默认为 NO。
 */
@property (nonatomic, assign) BOOL mirrorBackPreview;

/*!
 * 是否对前置摄像头编码的视频进行镜像处理。
 * 默认为 NO。
 */
@property (nonatomic, assign) BOOL mirrorFrontEncoded;

/*!
 * 是否对后置摄像头编码的视频进行镜像处理。
 * 默认为 NO。
 */
@property (nonatomic, assign) BOOL mirrorBackEncoded;

/**
 * 是否开启点击屏幕来设置对焦和曝光参考点。
 * 默认为 YES。
 */
@property (nonatomic, assign) BOOL touchToFocusExposureEnabled;

/**
 * 是否开启内置的对焦视图。
 * 默认为 NO。
 */
@property (nonatomic, assign) BOOL innerFocusViewEnabled;

/**
 * 指定期望的摄像头手电筒模式，需要注意的是 preferredTorchMode 的值不一定能够被成功应用，实际的手电筒模式可以通过 MSVRecorder.torchMode 来获取。
 * 默认为 AVCaptureTorchModeAuto。
 */
@property (nonatomic, assign) AVCaptureTorchMode preferredTorchMode;

/**
 * 指定期望的摄像头闪光灯模式，需要注意的是 preferredFlashMode 的值不一定能够被成功应用，实际的闪光灯模式可以通过 MSVRecorder.flashMode 来获取。
 * 默认为 AVCaptureFlashModeAuto。
 */
@property (nonatomic, assign) AVCaptureFlashMode preferredFlashMode;

/**
 * 指定期望的最小采集帧率，需要注意的是 preferredMinFrameRate 的值不一定能够被成功应用，实际的最小采集帧率可以通过 MSVRecorder.minFrameRate 来获取。
 * 默认为 24。
 */
@property (nonatomic, assign) Float64 preferredMinFrameRate;

/**
 * 指定期望的最大采集帧率，需要注意的是 preferredMaxFrameRate 的值不一定能够被成功应用，实际的最大采集帧率可以通过 MSVRecorder.maxFrameRate 来获取。
 * 默认为 30。
 */
@property (nonatomic, assign) Float64 preferredMaxFrameRate;

/**
 * 指定期望的采集预设分辨率，需要注意的是 preferredSessionPreset 的值不一定能够被成功应用，实际的采集预设分辨率可以通过 MSVRecorder.sessionPreset 来获取。
 * 默认为 AVCaptureSessionPresetHigh。
 */
@property (nonatomic, strong) AVCaptureSessionPreset preferredSessionPreset;

/**
 * 指定期望的摄像头位置，需要注意的是 preferredDevicePosition 的值不一定能够被成功应用，实际的摄像头位置可以通过 MSVRecorder.devicePosition 来获取。
 * 默认为 AVCaptureDevicePositionFront。
 */
@property (nonatomic, assign) AVCaptureDevicePosition preferredDevicePosition;

/**
 * 指定期望的摄像头方向，需要注意的是 preferredVideoOrientation 的值不一定能够被成功应用，实际的摄像头方向可以通过 MSVRecorder.videoOrientation 来获取。
 * 默认为 AVCaptureVideoOrientationPortrait。
 */
@property (nonatomic, assign) AVCaptureVideoOrientation preferredVideoOrientation;

/**
 * 指定期望的视频缩放比例，需要注意的是 preferredVideoZoomFactor 的值不一定能够被成功应用，实际的视频缩放比例可以通过 MSVRecorder.videoZoomFactor 来获取。
 * 默认为 1。
 */
@property (nonatomic, assign) CGFloat preferredVideoZoomFactor;

/**
 * 指定期望是否开启持续自动对焦，需要注意的是 preferredContinuousAutoFocusEnable 的值不一定能够被成功应用，实际是否开启持续自动对焦可以通过 MSVRecorder.continuousAutoFocusEnable 来获取。
 * 默认为 YES。
 */
@property (nonatomic, assign) BOOL preferredContinuousAutoFocusEnable;

/**
 * 指定期望的对焦参考点，需要注意的是 preferredFocusPointOfInterest 的值不一定能够被成功应用，实际的对焦参考点可以通过 MSVRecorder.focusPointOfInterest 来获取。
 * 默认为 CGPointMake(0。5, 0。5)。
 */
@property (nonatomic, assign) CGPoint preferredFocusPointOfInterest;

/**
 * 指定期望是否开启持续自动曝光调节，需要注意的是 preferredContinuousAutoExposureEnable 的值不一定能够被成功应用，实际是否开启持续自动曝光调节可以通过 MSVRecorder.continuousAutoExposureEnable 来获取。
 * 默认为 YES。
 */
@property (nonatomic, assign) BOOL preferredContinuousAutoExposureEnable;

/**
 * 指定期望的曝光参考点，需要注意的是 preferredExposurePointOfInterest 的值不一定能够被成功应用，实际的曝光参考点可以通过 MSVRecorder.exposurePointOfInterest 来获取。
 * 默认为 CGPointMake(0.5, 0.5)。
 */
@property (nonatomic, assign) CGPoint preferredExposurePointOfInterest;

#pragma mark - encoder configurations
/**
 * 平均视频编码码率。默认为 1024*1000
 * 
 * @discussion 单位为 bps(Bits per Second)。该参数的视频编码实际过程中，并不是恒定的数值，所以只能设定平均视频编码码率。
 */
@property (nonatomic, assign) NSUInteger averageVideoBitRate;

/**
 * 关键帧之间的最大帧数（关键帧率）。
 *
 * @discussion
 *  关键帧也就是同步帧，它重置非关键帧之间的依赖；解码关键帧能够让解码器正确解码后续的非关键帧。视频编码器将更频繁地生成关键帧。默认的关键帧间隔为 0，表示视频编码器自由选择怎样放置关键帧。关键帧间隔为 1 的话表示每帧都是关键帧，2 表示至少每隔一帧就有一帧关键帧，以此类推。
 *  此属性能够与 maxKeyFrameIntervalDuration 同时配置，此时它们将同时生效，不论 X 帧还是 Y 秒先到，都将生成一帧关键帧。
 */
@property (nonatomic, assign) NSUInteger maxKeyframeInterval;

/**
 * 最大关键帧间隔时长，单位为秒。
 *
 * @discussion
 *  默认为 0，也就是没有限制。
 *  该属性当帧率为变化时非常有用。
 *  参考 maxKeyframeInterval 属性获取更多关于的讨论。
 *
 *  此属性能够与 maxKeyframeInterval 同时配置，此时它们将同时生效，不论 X 帧还是 Y 秒先到，都将生成一帧关键帧。
 */
@property (nonatomic, assign) NSUInteger maxKeyFrameIntervalDuration;

/**
 * 暗示视频编码器它可以在编码时使用最节能的方式。
 *
 * @discussion
 * 针对在后台运行的客户端编码操作，客户端可以将此属性设置为 YES，表示编码器能够采取对电量和其他系统进程影响最小的方式进行压缩操作。
 * 此参数默认为 NO。
 */
@property (nonatomic, assign) BOOL maximizePowerEfficiency API_AVAILABLE(macos(10.14), ios(12.0), tvos(12.0));

/**
 * H.264 编码时使用的 Profile Level。
 * 
 * @discussion 默认情况下使用 AVVideoProfileLevelH264HighAutoLevel，如果对于视频编码有额外的需求并且知晓该参数带来的影响可以自行更改。
 * 
 * @warning 当你不清楚该参数更改对分辨率要求，码率等影响时，请不要随意更改。
 */
@property (nonatomic, copy) NSString *videoProfileLevel;

/**
 * 创建一个默认配置的 MLVideoConfiguration 实例。
 * 
 * @return 创建的默认 MLVideoConfiguration 对象。
 */
+ (instancetype)defaultConfiguration;

@end

NS_ASSUME_NONNULL_END
