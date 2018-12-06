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

/**
 * @brief Indicate video datasource type
 */
typedef NS_ENUM(NSInteger, MLVideoSource) {
    /**
     * @brief Video data from camera
     */
    MLVideoSourceCamera,
};

/**
 * @brief Indicate audio datasource type
 */
typedef NS_ENUM(NSInteger, MLAudioSource) {
    /**
     * @brief Audio data from microphone
     */
    MLAudioSourceMicrophone,
};

/**
 * @brief Audio bit rate use to encode audio
 */
typedef NS_ENUM(NSInteger, MLAudioBitRate) {
    /**
     * @brief 64 Kbps bit rate
     */
    MLAudioBitRate64Kbps = 64000,
    /**
     * @brief 96 Kbps bit rate
     */
    MLAudioBitRate96Kbps = 96000,
    /**
     * @brief 128 Kbps bit rate
     */
    MLAudioBitRate128Kbps = 128000,
};

/**
 * @brief Log level
 */
typedef NS_ENUM(NSUInteger, MLLogLevel){
    /**
     * @brief No logs
     */
    MLLogLevelOff       = 0,
    /**
     * @brief Error logs only
     */
    MLLogLevelError,
    /**
     * @brief Error and warning logs
     */
    MLLogLevelWarning,
    /**
     * @brief Error, warning and info logs
     */
    MLLogLevelInfo,
    /**
     * @brief Error, warning, info and debug logs
     */
    MLLogLevelDebug,
    /**
     * @brief Error, warning, info, debug and verbose logs
     */
    MLLogLevelVerbose,
};

typedef NS_ENUM(NSInteger, MLState) {
    /**
     * @brief Initial state
     */
    MLStateInitial,
    /**
     * @brief Controller is now connecting to server
     */
    MLStateConnecting,
    /**
     * @brief Controller is now connected to server
     */
    MLStateConnected,
    /**
     * @brief Controller is now disconnecting from server
     */
    MLStateDisconnecting,
    /**
     * @brief Controller is now disconnected from server
     */
    MLStateDisconnected,
    /**
     * @brief Controller is now reconnecting to server, this state will appear when you have enabled autoReconnect property and the controller have disconnected from server
     */
    MLStateReconnecting,
    /**
     * @brief Controller has encountered an error and stopped because of this error
     */
    MLStateError,
    /**
     * @brief Controller is now capturing audio and video if available
     */
    MLStateCapturing,
};

/**
 * @brief Network transition type
 */
typedef NS_ENUM(NSUInteger, MLNetworkStateTransition) {
    /**
     * @brief Unknown transition
     */
    MLNetworkStateTransitionUnknown = 0,
    /**
     * @brief Transition from no network to WiFi
     */
    MLNetworkStateTransitionUnconnectedToWiFi,
    /**
     * @brief Transition from no network to WWAN(4G, 3G, etc)
     */
    MLNetworkStateTransitionUnconnectedToWWAN,
    /**
     * @brief Transition from WiFi to no network
     */
    MLNetworkStateTransitionWiFiToUnconnected,
    /**
     * @brief Transition from WWAN(4G, 3G, etc) to no network
     */
    MLNetworkStateTransitionWWANToUnconnected,
    /**
     * @brief Transition from WiFi to WWAN(4G, 3G, etc)
     */
    MLNetworkStateTransitionWiFiToWWAN,
    /**
     * @brief Transition from WWAN(4G, 3G, etc) to WiFi
     */
    MLNetworkStateTransitionWWANToWiFi,
};

/**
 * @brief Handler to receive network change notification
 */
typedef BOOL(^ConnectionChangeActionHandler)(MLNetworkStateTransition transition);

#endif /* MLTypeDefines_h */
