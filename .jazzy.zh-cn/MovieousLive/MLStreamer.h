//
//  MLStreamer.h
//  MovieousLive
//
//  Created by Chris Wang on 2019/3/22.
//  Copyright © 2019 Movieous Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLVideoConfiguration.h"
#import "MLAudioConfiguration.h"
#import "MLStreamStatistics.h"

NS_ASSUME_NONNULL_BEGIN

@class MLStreamer;

/**
 * 接收推流器回调的代理协议。
 */
@protocol MLStreamerDelegate <NSObject>

@optional
/**
 * 当推流发生错误时调用。
 *
 * @param streamer 发生错误的推流器。
 * @param error 发生的具体错误。
 */
- (void)streamer:(MLStreamer *)streamer didFailedWithError:(NSError *)error;

/**
 * 当推流统计数据发生更新时回调，你需要先调用 `- (void)startStreamStatisticsUpdateWithInterval:` 才能获取统计数据更新。
 *
 * @param streamer 发生更新的推流器。
 * @param streamStatistics 最新流状态统计数据。
 */
- (void)streamer:(MLStreamer *)streamer streamStatisticsDidUpdated:(MLStreamStatistics *)streamStatistics;

@end

/**
 * 直播推流器核心类。
 */
@interface MLStreamer : NSObject

/**
 * 预览视图。
 */
@property (nonatomic, strong, readonly) UIView *previewView;

/**
 * 推流远端服务器地址。
 */
@property (nonatomic, strong, nullable, readonly) NSURL *serverURL;

/**
 * 当前是否处于正在采集的状态。
 */
@property (nonatomic, assign, readonly) BOOL capturing;

/**
 * 当前推流器是否正在运行。
 */
@property (nonatomic, assign, readonly) BOOL running;

/**
 * 接收事件回调的代理对象。
 */
@property (nonatomic, weak, nullable) id<MLStreamerDelegate> delegate;

/**
 * 代理方法回调使用的队列，如果未指定将在主线程回调。
 */
@property (nonatomic, strong, nullable) dispatch_queue_t delegateQueue;

/**
 * 视频参数配置对象。
 *
 * @warning 请不要修改获取到的 videoConfiguration 对象，否则会出现未定义的错误，更新参数请使用相关运行时属性更新接口或销毁当前 Recorder 重新生成。
 */
@property (nonatomic, strong, readonly) MLVideoConfiguration *videoConfiguration;

/**
 * 音频参数配置对象。
 *
 * @warning 请不要修改获取到的 videoConfiguration 对象，否则会出现未定义的错误，更新参数请使用相关运行时属性更新接口或销毁当前 Recorder 重新生成。
 */
@property (nonatomic, strong, readonly) MLAudioConfiguration *audioConfiguration;

/**
 * 采集时应用的特效组。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, copy) NSArray<id<MovieousCaptureEffect>> *captureEffects;

/**
 * 当 size（编码时的视频分辨率） 和 preview 的尺寸比例不一致时使用的填充模式。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) MovieousScalingMode previewScalingMode;

/**
 * 是否对前置摄像头预览进行镜像处理。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) BOOL mirrorFrontPreview;

/**
 * 是否对后置摄像头预览进行镜像处理。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) BOOL mirrorBackPreview;

/**
 * 是否对前置摄像头编码的视频进行镜像处理。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) BOOL mirrorFrontEncoded;

/**
 * 是否对后置摄像头编码的视频进行镜像处理。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) BOOL mirrorBackEncoded;

/**
 * 切换摄像头时是否进行模糊化过渡
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) BOOL blurSwitch;

/**
 * 是否开启点击屏幕来设置对焦和曝光参考点。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) BOOL touchToFocusExposureEnabled;

/**
 * 是否开启内置的对焦视图。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) BOOL innerFocusViewEnabled;

/**
 * 当前摄像头的手电筒模式。
 */
@property (nonatomic, assign, readonly) AVCaptureTorchMode torchMode;

/**
 * 指定期望的摄像头手电筒模式，需要注意的是 preferredTorchMode 的值不一定能够被成功应用，实际的手电筒模式可以通过 MSVRecorder.torchMode 来获取。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) AVCaptureTorchMode preferredTorchMode;

/**
 * 当前摄像头的闪光灯模式。
 */
@property (nonatomic, assign, readonly) AVCaptureFlashMode flashMode;

/**
 * 指定期望的摄像头闪光灯模式，需要注意的是 preferredFlashMode 的值不一定能够被成功应用，实际的手电筒模式可以通过 MSVRecorder.flashMode 来获取。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) AVCaptureFlashMode preferredFlashMode;

/**
 * 指示当前摄像头支持的帧率范围。
 * videoSupportedFrameRateRanges 是一个 AVFrameRateRange 的数组，指示支持的帧率范围。
 */
@property(nonatomic, readonly) NSArray<AVFrameRateRange *> *videoSupportedFrameRateRanges;

