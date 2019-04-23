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
@protocol MLStreamerDelegate <NSObject>

@optional
/**
 * @brief Tell the delegate that the streamer has failed streaming because of some error
 * @param streamer The caller call the method
 * @param error The specific error
 */
- (void)streamer:(MLStreamer *)streamer didFailedWithError:(NSError *)error;

/**
 * @brief Tell the delegate that the stream statistics has updated, you must call - (void)startStreamStatisticsUpdateWithInterval: first to start stream statistics update
 * @param streamer The caller call the method
 * @param streamStatistics The stream statistics of the stream
 */
- (void)streamer:(MLStreamer *)streamer streamStatisticsDidUpdated:(MLStreamStatistics *)streamStatistics;

@end

@interface MLStreamer : NSObject

/**
 * @brief Preview view
 */
@property (nonatomic, strong, readonly) UIView *previewView;

/**
 * @brief The remote server URL used to push stream
 */
@property (nonatomic, strong, nullable, readonly) NSURL *serverURL;

/**
 * @brief The running status of the streamer
 */
@property (nonatomic, assign, readonly) BOOL running;

/**
 * @brief Delegate object for receiving event callbacks
 */
@property (nonatomic, weak, nullable) id<MLStreamerDelegate> delegate;

/**
 * @brief  The queue used by the proxy method callback, if not specified, will be called back in the main thread.
 */
@property (nonatomic, strong, nullable) dispatch_queue_t delegateQueue;

/**
 * @brief Video parameter configuration object
 * @warning Please do not modify the obtained videoConfiguration object, otherwise, an undefined error will occur. If the parameters were modified, please use related running properties updating interface or destroy the current Recorder and re-generate.
 */
@property (nonatomic, strong, readonly) MLVideoConfiguration *videoConfiguration;

/**
 * @brief Audio parameter configuration object
 * @warning Please do not modify the obtained videoConfiguration object, otherwise, an undefined error will occur. If the parameters were modified, please use related running properties updating interface or destroy the current Recorder and re-generate.
 */
@property (nonatomic, strong, readonly) MLAudioConfiguration *audioConfiguration;

/**
 * @brief Effects applied to recorder.
 */
@property (nonatomic, strong, nullable) NSArray<id<MovieousCaptureEffect>> *captureEffects;

/**
 * @brief The fill mode used when the preview window does not match the configured videoSize ratio, the default is MovieousScalingModeAspectFit.
 */
@property (nonatomic, assign) MovieousScalingMode previewScalingMode;

/**
 * @brief Whether to mirror the front camera preview, the default is YES
 */
@property (nonatomic, assign) BOOL mirrorFrontPreview;

/**
 * @brief Whether to mirror the rear camera preview, the default is NO
 */
@property (nonatomic, assign) BOOL mirrorBackPreview;

/**
 * @brief Whether to mirror the video encoded by the front camera, the default is NO
 */
@property (nonatomic, assign) BOOL mirrorFrontEncoded;

/**
 * @brief Whether to mirror the video encoded by the rear camera, the default is NO
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
 * @brief The current torchMode being used on the camera
 */
@property (nonatomic, assign, readonly) AVCaptureTorchMode torchMode;

/**
 * @brief Specify the preferred torch mode to use on camera, what needs to note is that the preferredTorchMode is not guaranteed to be applied succesfully, the actual torch mode can be accessed by the property torchMode
 */
@property (nonatomic, assign) AVCaptureTorchMode preferredTorchMode;

/**
 * @brief A property indicating the format's supported frame rate ranges. videoSupportedFrameRateRanges is an array of AVFrameRateRange objects, one for each of the format's supported video frame rate ranges
 */
@property(nonatomic, readonly) NSArray<AVFrameRateRange *> *videoSupportedFrameRateRanges;

/**
 * @brief The current minimum frames per second on camera
 */
@property (nonatomic, assign, readonly) Float64 minFrameRate;

/**
 * @brief Specify the preferred minimum frames per second on camera, what needs to note is that the preferredMinFrameRate is not guaranteed to be applied succesfully, the actual minimum frames per second can be accessed by the property minFrameRate
 */
@property (nonatomic, assign) Float64 preferredMinFrameRate;

/**
 * @brief The current maximum frames per second on camera
 */
@property (nonatomic, assign, readonly) Float64 maxFrameRate;

/**
 * @brief Specify the preferred maximum frames per second on camera, what needs to note is that the preferredMaxFrameRate is not guaranteed to be applied succesfully, the actual maximum frames per second can be accessed by the property maxFrameRate
 */
