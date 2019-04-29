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
 * The delegate protocol used to receive streamer callbacks.
 */
@protocol MLStreamerDelegate <NSObject>

@optional
/**
 * Tell the delegate that the streamer has failed streaming because of some error.
 *
 * @param streamer The caller call the method.
 * @param error The specific error.
 */
- (void)streamer:(MLStreamer *)streamer didFailedWithError:(NSError *)error;

/**
 * Tell the delegate that the stream statistics has updated, you must call - (void)startStreamStatisticsUpdateWithInterval: first to start stream statistics update.
 *
 * @param streamer The caller call the method.
 * @param streamStatistics The stream statistics of the stream.
 */
- (void)streamer:(MLStreamer *)streamer streamStatisticsDidUpdated:(MLStreamStatistics *)streamStatistics;

@end

/**
 * Streamer used to broadcast video stream.
 */
@interface MLStreamer : NSObject

/**
 * Preview view.
 */
@property (nonatomic, strong, readonly) UIView *previewView;

/**
 * The remote server URL used to push stream.
 */
@property (nonatomic, strong, nullable, readonly) NSURL *serverURL;

/**
 * The running status of the streamer.
 */
@property (nonatomic, assign, readonly) BOOL running;

/**
 * Delegate object for receiving event callbacks.
 */
@property (nonatomic, weak, nullable) id<MLStreamerDelegate> delegate;

/**
 *  The queue used by the proxy method callback, if not specified, will be called back in the main thread.
 */
@property (nonatomic, strong, nullable) dispatch_queue_t delegateQueue;

/**
 * Video parameter configuration object.
 *
 * @warning Please do not modify the obtained videoConfiguration object, otherwise, an undefined error will occur. If the parameters were modified, please use related running properties updating interface or destroy the current Recorder and re-generate.
 */
@property (nonatomic, strong, readonly) MLVideoConfiguration *videoConfiguration;

/**
 * Audio parameter configuration object.
 *
 * @warning Please do not modify the obtained videoConfiguration object, otherwise, an undefined error will occur. If the parameters were modified, please use related running properties updating interface or destroy the current Recorder and re-generate.
 */
@property (nonatomic, strong, readonly) MLAudioConfiguration *audioConfiguration;

/**
 * Effects applied to recorder.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, copy) NSArray<id<MovieousCaptureEffect>> *captureEffects;

/**
 * The fill mode used when the preview window does not match the configured videoSize ratiothe.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) MovieousScalingMode previewScalingMode;

/**
 * Whether to mirror the front camera preview.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) BOOL mirrorFrontPreview;

/**
 * Whether to mirror the rear camera preview.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) BOOL mirrorBackPreview;

/**
 * Whether to mirror the video encoded by the front camera.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) BOOL mirrorFrontEncoded;

/**
 * Whether to mirror the video encoded by the rear camera.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) BOOL mirrorBackEncoded;

/**
 * Whether to enable touch to focus and exposure the specified point in the preview.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) BOOL touchToFocusExposureEnabled;

/**
 * Whether to open the internal focus view.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) BOOL innerFocusViewEnabled;

/**
 * The current torchMode being used on the camera.
 */
@property (nonatomic, assign, readonly) AVCaptureTorchMode torchMode;

/**
 * Specify the preferred torch mode to use on camera, what needs to note is that the preferredTorchMode is not guaranteed to be applied succesfully, the actual torch mode can be accessed by the property torchMode.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) AVCaptureTorchMode preferredTorchMode;

/**
 * The current flashMode being used on the camera.
 */
@property (nonatomic, assign, readonly) AVCaptureFlashMode flashMode;

/**
 * Specify the preferred flash mode to use on camera, what needs to note is that the preferredFlashMode is not guaranteed to be applied succesfully, the actual torch mode can be accessed by the property flashMode.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) AVCaptureFlashMode preferredFlashMode;

/**
 * A property indicating the format's supported frame rate ranges. videoSupportedFrameRateRanges is an array of AVFrameRateRange objects, one for each of the format's supported video frame rate ranges.
 */
@property(nonatomic, readonly) NSArray<AVFrameRateRange *> *videoSupportedFrameRateRanges;

/**
 * The current minimum frames per second on camera.
 */
@property (nonatomic, assign, readonly) Float64 minFrameRate;

/**
 * Specify the preferred minimum frames per second on camera, what needs to note is that the preferredMinFrameRate is not guaranteed to be applied succesfully, the actual minimum frames per second can be accessed by the property minFrameRate.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) Float64 preferredMinFrameRate;

/**
 * The current maximum frames per second on camera.
 */
@property (nonatomic, assign, readonly) Float64 maxFrameRate;

