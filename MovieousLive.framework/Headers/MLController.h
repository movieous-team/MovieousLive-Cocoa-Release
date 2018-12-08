//
//  MLController.h
//  MovieousLive
//
//  Created by Chris Wang on 2018/8/25.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLVideoConfiguration.h"
#import "MLAudioConfiguration.h"
#import <MovieousBase/MovieousBase.h>

@class MLController;

@protocol MLControllerDelegate<NSObject>

@optional

/**
 * @brief Called when state of the controller changed
 * @param controller The controller whose state has changed
 * @param state New state of the controller
 * @param error This Parameter will only be non nil when state turns to `MLStreamStateError`
 */
- (void)controller:(MLController *)controller stateDidChange:(MLState)state error:(NSError *)error;

/**
 * @brief Called when new video data are available, you can do custom process within this delegate method
 * @param controller The controller whose state has changed
 * @param videoData Video data
 * @return The processed video data
 */
- (CVPixelBufferRef)controller:(MLController *)controller didGetVideoData:(CVPixelBufferRef)videoData;

/**
 * @brief Called when new audio data are available, you can do custom process within this delegate method
 * @param controller The controller whose state has changed
 * @param audioData Aideo data
 * @return The processed audio data
 */
- (AudioBufferList *)controller:(MLController *)controller didGetAudioData:(AudioBufferList *)audioData;

@end

@interface MLController : NSObject

/**
 * @brief SDK Log Level, Default to MLStreamLogLevelWarning
 * @warning Don't use MLLogLevelVerbose for release version，this will cause performance issue。
 */
+ (void)setLogLevel:(MLLogLevel)logLevel;

/**
 * @brief Camera preview
 */
@property(nonatomic, strong, readonly) UIView *preview;

/**
 * @brief State of the MLController
 */
@property(nonatomic, assign, readonly) MLState state;

/**
 * @brief URL of the server to which the stream is pushed
 */
@property(nonatomic, strong, readonly) NSURL *URL;

/**
 * @brief How to scale content when aspect ratios of the content and preview are not equal
 * Default to MovieousScalingModeAspectFit
 */
@property(nonatomic, assign) MovieousScalingMode scalingMode;

/**
 * @brief Delegate of the controller
 * Default to nil
 */
@property(nonatomic, weak) id <MLControllerDelegate> delegate;

/**
 * @brief When dynamicFrameRate is enabled, ML engine will adjust frame rate when network is not able to send data realtime
 * Default to NO
 */
@property(nonatomic, assign) BOOL dynamicFrameRate;

/**
 * @discussion When autoReconnect is enabled, ML engine will try to reconnect to the server when live broadcasting is disconnected due to some exception. In this situation, state of the controller will turn to `MLStreamStateReconnecting`, and ML engine will try at most 3 times, from 0~2 seconds to 10 seconds. If the server still can't be connected, ML engine will give up trying, and state of the controller will turn to `MLStreamStateError`
 * Default to YES
 */
@property(nonatomic, assign) BOOL autoReconnect;

/**
 * @brief When monitorNetwork is enabled, ML engine will try to reconnect to the server when network changed from Wifi to Cellular or from Cellular to Wifi.
 * Default to YES
 */
@property (nonatomic, assign) BOOL monitorNetwork;

/**
 * @brief When monitorNetwork is set to YES, this handler will be called when network state changes, you can return yes to try reconnect to the server, or return NO to do nothing.
 */
@property (nonatomic, copy) ConnectionChangeActionHandler connectionChangeActionHandler;

/**
 * @brief Initialize the controller with the specific URL, default audio configuration and default video configuration
 * @param URL The URL to which the live stream will be pushed, if the URL you passed is unauthorized by ML, this method will return a nil object
 * @return The initialized controller, if the URL you passed is unauthorized by ML, this method will return a nil object
 */
- (instancetype)initWithURL:(NSURL *)URL;

/**
 * @brief Initialize the controller with the specific URL, audio configuration and video configuration
 * @param URL The URL to which the live stream will be pushed, if the URL you passed is unauthorized by ML, this method will return a nil object
 * @param audioConfiguration Audio Configuration for the live broadcasting, nil to use default configuration
 * @param videoConfiguration Video Configuration for the live broadcasting, nil to use default configuration
 * @return The initialized controller, if the URL you passed is unauthorized by ML, this method will return a nil object
 */
- (instancetype)initWithURL:(NSURL *)URL audioConfiguration:(MLAudioConfiguration *)audioConfiguration videoConfiguration:(MLVideoConfiguration *)videoConfiguration NS_DESIGNATED_INITIALIZER;

/**
 * @brief Start capturing audio and video data. Call this method will request for authorization of the camera and microphone if enabled
 * @param completion Block called when start completed
 */
