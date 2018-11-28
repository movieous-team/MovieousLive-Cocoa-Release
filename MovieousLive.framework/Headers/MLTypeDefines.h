//
//  MLTypeDefines.h
//  Movieous
//
//  Created by Chris Wang on 2018/9/11.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#ifndef MLTypeDefines_h
#define MLTypeDefines_h

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, MLVideoSource) {
    MLVideoSourceCamera,
};

typedef NS_ENUM(NSInteger, MLAudioSource) {
    MLAudioSourceMicrophone,
};

/*!
 * Audio bit rate use to encode audio
 */
typedef NS_ENUM(NSInteger, MLAudioBitRate) {
    /*!
     * 64 Kbps bit rate
     */
    MLAudioBitRate64Kbps = 64000,
    /*!
     * 96 Kbps bit rate
     */
    MLAudioBitRate96Kbps = 96000,
    /*!
     * 128 Kbps bit rate
     */
    MLAudioBitRate128Kbps = 128000,
};

/*!
 @typedef    MLLogLevel
 @abstract   Log level
 */
typedef NS_ENUM(NSUInteger, MLLogLevel){
    // No logs
    MLLogLevelOff       = 0,
    // Error logs only
    MLLogLevelError,
    // Error and warning logs
    MLLogLevelWarning,
    // Error, warning and info logs
    MLLogLevelInfo,
    // Error, warning, info and debug logs
    MLLogLevelDebug,
    // Error, warning, info, debug and verbose logs
    MLLogLevelVerbose,
};

typedef NS_ENUM(NSInteger, MLState) {
    /*!
     * @abstract Initial state
     */
    MLStateInitial,
    /*!
     * Controller is now connecting to server
     */
    MLStateConnecting,
    /*!
     * Controller is now connected to server
     */
    MLStateConnected,
    /*!
     * Controller is now disconnecting from server
     */
    MLStateDisconnecting,
    /*!
     * Controller is now disconnected from server
     */
    MLStateDisconnected,
    /*!
     * Controller is now reconnecting to server, this state will appear when you have enabled autoReconnect property and the controller have disconnected from server
     */
    MLStateReconnecting,
    /*!
     * Controller has encountered an error and stopped because of this error
     */
    MLStateError,
    /*!
     * Controller is now capturing audio and video if available
     */
    MLStateCapturing,
};

/*!
 @typedef    MLNetworkStateTransition
 @abstract   网络切换状态变化
 */
typedef NS_ENUM(NSUInteger, MLNetworkStateTransition) {
    /// MLNetworkStateTransition 未知转换态，作为 init 初始
    MLNetworkStateTransitionUnknown = 0,
    /// MLNetworkStateTransitionUnconnectedToWiFi 无网切换到WiFi
    MLNetworkStateTransitionUnconnectedToWiFi,
    /// MLNetworkStateTransitionUnconnectedToWWAN 无网切换到WWAN(4G, 3G, etc)
    MLNetworkStateTransitionUnconnectedToWWAN,
    /// MLNetworkStateTransitionWiFiToUnconnected WiFi切换到无网
    MLNetworkStateTransitionWiFiToUnconnected,
    /// MLNetworkStateTransitionWWANToUnconnected WWAN切换到无网
    MLNetworkStateTransitionWWANToUnconnected,
    /// MLNetworkStateTransitionWiFiToWWAN WiFi切换至WWAN
    MLNetworkStateTransitionWiFiToWWAN,
    /// MLNetworkStateTransitionWWANToWiFi WWAN切换至WiFi
    MLNetworkStateTransitionWWANToWiFi,
};

typedef BOOL(^ConnectionChangeActionHandler)(MLNetworkStateTransition transition);


#pragma mark - Stream State


/*!
 @typedef    MovieousStreamState
 @abstract   MovieousStreamingSessin 的流状态。
 @since      v1.0.0
 */
typedef NS_ENUM(NSUInteger, MovieousStreamState) {
    /// MovieousStreamStateUnknow 未知状态，只会作为 init 的初始状态
    MovieousStreamStateUnknow = 0,
    /// MovieousStreamStateConnecting 连接中状态
    MovieousStreamStateConnecting,
    /// MovieousStreamStateConnected 已连接状态
    MovieousStreamStateConnected,
    /// MovieousStreamStateDisconnecting 断开连接中状态
    MovieousStreamStateDisconnecting,
    /// MovieousStreamStateDisconnected 已断开连接状态
    MovieousStreamStateDisconnected,
    /// MovieousStreamStateAutoReconnecting 正在等待自动重连状态
    MovieousStreamStateAutoReconnecting,
    /// MovieousStreamStateError 错误状态
    MovieousStreamStateError
};