@property (nonatomic, assign) Float64 preferredMaxFrameRate;

/**
 * @brief The resolution captured by the camera, the default is AVCaptureSessionPresetHigh
 */
@property (nonatomic, strong, readonly) AVCaptureSessionPreset sessionPreset;

/**
 * @brief Specify the resolution for capturing, what needs to note is that the preferredSessionPreset is not guaranteed to be applied succesfully, the actual resolution can be accessed by the property sessionPreset
 */
@property (nonatomic, strong) AVCaptureSessionPreset preferredSessionPreset;

/**
 * @brief Camera position, the default is AVCaptureDevicePositionBack
 */
@property (nonatomic, assign, readonly) AVCaptureDevicePosition devicePosition;

/**
 * @brief Specify the Camera position for capturing, what needs to note is that the preferredDevicePosition is not guaranteed to be applied succesfully, the actual Camera position can be accessed by the property devicePosition
 */
@property (nonatomic, assign) AVCaptureDevicePosition preferredDevicePosition;

/**
 * @brief Set the orientation of the camera
 */
@property (nonatomic, assign, readonly) AVCaptureVideoOrientation videoOrientation;

/**
 * @brief Specify the orientation of the camera, what needs to note is that the preferredVideoOrientation is not guaranteed to be applied succesfully, the actual Camera orientation can be accessed by the property videoOrientation
 */
@property (nonatomic, assign) AVCaptureVideoOrientation preferredVideoOrientation;

/**
 * @brief The maximum video zoom factor that can be applied
 */
@property (nonatomic, assign, readonly) CGFloat videoMaxZoomFactor;

/**
 * @brief The current video zoom factor
 */
@property (nonatomic, assign, readonly) CGFloat videoZoomFactor;

/**
 * @brief Specify the video zoom factor of the camera, what needs to note is that the preferredVideoZoomFactor is not guaranteed to be applied succesfully, the actual video zoom factor can be accessed by the property videoZoomFactor
 */
@property (nonatomic, assign) CGFloat preferredVideoZoomFactor;

/**
 * @brief The current continuousAutoFocusEnable status
 * @discussion ContinuousAutoFocus indicates that the device should automatically focus when needed.
 */
@property (nonatomic, assign, readonly) BOOL continuousAutoFocusEnable;

/**
 * @brief Specify the continuousAutoFocusEnable status of the camera, what needs to note is that the preferredContinuousAutoFocusEnable is not guaranteed to be applied succesfully, the actual continuousAutoFocusEnable can be accessed by the property continuousAutoFocusEnable
 */
@property (nonatomic, assign) BOOL preferredContinuousAutoFocusEnable;

/**
 @abstract
 Indicates current focus point of interest of the receiver, if it has one.
 
 @discussion
 The value of this property is a CGPoint that determines the receiver's focus point of interest, if it has one. A value of (0,0) indicates that the camera should focus on the top left corner of the image, while a value of (1,1) indicates that it should focus on the bottom right. The default value is (0.5,0.5).
 */
@property (nonatomic, assign, readonly) CGPoint focusPointOfInterest;

/**
 * @brief Specify the preferredFocusPointOfInterest status of the camera, what needs to note is that the preferredFocusPointOfInterest is not guaranteed to be applied succesfully, the actual focusPointOfInterest can be accessed by the property focusPointOfInterest
 */
@property (nonatomic, assign) CGPoint preferredFocusPointOfInterest;

/**
 @abstract
 The current continuousAutoExposureEnable status
 
 @discussion
 Indicates that the device should automatically adjust exposure when needed
 */
@property (nonatomic, assign, readonly) BOOL continuousAutoExposureEnable;

/**
 * @brief Specify the preferredContinuousAutoExposureEnable of the camera, what needs to note is that the preferredContinuousAutoExposureEnable is not guaranteed to be applied succesfully, the actual continuousAutoExposureEnable can be accessed by the property continuousAutoExposureEnable
 */
@property (nonatomic, assign) BOOL preferredContinuousAutoExposureEnable;

/*!
 @abstract
 Indicates current exposure point of interest of the receiver, if it has one.
 
 @discussion
 The value of this property is a CGPoint that determines the receiver's exposure point of interest, if it has adjustable exposure. A value of (0,0) indicates that the camera should adjust exposure based on the top left corner of the image, while a value of (1,1) indicates that it should adjust exposure based on the bottom right corner. The default value is (0.5,0.5).
 */
@property (nonatomic, assign, readonly) CGPoint exposurePointOfInterest;