- (void)startCapturingWithCompletion:(void (^)(AVAuthorizationStatus cameraAuthorizationStatus, AVAuthorizationStatus microphoneAuthorizationStatus, NSError *error))completion;

/**
 * @brief Pause audio capturing
 */
- (void)pauseAudioCapturing;

/**
 * @brief Resume audio capturing
 */
- (void)resumeAudioCapturing;

/**
 * @brief Pause video capturing
 */
- (void)pauseVideoCapturing;

/**
 * @brief Resume video capturing
 */
- (void)resumeVideoCapturing;

/**
 * @brief Start broadcasting to the server
 * @param completion Completion callback. if any error happens, error will not be nil.
 */
- (void)startBroadcastingWithCompletion:(void (^)(NSError *error))completion;

/**
 * @brief Stop broadcasting to the server
 */
- (void)stopBroadcasting;

@end

@interface MLController(Video)

/**
 * @brief Turn mirrorFrontPreview means preview for front camera will be mirrored
 * Default to the value you set by MLVideoConfiguration
 */
@property (nonatomic, assign) BOOL mirrorFrontPreview;

/**
 * @brief Turn mirrorBackPreview means preview for back camera will be mirrored
 * Default to the value you set by MLVideoConfiguration
 */
@property (nonatomic, assign) BOOL mirrorBackPreview;

/**
 * @brief Turn mirrorFrontStream means stream broadcasted for front camera will be mirrored
 * Default to the value you set by MLVideoConfiguration
 */
@property (nonatomic, assign) BOOL mirrorFrontStream;

/**
 * @brief Turn mirrorBackStream means stream broadcasted for back camera will be mirrored
 * Default to the value you set by MLVideoConfiguration
 */
@property (nonatomic, assign) BOOL mirrorBackStream;

/**
 * @brief Indicates that you can touch preview to make the camera focus on the point you touched
 * Default to the value you set by MLVideoConfiguration
 */
@property (nonatomic, assign) BOOL touchToFocus;

/**
 * @brief Indicates whether to turn torch on
 * Default to the value you set by MLVideoConfiguration
 */
@property (nonatomic, assign, readonly) BOOL torchOn;
- (BOOL)setTorchOn:(BOOL)torchOn error:(NSError **)error;

/**
 * @brief Indicates that the device should automatically focus when needed
 * Default to the value you set by MLVideoConfiguration
 */
@property (nonatomic, assign, readonly) BOOL continuousAutofocus;
- (BOOL)setContinuousAutofocus:(BOOL)continuousAutofocus error:(NSError **)error;

/**
 * @brief Number of minimum frames per seconds captured by the camera
 * Default to the value you set by MLVideoConfiguration
 */
@property (nonatomic, assign, readonly) NSUInteger frameRate;
- (BOOL)setFrameRate:(NSUInteger)frameRate error:(NSError **)error;

/**
 * @brief You may use an AVCaptureSessionPreset to set the format for camera output data
 * Default to the value you set by MLVideoConfiguration
 */
@property (nonatomic, strong, readonly) AVCaptureSessionPreset cameraResolution;
- (BOOL)setCameraResolution:(AVCaptureSessionPreset)cameraResolution error:(NSError **)error;

/**
 * @brief Indicates the physical position of camera on the system.
 * Default to the value you set by MLVideoConfiguration
 */
@property (nonatomic, assign, readonly) AVCaptureDevicePosition cameraPosition;
- (BOOL)setCameraPosition:(AVCaptureDevicePosition)cameraPosition error:(NSError **)error;

/**
 * @brief Indicates video orientation
 * Default to the value you set by MLVideoConfiguration
 */
@property (nonatomic, assign, readonly) AVCaptureVideoOrientation cameraOrientation;
- (BOOL)setCameraOrientation:(AVCaptureVideoOrientation)cameraOrientation error:(NSError **)error;

/**
 * @brief  Controls zoom level of image outputs
 * @discussion Applies a centered crop for all image outputs, scaling as necessary to maintain output dimensions. Minimum value of 1.0 yields full field of view, increasing values will increase magnification, up to a maximum value specified in the videoMaxZoomFactor property. Assigning values outside the acceptable range will generate an NSRangeException.
 * Default to the value you set by MLVideoConfiguration
 */
@property (nonatomic, assign, readonly) CGFloat cameraZoomFactor;
- (BOOL)setCameraZoomFactor:(CGFloat)cameraZoomFactor error:(NSError **)error;

/**
 * @brief Switch the camera
 */
- (BOOL)switchCameraWithError:(NSError **)error;

@end

@interface MLController(Audio)

/**
 * @brief Turn headphoneMonitor on, you can hear the voice of yourself from the headphone connected to the device
 * Default to NO
 */
@property (nonatomic, assign) BOOL headphoneMonitor;

@end