/**
 * Specify the preferred maximum frames per second on camera, what needs to note is that the preferredMaxFrameRate is not guaranteed to be applied succesfully, the actual maximum frames per second can be accessed by the property maxFrameRate.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) Float64 preferredMaxFrameRate;

/**
 * The current sessionPreset of the camera.
 */
@property (nonatomic, strong, readonly) AVCaptureSessionPreset sessionPreset;

/**
 * Specify the resolution for capturing, what needs to note is that the preferredSessionPreset is not guaranteed to be applied succesfully, the actual resolution can be accessed by the property sessionPreset.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, strong) AVCaptureSessionPreset preferredSessionPreset;

/**
 * The current position of the camera.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign, readonly) AVCaptureDevicePosition devicePosition;

/**
 * Specify the Camera position for capturing, what needs to note is that the preferredDevicePosition is not guaranteed to be applied succesfully, the actual Camera position can be accessed by the property devicePosition.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) AVCaptureDevicePosition preferredDevicePosition;

/**
 * The current orientation of the camera.
 */
@property (nonatomic, assign, readonly) AVCaptureVideoOrientation videoOrientation;

/**
 * Specify the orientation of the camera, what needs to note is that the preferredVideoOrientation is not guaranteed to be applied succesfully, the actual Camera orientation can be accessed by the property videoOrientation.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) AVCaptureVideoOrientation preferredVideoOrientation;

/**
 * The maximum video zoom factor that can be applied.
 */
@property (nonatomic, assign, readonly) CGFloat videoMaxZoomFactor;

/**
 * The current video zoom factor.
 */
@property (nonatomic, assign, readonly) CGFloat videoZoomFactor;

/**
 * Specify the video zoom factor of the camera, what needs to note is that the preferredVideoZoomFactor is not guaranteed to be applied succesfully, the actual video zoom factor can be accessed by the property videoZoomFactor.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) CGFloat preferredVideoZoomFactor;

/**
 * The current continuousAutoFocusEnable status.
 * The default is the same as the videoConfiguration initializing the recorder.
 *
 * @discussion ContinuousAutoFocus indicates that the device should automatically focus when needed.
 */
@property (nonatomic, assign, readonly) BOOL continuousAutoFocusEnable;

/**
 * Specify the continuousAutoFocusEnable status of the camera, what needs to note is that the preferredContinuousAutoFocusEnable is not guaranteed to be applied succesfully, the actual continuousAutoFocusEnable can be accessed by the property continuousAutoFocusEnable
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) BOOL preferredContinuousAutoFocusEnable;

/**
 * Indicates current focus point of interest of the receiver, if it has one.
 *
 * @discussion The value of this property is a CGPoint that determines the receiver's focus point of interest, if it has one. A value of (0,0) indicates that the camera should focus on the top left corner of the image, while a value of (1,1) indicates that it should focus on the bottom right. The default value is (0.5,0.5).
 */
@property (nonatomic, assign, readonly) CGPoint focusPointOfInterest;

/**
 * Specify the preferredFocusPointOfInterest status of the camera, what needs to note is that the preferredFocusPointOfInterest is not guaranteed to be applied succesfully, the actual focusPointOfInterest can be accessed by the property focusPointOfInterest
 * The default is the same as the videoConfiguration initializing the recorder..
 */
@property (nonatomic, assign) CGPoint preferredFocusPointOfInterest;

/**
 * The current continuousAutoExposureEnable status
 *
 * @discussion Indicates that the device should automatically adjust exposure when needed
 */
@property (nonatomic, assign, readonly) BOOL continuousAutoExposureEnable;

/**
 * Specify the preferredContinuousAutoExposureEnable of the camera, what needs to note is that the preferredContinuousAutoExposureEnable is not guaranteed to be applied succesfully, the actual continuousAutoExposureEnable can be accessed by the property continuousAutoExposureEnable.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) BOOL preferredContinuousAutoExposureEnable;

/*!
 * Indicates current exposure point of interest of the receiver, if it has one.
 *
 * @discussion The value of this property is a CGPoint that determines the receiver's exposure point of interest, if it has adjustable exposure. A value of (0,0) indicates that the camera should adjust exposure based on the top left corner of the image, while a value of (1,1) indicates that it should adjust exposure based on the bottom right corner. The default value is (0.5,0.5).
 */
@property (nonatomic, assign, readonly) CGPoint exposurePointOfInterest;

/**
 * Specify the preferredExposurePointOfInterest of the camera, what needs to note is that the preferredExposurePointOfInterest is not guaranteed to be applied succesfully, the actual exposurePointOfInterest can be accessed by the property exposurePointOfInterest.
 * The default is the same as the videoConfiguration initializing the recorder.
 */