#pragma mark - Network State Transition

/*!
 @typedef    MovieousStreamAdaptiveQualityMode
 @abstract   自适应流质量调整模式
 */
typedef NS_ENUM(NSUInteger, MovieousStreamAdaptiveQualityMode) {
    /// MovieousStreamAdaptiveQualityModeBitratePriorAdjust  优先调整码率
    MovieousStreamAdaptiveQualityModeBitratePriorAdjust,
    /// MovieousStreamAdaptiveQualityModeFrameratePriorAdjust 优先调整帧率
    MovieousStreamAdaptiveQualityModeFrameratePriorAdjust,
    /// MovieousStreamAdaptiveQualityModeHybridAdjust 混合调整
    MovieousStreamAdaptiveQualityModeHybridAdjust,
};

/*!
 @typedef    MovieousStreamStartState
 @abstract   反馈推流操作开始的状态。
 @since      v2.0.0
 */
typedef NS_ENUM(NSUInteger, MovieousStreamStartStateFeedback) {
    /// MovieousStreamStartStateSuccess 成功开始推流
    MovieousStreamStartStateSuccess = 0,
    /// MovieousStreamStartStateSessionUnknownError session 发生未知错误无法启动
    MovieousStreamStartStateSessionUnknownError,
    /// MovieousStreamStartStateSessionStillRunning session 已经在运行中，无需重复启动
    MovieousStreamStartStateSessionStillRunning,
    /// MovieousStreamStartStateStreamURLUnauthorized session 当前的 StreamURL 没有被授权
    MovieousStreamStartStateStreamURLUnauthorized,
    /// MovieousStreamStartStateSessionConnectStreamError session 建立 socket 连接错误
    MovieousStreamStartStateSessionConnectStreamError,
    /// MovieousStreamStartStateSessionURLInvalid session 当前传入的 pushURL 无效
    MovieousStreamStartStateSessionPushURLInvalid
};


#pragma mark - Error

/*!
 @typedef    MovieousStreamError
 @abstract   错误状态码。
 
 @constant   MovieousStreamErrorUnknow 未知错误
 @constant   MovieousStreamErrorUnknowOption rtmp 推流未知配置
 @constant   MovieousStreamErrorAccessDNSFailed dns 无法访问
 @constant   MovieousStreamErrorFailedToConnectSocket socket 连接失败
 @constant   MovieousStreamErrorSocksNegotiationFailed sockket negotiation 失败
 @constant   MovieousStreamErrorFailedToCreateSocket 创建 socket 失败
 @constant   MovieousStreamErrorHandshakeFailed    握手失败
 @constant   MovieousStreamErrorRTMPConnectFailed  rtmp 连接失败
 @constant   MovieousStreamErrorSendFailed 发送数据包失败
 @constant   MovieousStreamErrorServerRequestedClose   被服务端关闭
 @constant   MovieousStreamErrorNetStreamFailed    NetStream 失败
 @constant   MovieousStreamErrorNetStreamPlayFailed    NetStreamPlay 失败
 @constant   MovieousStreamErrorNetStreamPlayStreamNotFound    NetStreamPlay 为找到对应的流
 @constant   MovieousStreamErrorNetConnectionConnectInvalidApp 连接到无效的 rtmp 应用
 @constant   MovieousStreamErrorSanityFailed Sanity 失败
 @constant   MovieousStreamErrorSocketClosedByPeer Socket 被关闭
 @constant   MovieousStreamErrorRTMPConnectStreamFailed    rtmp 连接流失败
 @constant   MovieousStreamErrorSocketTimeout  socket 超时
 @constant   MovieousStreamErrorTLSConnectFailed   TLS 连接失败
 @constant   MovieousStreamErrorNoSSLOrTLSSupport  没有 SSL 或者 TLS 支持
 @constant   MovieousStreamErrorDNSResolveFailed   DNS 解析失败
 @constant   MovieousStreamErrorRTMPPublishStreamFailed   rtmp 发布失败
 
 @since      v1.0.0
 */
