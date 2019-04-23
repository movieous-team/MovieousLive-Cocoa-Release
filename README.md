# MovieousLive-Cocoa

MovieousLive is a one-stop RTMP live streaming SDK developed by [Movieous](http://movieous.video), which provide easy-to-use API, compatibility for multiple devices and OS versions, high performance, abundant features and support for third-party SDK including face-beaty, special-effects and sound-distortion, etc. developers can build an excellent mobile live streaming app use MovieousLive SDK.

*Read this in other languages: [English](README.md), [简体中文](README.zh-cn.md).*

## Features
- [x] microphone audio data capture
- [x] external audio data import
- [x] camera video data capture
- [x] UIVIew record
- [x] external video data import
- [x] H.264 video hardware encode
- [x] AAC audio software encode
- [x] RTMP protocol live streaming
- [x] video resolution configurable
- [x] embedded face beauty
- [x] image sticker(watermark)
- [x] preview and encoded video mirror independently configurable
- [x] embedded touch to focus
- [x] torch mode configurable
- [x] max and min capture frame rate configurable
- [x] capture resolution configurable
- [x] front and back camera switch
- [x] video orientation configurable
- [x] zoom factor configurable
- [x] focus and exposure parameters configurable
- [x] H.264 GOP length configurable
- [x] H.264 profile level configurable
- [x] mute
- [x] audio and video bitrate configurable
- [x] statistics for live streaming status

## SDK Requirements

iOS 8.0 or later

## How to install
MovieousLive supports multiple methods for installing the library in a project.

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the [Get Started](http://cocoapods.org/#get_started) section for more details.

#### Podfile

To integrate MovieousLive into your Xcode project using CocoaPods, specify it in your `Podfile`, assume your target name is `YourTargetName`:

```ruby
target 'YourTargetName' do
    pod 'MovieousLive'
end
```

Then, run the following command:

```bash
$ pod install
```

## Instructions

The documentation: [MovieousLive Development Guide](https://developer.movieous.cn/#/en-uk/iOS_Live) for your reference

## Feedback and Suggestions

Please feedback the problem by submitting issues on GitHub's repo if any problems you got, describe it as clearly as possible, It would be nice if an error message or screenshot also came together, and pointed out the type of bug or other issues in Labels.

[View existing issues and submit bugs here](https://github.com/movieous-team/MovieousLive-Cocoa-Release/issues).
[Submit issue](https://github.com/movieous-team/MovieousLive-Cocoa-Release/issues/new)