/**
 * 当前摄像头的每秒最小帧率。
 */
@property (nonatomic, assign, readonly) Float64 minFrameRate;

/**
 * 指定期望的最小采集帧率，需要注意的是 preferredMinFrameRate 的值不一定能够被成功应用，实际的最小采集帧率可以通过 MSVRecorder.minFrameRate 来获取。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) Float64 preferredMinFrameRate;

/**
 * 当前摄像头的每秒最大帧率。
 */
@property (nonatomic, assign, readonly) Float64 maxFrameRate;

/**
 * 指定期望的最大采集帧率，需要注意的是 preferredMaxFrameRate 的值不一定能够被成功应用，实际的最大采集帧率可以通过 MSVRecorder.maxFrameRate 来获取。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) Float64 preferredMaxFrameRate;

/**
 * 当前摄像头的预设分辨率。
 */
@property (nonatomic, strong, readonly) AVCaptureSessionPreset sessionPreset;

/**
 * 指定期望的采集预设分辨率，需要注意的是 preferredSessionPreset 的值不一定能够被成功应用，实际的采集预设分辨率可以通过 MSVRecorder.sessionPreset 来获取。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) AVCaptureSessionPreset preferredSessionPreset;

/**
 * 当前摄像头的位置。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign, readonly) AVCaptureDevicePosition devicePosition;

/**
 * 指定期望的摄像头位置，需要注意的是 preferredDevicePosition 的值不一定能够被成功应用，实际的摄像头位置可以通过 MSVRecorder.devicePosition 来获取。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) AVCaptureDevicePosition preferredDevicePosition;

/**
 * 当前摄像头的方向。
 */
@property (nonatomic, assign, readonly) AVCaptureVideoOrientation videoOrientation;

/**
 * 指定期望的摄像头方向，需要注意的是 preferredVideoOrientation 的值不一定能够被成功应用，实际的摄像头方向可以通过 MSVRecorder.videoOrientation 来获取。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) AVCaptureVideoOrientation preferredVideoOrientation;

/**
 * 最大可应用的缩放比例。
 */
@property (nonatomic, assign, readonly) CGFloat videoMaxZoomFactor;

/**
 * 当前的缩放比例。
 */
@property (nonatomic, assign, readonly) CGFloat videoZoomFactor;

/**
 * 指定期望的视频缩放比例，需要注意的是 preferredVideoZoomFactor 的值不一定能够被成功应用，实际的视频缩放比例可以通过 MSVRecorder.videoZoomFactor 来获取。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) CGFloat preferredVideoZoomFactor;

/**
 * 当前是否开启持续自动对焦的配置。。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 *
 * @discussion 开启持续自动对焦即设备在需要的时候自动调节对焦参考点。
 */
@property (nonatomic, assign, readonly) BOOL continuousAutoFocusEnable;

/**
 * 指定期望是否开启持续自动对焦，需要注意的是 preferredContinuousAutoFocusEnable 的值不一定能够被成功应用，实际是否开启持续自动对焦可以通过 MSVRecorder.continuousAutoFocusEnable 来获取。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) BOOL preferredContinuousAutoFocusEnable;

/**
 * 指示当前的对焦参考点。
 *
 * @discussion 此属性的值是一个决定对焦参考点的 CGPoint，(0,0) 点代表图片的左上角，(1,1)点代表图片的右下角。默认值为 (0.5,0.5)。
 */
@property (nonatomic, assign, readonly) CGPoint focusPointOfInterest;

/**
 * 指定期望的对焦参考点，需要注意的是 preferredFocusPointOfInterest 的值不一定能够被成功应用，实际的对焦参考点可以通过 MSVRecorder.focusPointOfInterest 来获取。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) CGPoint preferredFocusPointOfInterest;

/**
 * 当前的是否开启持续自动曝光状态
 *
 * @discussion 开启持续自动曝光即设备在需要的时候自动调节曝光参考点。
 */
@property (nonatomic, assign, readonly) BOOL continuousAutoExposureEnable;

/**
 * 指定期望是否开启持续自动曝光调节，需要注意的是 preferredContinuousAutoExposureEnable 的值不一定能够被成功应用，实际是否开启持续自动曝光调节可以通过 
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) BOOL preferredContinuousAutoExposureEnable;

/*!
 * 指示当前的曝光参考点。
 *
 * @discussion 此属性的值是一个决定曝光参考点的 CGPoint，(0,0) 点代表图片的左上角，(1,1)点代表图片的右下角。默认值为 (0.5,0.5)。
 */
@property (nonatomic, assign, readonly) CGPoint exposurePointOfInterest;

/**
 * 指定期望的曝光参考点，需要注意的是 preferredExposurePointOfInterest 的值不一定能够被成功应用，实际的曝光参考点可以通过 MSVRecorder.exposurePointOfInterest 来获取。
 * 默认和初始化录制器使用的 videoConfiguration 一致。
 */