typedef enum {
    MovieousStreamErrorUnknow =    -1,
    MovieousStreamErrorUnknowOption = -999,
    MovieousStreamErrorAccessDNSFailed = -1000,
    MovieousStreamErrorFailedToConnectSocket = -1001,
    MovieousStreamErrorSocksNegotiationFailed = -1002,
    MovieousStreamErrorFailedToCreateSocket = -1003,
    MovieousStreamErrorHandshakeFailed = -1004,
    MovieousStreamErrorRTMPConnectFailed = -1005,
    MovieousStreamErrorSendFailed = -1006,
    MovieousStreamErrorServerRequestedClose = -1007,
    MovieousStreamErrorNetStreamFailed = -1008,
    MovieousStreamErrorNetStreamPlayFailed = -1009,
    MovieousStreamErrorNetStreamPlayStreamNotFound = -1010,
    MovieousStreamErrorNetConnectionConnectInvalidApp = -1011,
    MovieousStreamErrorSanityFailed = -1012,
    MovieousStreamErrorSocketClosedByPeer = -1013,
    MovieousStreamErrorRTMPConnectStreamFailed = -1014,
    MovieousStreamErrorSocketTimeout = -1015,
    MovieousStreamErrorRTMPPublishStreamFailed = -1016,
    
    // SSL errors
    MovieousStreamErrorTLSConnectFailed = -1200,
    MovieousStreamErrorNoSSLOrTLSSupport = -1201,
    
    // DNS error
    MovieousStreamErrorDNSResolveFailed = -1300,
    
    // reconnect error
    MovieousStreamErrorReconnectFailed = -1400,
    
    /**
     @brief 正在采集的时候被音频事件打断但重启失败
     */
    MovieousCameraErrorRestartAudioFailed = -1500,
    /**
     @brief 正在采集的时候音频服务重启尝试重连但是没有成功
     */
    MovieousCameraErrorTryReconnectFailed = -1501,
} MovieousStreamError;

#pragma mark - Video Streaming Quality

/*!
 @constant   kMovieousVideoStreamingQualityLow1
 @abstract   视频编码推流质量 low 1。
 
 @discussion 具体参数 videoSize: 272x480, expectedSourceVideoFrameRate: 24, videoMaxKeyframeInterval: 72, profile level: AVVideoProfileLevelH264BaselineAutoLevel, video bitrate: 128Kbps。
 
 @since      v1.0.0
 */
extern NSString * kMovieousVideoStreamingQualityLow1;

/*!
 @constant   kMovieousVideoStreamingQualityLow1
 @abstract   视频编码推流质量 low 2。
 
 @discussion 具体参数 videoSize: 272x480, expectedSourceVideoFrameRate: 24, videoMaxKeyframeInterval: 72, profile level: AVVideoProfileLevelH264BaselineAutoLevel, video bitrate: 256Kbps。
 
 @since      v1.0.0
 */
extern NSString * kMovieousVideoStreamingQualityLow2;

/*!
 @constant   kMovieousVideoStreamingQualityLow3
 @abstract   视频编码推流质量 low 3。
 
 @discussion 具体参数 videoSize: 272x480, expectedSourceVideoFrameRate: 24, videoMaxKeyframeInterval: 72, profile level: AVVideoProfileLevelH264HighAutoLevel, video bitrate: 512Kbps
 
 @since      v1.0.0
 */
extern NSString *kMovieousVideoStreamingQualityLow3;

/*!
 @constant   kMovieousVideoStreamingQualityMedium1
 @abstract   视频编码推流质量 medium 1。
 
 @discussion 具体参数 videoSize: 368x640, expectedSourceVideoFrameRate: 24, videoMaxKeyframeInterval: 72, profile level: AVVideoProfileLevelH264HighAutoLevel, video bitrate: 512Kbps
 
 @since      v1.0.0
 */
extern NSString *kMovieousVideoStreamingQualityMedium1;

/*!
 @constant   kMovieousVideoStreamingQualityMedium2
 @abstract   视频编码推流质量 medium 2。
 
 @discussion 具体参数 videoSize: 368x640, expectedSourceVideoFrameRate: 24, videoMaxKeyframeInterval: 72, profile level: AVVideoProfileLevelH264BaselineAutoLevel, video bitrate: 768Kbps
 
 @since      v1.0.0
 */
extern NSString *kMovieousVideoStreamingQualityMedium2;

/*!
 @constant   kMovieousVideoStreamingQualityMedium3
 @abstract   视频编码推流质量 medium 3。
 
 @discussion 具体参数 videoSize: 368x640, expectedSourceVideoFrameRate: 24, videoMaxKeyframeInterval: 72, profile level: AVVideoProfileLevelH264BaselineAutoLevel, video bitrate: 1Mbps
 
 @since      v1.0.0
 */