/**
 * @brief Specify the preferredExposurePointOfInterest of the camera, what needs to note is that the preferredExposurePointOfInterest is not guaranteed to be applied succesfully, the actual exposurePointOfInterest can be accessed by the property exposurePointOfInterest
 */
@property (nonatomic, assign) CGPoint preferredExposurePointOfInterest;

/**
 * @brief Mute sound while recording
 */
@property (nonatomic, assign) BOOL mute;

/**
 * @brief Instantiate a MLStreamer instance
 * @param audioConfiguration Audio configuration that introducing nil will use the default configuration
 * @param videoConfiguration Video configuration that introducing nil will use the default configuration
 * @param outError If an error occurs, return the error that occurred
 * @return It returns YES when the instantiation is successful, otherwise, it returns NO
 */
+ (instancetype _Nullable)streamerWithAudioConfiguration:(MLAudioConfiguration *_Nullable)audioConfiguration videoConfiguration:(MLVideoConfiguration *_Nullable)videoConfiguration error:(NSError *_Nullable *_Nullable)outError;

/**
 * @brief Initialize a MLStreamer instance
 * @param audioConfiguration Audio configuration that introducing nil will use the default configuration
 * @param videoConfiguration Video configuration that introducing nil will use the default configuration
 * @param outError If an error occurs, return the error that occurred
 * @return It returns YES when the initialization is successful, otherwise, it returns NO
 */
- (instancetype)initWithAudioConfiguration:(MLAudioConfiguration *_Nullable)audioConfiguration videoConfiguration:(MLVideoConfiguration *_Nullable)videoConfiguration error:(NSError *_Nullable *_Nullable)outError;

/**
 * @brief Start collecting audio and video, call this method will request the usage permission of audio and video (if the specified audio and video data source is the camera or microphone)
 * @param completionHandler Callback is completed, audioGranted：Whether to obtain audio rights, audioError：Error in audio component initialization, videoGranted：Whether you have obtained the captured permissions of the video,videoError：Error in video component initialization
 */
- (void)startCapturingWithCompletion:(void(^)(BOOL audioGranted, NSError *_Nullable audioError, BOOL videoGranted, NSError *_Nullable videoError))completionHandler;

/**
 * @brief Stop capturing
 */
- (void)stopCapturing;

/**
 * @brief Start push stream to remote server
 * @param serverURL The remote rtmp server URL to push stream, must have scheme "rtmp://"
 * @param outError If an error occurs, return the error that occurred
 * @return It returns YES when the setting is successful, otherwise, it returns NO
 */
- (BOOL)startPushingWithServerURL:(NSURL *)serverURL error:(NSError *_Nullable *_Nullable)outError;

/**
 * @brief Stop push stream to remote server
 */
- (void)stopPushing;

/**
 * @brief Switch camera
 */
- (void)switchCamera;

/**
 * @brief The interface of externally write the video data, please ensure the configuration if this interface will be used.  videoConfiguration.source = MLVideoSourceExtern
 * @param videoData Video data to be written
 * @param presentationTime The presentationTime of the video data
 * @param outError If an error occurs, return the error that occurred
 * @return It returns YES when the setting is successful, otherwise, it returns NO
 */
- (BOOL)writeVideoData:(CVPixelBufferRef)videoData presentationTime:(CMTime)presentationTime error:(NSError *_Nullable *_Nullable)outError;

/**
 * @brief The interface of externally write the video data, please ensure the configuration if this interface will be used.  videoConfiguration.source = MLVideoSourceExtern
 * @param videoData Video data to be written
 * @param outError If an error occurs, return the error that occurred
 * @return It returns YES when the setting is successful, otherwise, it returns NO
 */
- (BOOL)writeVideoData:(CMSampleBufferRef)videoData error:(NSError *_Nullable *_Nullable)outError;

/**
 * @brief The interface of externally write the video data, please ensure the configuration if this interface will be used. audioConfiguration.source = MLAudioSourceExtern
 * @param audioData Audio data to be written
 * @param outError If an error occurs, return the error that occurred
 * @return It returns YES when the setting is successful, otherwise, it returns NO
 */
- (BOOL)writeAudioData:(CMSampleBufferRef)audioData error:(NSError *_Nullable *_Nullable)outError;

/**
 * @brief Obtain a screenshot
 */
- (void)snapshotWithCompletion:(void(^)(UIImage *image))completionHandler;

/**
 * @brief Obtain a screenshot
 */
- (void)startStreamStatisticsUpdateWithInterval:(NSTimeInterval)interval;

/**
 * @brief Stops the stream
 */
- (void)stopStreamStatisticsUpdate;

@end

NS_ASSUME_NONNULL_END