@property (nonatomic, assign) CGPoint preferredExposurePointOfInterest;

/**
 * Mute sound while recording, if you want to record a movie with no sound, you can specify source property in audioConfiguration to MLAudioSourceNone.
 * The default is the same as the audioConfiguration initializing the recorder.
 */
@property (nonatomic, assign) BOOL mute;

/**
 * Instantiate a MLStreamer instance.
 *
 * @param audioConfiguration Audio configuration that introducing nil will use the default configuration.
 * @param videoConfiguration Video configuration that introducing nil will use the default configuration.
 * @param outError If an error occurs, return the error that occurred.
 *
 * @return It returns YES when the instantiation is successful, otherwise, it returns NO.
 */
+ (instancetype _Nullable)streamerWithAudioConfiguration:(MLAudioConfiguration *_Nullable)audioConfiguration videoConfiguration:(MLVideoConfiguration *_Nullable)videoConfiguration error:(NSError *_Nullable *_Nullable)outError;

/**
 * Initialize a MLStreamer instance.
 *
 * @param audioConfiguration Audio configuration that introducing nil will use the default configuration.
 * @param videoConfiguration Video configuration that introducing nil will use the default configuration.
 * @param outError If an error occurs, return the error that occurred.
 *
 * @return It returns YES when the initialization is successful, otherwise, it returns NO.
 */
- (instancetype)initWithAudioConfiguration:(MLAudioConfiguration *_Nullable)audioConfiguration videoConfiguration:(MLVideoConfiguration *_Nullable)videoConfiguration error:(NSError *_Nullable *_Nullable)outError;

/**
 * Start collecting audio and video, call this method will request the usage permission of audio and video (if the specified audio and video data source is the camera or microphone).
 *
 * @param completionHandler Callback is completed, audioGranted：Whether to obtain audio rights, audioError：Error in audio component initialization, videoGranted：Whether you have obtained the captured permissions of the video,videoError：Error in video component initialization.
 */
- (void)startCapturingWithCompletion:(void(^)(BOOL audioGranted, NSError *_Nullable audioError, BOOL videoGranted, NSError *_Nullable videoError))completionHandler;

/**
 * Stop capturing.
 */
- (void)stopCapturing;

/**
 * Start push stream to remote server.
 *
 * @param serverURL The remote rtmp server URL to push stream, must have scheme "rtmp://".
 * @param outError If an error occurs, return the error that occurred.
 *
 * @return It returns YES when the setting is successful, otherwise, it returns NO.
 */
- (BOOL)startPushingWithServerURL:(NSURL *)serverURL error:(NSError *_Nullable *_Nullable)outError;

/**
 * Stop push stream to remote server.
 */
- (void)stopPushing;

/**
 * Switch camera.
 */
- (void)switchCamera;

/**
 * The interface of externally write the video data, please ensure the configuration if this interface will be used.  videoConfiguration.source = MLVideoSourceExtern.
 *
 * @param videoData Video data to be written.
 * @param presentationTime The presentationTime of the video data.
 * @param outError If an error occurs, return the error that occurred.
 *
 * @return It returns YES when the setting is successful, otherwise, it returns NO.
 */
- (BOOL)writeVideoData:(CVPixelBufferRef)videoData presentationTime:(CMTime)presentationTime error:(NSError *_Nullable *_Nullable)outError;

/**
 * The interface of externally write the video data, please ensure the configuration if this interface will be used.  videoConfiguration.source = MLVideoSourceExtern.
 *
 * @param videoData Video data to be written.
 * @param outError If an error occurs, return the error that occurred.
 *
 * @return It returns YES when the setting is successful, otherwise, it returns NO.
 */
- (BOOL)writeVideoData:(CMSampleBufferRef)videoData error:(NSError *_Nullable *_Nullable)outError;

/**
 * The interface of externally write the video data, please ensure the configuration if this interface will be used. audioConfiguration.source = MLAudioSourceExtern.
 *
 * @param audioData Audio data to be written.
 * @param outError If an error occurs, return the error that occurred.
 *
 * @return It returns YES when the setting is successful, otherwise, it returns NO.
 */
- (BOOL)writeAudioData:(CMSampleBufferRef)audioData error:(NSError *_Nullable *_Nullable)outError;

/**
 * Obtain a screenshot.
 *
 * @param completionHandler Called when capture completes.
 */
- (void)snapshotWithCompletion:(MovieousSnapshotCompletionHandler)completionHandler;

/**
 * Start stream statistics update.
 */
- (void)startStreamStatisticsUpdateWithInterval:(NSTimeInterval)interval;

/**
 * Stop stream statistics update.
 */
- (void)stopStreamStatisticsUpdate;

@end

NS_ASSUME_NONNULL_END