extern NSString *kMovieousVideoStreamingQualityMedium3;

/*!
 @constant   kMovieousVideoStreamingQualityHigh1
 @abstract   视频编码推流质量 high 1。
 
 @discussion 具体参数 videoSize: 720x1280, expectedSourceVideoFrameRate: 24, videoMaxKeyframeInterval: 72, profile level: AVVideoProfileLevelH264BaselineAutoLevel, video bitrate: 1Mbps
 
 @since      v1.0.0
 */
extern NSString *kMovieousVideoStreamingQualityHigh1;

/*!
 @constant   kMovieousVideoStreamingQualityHigh2
 @abstract   视频编码推流质量 high 2。
 
 @discussion 具体参数 videoSize: 720x1280, expectedSourceVideoFrameRate: 24, videoMaxKeyframeInterval: 72, profile level: AVVideoProfileLevelH264BaselineAutoLevel, video bitrate: 1.25Mbps
 
 @since      v1.0.0
 */
extern NSString *kMovieousVideoStreamingQualityHigh2;

/*!
 @constant   kMovieousVideoStreamingQualityHigh3
 @abstract   视频编码推流质量 high 3。
 
 @discussion 具体参数 videoSize: 720x1280, expectedSourceVideoFrameRate: 24, videoMaxKeyframeInterval: 72, profile level: AVVideoProfileLevelH264BaselineAutoLevel, video bitrate: 1.5Mbps
 
 @since      v1.0.0
 */
extern NSString *kMovieousVideoStreamingQualityHigh3;

#pragma mark - Audio Streaming Quality

/*!
 @constant   kMovieousAudioStreamingQualityHigh1
 @abstract   音频编码推流质量 high 1。
 
 @discussion 具体参数 audio bitrate: 64Kbps。
 
 @since      v1.0.0
 */
extern NSString *kMovieousAudioStreamingQualityHigh1;

/*!
 @constant   kMovieousAudioStreamingQualityHigh2
 @abstract   音频编码推流质量 high 2。
 
 @discussion 具体参数 audio bitrate: 96Kbps。
 
 @since      v1.0.0
 */
extern NSString *kMovieousAudioStreamingQualityHigh2;

/*!
 @constant   kMovieousAudioStreamingQualityHigh3
 @abstract   音频编码推流质量 high 3。
 
 @discussion 具体参数 audio bitrate: 128Kbps。
 
 @since      v1.0.0
 */
extern NSString *kMovieousAudioStreamingQualityHigh3;

// post with userinfo @{@"state": @(state)}. always posted via MainQueue.
extern NSString *MovieousStreamStateDidChangeNotification;
extern NSString *MovieousCameraAuthorizationStatusDidGetNotificaiton;
extern NSString *MovieousMicrophoneAuthorizationStatusDidGetNotificaiton;

extern NSString *MovieousCameraDidStartRunningNotificaiton;
extern NSString *MovieousMicrophoneDidStartRunningNotificaiton;
extern NSString *MovieousAudioComponentFailedToCreateNotification;

/*!
 @typedef    MovieousH264EncoderType
 @abstract   H.264 编码器类型
 
 @constant   MovieousH264EncoderType_AVFoundation  采用 AVFoundation 进行编码
 @constant   MovieousH264EncoderType_VideoToolbox  采用 VideoToolbox 进行编码，只在 iOS 8 及以上支持，iOS 8 以下系统版本会自动回退为 MovieousH264EncoderType_AVFoundation 编码器
 */
typedef NS_ENUM(NSUInteger, MovieousH264EncoderType) {
    MovieousH264EncoderType_AVFoundation,    // AVFoundation 编码器
    MovieousH264EncoderType_VideoToolbox     // iOS 8 及以上系统版本可用 VideoToolbox 编码器，编码效率更优
};

/**
 @brief 音频编码模式
 */
typedef NS_ENUM(NSUInteger, MovieousAACEncoderType) {
    /**
     @brief iOS AAC（硬编）
     */
    MovieousAACEncoderType_iOS_AAC,
    /**
     @brief fdk-aac AAC
     */
    MovieousAACEncoderType_fdk_AAC_LC,
    /**
     @brief fdk-aac HE-AAC
     */
    MovieousAACEncoderType_fdk_AAC__HE_BSR
    
};

#pragma mark - Audio SampleRate