@property (nonatomic, assign) CGPoint preferredExposurePointOfInterest;

/**
 * 录制过程中是否静音，如果你想录制整段没有音频的视频，你可以在 audioConfiguration 中指定 source 为 MSVAudioSourceNone。
 * 默认和初始化录制器使用的 audioConfiguration 一致。
 */
@property (nonatomic, assign) BOOL mute;

/**
 * 实例化一个 MLStreamer 对象。
 *
 * @param audioConfiguration 音频配置对象，传入 nil 代表使用默认音频配置。
 * @param videoConfiguration 视频配置对象，传入 nil 代表使用默认视频配置。
 * @param outError 如果发生错误，返回错误对象。
 * 
 * @return 如果操作成功返回 YES，否则返回 NO。
 */
+ (instancetype _Nullable)streamerWithAudioConfiguration:(MLAudioConfiguration *_Nullable)audioConfiguration videoConfiguration:(MLVideoConfiguration *_Nullable)videoConfiguration error:(NSError *_Nullable *_Nullable)outError;

/**
 * 初始化一个 MLStreamer 对象。
 *
 * @param audioConfiguration 音频配置对象，传入 nil 代表使用默认音频配置。
 * @param videoConfiguration 视频配置对象，传入 nil 代表使用默认视频配置。
 * @param outError 如果发生错误，返回错误对象。
 * 
 * @return 如果操作成功返回 YES，否则返回 NO。
 */
- (instancetype)initWithAudioConfiguration:(MLAudioConfiguration *_Nullable)audioConfiguration videoConfiguration:(MLVideoConfiguration *_Nullable)videoConfiguration error:(NSError *_Nullable *_Nullable)outError;

/**
 * 开始采集音视频，调用此方法将请求音视频的使用权限（如果指定音视频数据源为摄像头或麦克风的话）。
 *
 * @param completionHandler 调用完成的回调，audioGranted：是否获得音频权限，audioError：音频组件初始化发生的错误，videoGranted：是否获得了视频的采集权限，videoError：视频组件初始化发生的错误。
 */
- (void)startCapturingWithCompletion:(void(^)(BOOL audioGranted, NSError *_Nullable audioError, BOOL videoGranted, NSError *_Nullable videoError))completionHandler;

/**
 * 结束采集。.
 */
- (void)stopCapturing;

/**
 * 开始推流。
 *
 * @param serverURL 远端服务器地址，必须为 "rtmp://" 开头。
 * @param outError 如果发生错误，返回错误对象。
 * 
 * @return 如果操作成功返回 YES，否则返回 NO。
 */
- (BOOL)startPushingWithServerURL:(NSURL *)serverURL error:(NSError *_Nullable *_Nullable)outError;

/**
 * 停止推流。
 */
- (void)stopPushing;

/**
 * 切换摄像头。
 */
- (void)switchCamera;

/**
 * 外部写入视频数据接口，使用该接口导入视频数据请保证配置 videoConfiguration.source = MSVVideoSourceExtern。
 *
 * @param videoData 待写入的视频数据。
 * @param presentationTime 视频数据的显示时间戳。
 * @param outError 如果发生错误，返回错误对象。
 * 
 * @return 如果操作成功返回 YES，否则返回 NO。
 */
- (BOOL)writeVideoData:(CVPixelBufferRef)videoData presentationTime:(CMTime)presentationTime error:(NSError *_Nullable *_Nullable)outError;

/**
 * 外部写入视频数据接口，使用该接口导入视频数据请保证配置 videoConfiguration.source = MSVVideoSourceExtern。
 *
 * @param videoData 待写入的视频数据。
 * @param outError 如果发生错误，返回错误对象。
 * 
 * @return 如果操作成功返回 YES，否则返回 NO。
 */
- (BOOL)writeVideoData:(CMSampleBufferRef)videoData error:(NSError *_Nullable *_Nullable)outError;

/**
 * 外部写入视频数据接口，使用该接口导入视频数据请保证配置 videoConfiguration.source = MSVVideoSourceExtern。
 *
 * @param videoData 待写入的视频数据。
 * @param outError 如果发生错误，返回错误对象。
 * 
 * @return 如果操作成功返回 YES，否则返回 NO。
 */
- (BOOL)writeAudioData:(CMSampleBufferRef)audioData error:(NSError *_Nullable *_Nullable)outError;

/**
 * 获取视频快照。
 * 
 * @param completionHandler 获取快照完成回调。
 */
- (void)snapshotWithCompletion:(MovieousSnapshotCompletionHandler)completionHandler;
/**
 * 开始更新流统计数据。
 */
- (void)startStreamStatisticsUpdateWithInterval:(NSTimeInterval)interval;

/**
 * 停止更新流统计数据。
 */
- (void)stopStreamStatisticsUpdate;

@end

NS_ASSUME_NONNULL_END