/*!
 @typedef    MovieousStreamingAudioSampleRate
 @abstract   音频编码采样率。
 
 @constant   MovieousStreamingAudioSampleRate_48000Hz 48000Hz 音频编码采样率
 @constant   MovieousStreamingAudioSampleRate_44100Hz 44100Hz 音频编码采样率
 @constant   MovieousStreamingAudioSampleRate_22050Hz 22050Hz 音频编码采样率
 @constant   MovieousStreamingAudioSampleRate_11025Hz 11025Hz 音频编码采样率
 
 @since      v1.0.0
 */
typedef NS_ENUM(NSUInteger, MovieousStreamingAudioSampleRate) {
    MovieousStreamingAudioSampleRate_48000Hz = 48000,
    MovieousStreamingAudioSampleRate_44100Hz = 44100,
    MovieousStreamingAudioSampleRate_22050Hz = 22050,
    MovieousStreamingAudioSampleRate_11025Hz = 11025,
};

#pragma mark - Audio BitRate

/*!
 @typedef    MovieousStreamingAudioBitRate
 @abstract   音频编码码率。
 
 @constant   MovieousStreamingAudioBitRate_64Kbps 64Kbps 音频码率
 @constant   MovieousStreamingAudioBitRate_96Kbps 96Kbps 音频码率
 @constant   MovieousStreamingAudioBitRate_128Kbps 128Kbps 音频码率
 
 @since      v1.0.0
 */
typedef enum {
    MovieousStreamingAudioBitRate_64Kbps = 64000,
    MovieousStreamingAudioBitRate_96Kbps = 96000,
    MovieousStreamingAudioBitRate_128Kbps = 128000,
} MovieousStreamingAudioBitRate;

/*!
 @typedef    MovieousAudioStreamEndian
 @abstract   MovieousAudioStreamEndian 音频流如何处理大小端。
 @since      @v1.2.5
 */
typedef NS_ENUM(NSUInteger, MovieousAudioStreamEndian) {
    /// MovieousAudioStreamEndian_Auto 根据 CMSampleBufferRef 的描述决定该以大端还是小端来处理
    MovieousAudioStreamEndian_Auto = 0,
    /// MovieousAudioStreamEndian_BigEndian 显式声明音频流为大端
    MovieousAudioStreamEndian_BigEndian = 1,
    /// MovieousAudioStreamEndian_LittleEndian 显式声明音频流为小端
    MovieousAudioStreamEndian_LittleEndian = 2
};

#pragma mark - Audio Channel

/*!
 @constant   kMovieousAudioChannelDefault
 @abstract   默认音频输入流
 
 @since      v1.2.5
 */
extern const NSString *kMovieousAudioChannelDefault;

/*!
 @constant   kMovieousAudioChannelApp
 @abstract   来自ReplayKit Live的Audio App音频流
 
 @since      v1.2.5
 */
extern const NSString *kMovieousAudioChannelApp;

/*!
 @constant   kMovieousAudioChannelMic
 @abstract   来自ReplayKit Live的Audio Mic音频流
 
 @since      v1.2.5
 */
extern const NSString *kMovieousAudioChannelMic;

typedef BOOL(^ConnectionInterruptionHandler)(NSError *error);

typedef enum {
    /**
     @brief 由 MovieousLive 提供的预设的音效配置
     */
    MovieousAudioEffectConfigurationType_Preset = 1,
    /**
     @brief 用户自定义音效配置
     */
    MovieousAudioEffectConfigurationType_Custom = 2
} MovieousAudioEffectConfigurationType;

typedef enum {
    MovieousAudioPlayerFileError_FileNotExist,
    MovieousAudioPlayerFileError_FileOpenFail,
    MovieousAudioPlayerFileError_FileReadingFail
} MovieousAudioPlayerFileError;

/**
 @brief 对音频数据进行处理的回调
 */
typedef void (^MovieousAudioEffectCustomConfigurationBlock)(void *inRefCon,
                                                            AudioUnitRenderActionFlags *ioActionFlags,
                                                            const AudioTimeStamp *inTimeStamp,
                                                            UInt32 inBusNumber,
                                                            UInt32 inNumberFrames,
                                                            AudioBufferList *ioData);


typedef void (^MovieousAudioSessionDidBeginInterruptionCallback)(void);

typedef void (^MovieousAudioSessionDidEndInterruptionCallback)(void);

/**
 @brief 对截图数据进行处理的回调
 
 @since v2.2.0
 */

typedef void (^MovieousStreamScreenshotHandler)(UIImage *image);

#endif /* MLTypeDefines_h */
