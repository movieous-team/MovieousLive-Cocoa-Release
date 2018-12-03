# MovieousLive-Cocoa

MovieousLive is a one-step RTMP live stream SDK developed by [Movieous](https://movieous.cn/), which provides a concise API with superior model and version compatibility and extreme performance. Rich features and numerous tripartite ecological support. Integrated MovieousLive enables developers to quickly generate an excellent mobile live app.

*Read this in other languages: [English](README.md), [简体中文](README.zh-cn.md).*

## Features

- [x] Audio data collection
- [x] Audio collection parameter settings
- [x] Video data collection
- [x] Video collection parameter settings
- [x] H.264 Video encoding
- [x] H.264 Video encoding parameter settings
- [x] H.264 hardware encoding
- [x] AAC encoding
- [x] AAC Audio encoding parameter settings
- [x] AAC hardware encoding
- [x] RTMP protocol stream pushing
- [x] Listen back (listen to your own sound through ear phone)
- [x] Built-in background music player
- [x] Mix the microphone with the background music
- [x] Multiple music effects
- [x] Customize audio processing
- [x] Mute
- [x] Beautify
- [x] Watermark
- [x] Mirror 
- [x] Customize video processing
- [x] Pure audio or video stream pushing
- [x] Adative bitrate
- [x] Dynamic frame rate
- [x] weak network frame loss optimization
- [x] Automatically reconnect in Paused or switched network 
- [x] Pushing picture and Audio from backstage

## SDK Requirements

iOS 8.0 or later

## How to install
MovieousLive supports multiple methods for installing the library in a project.

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like MovieousLive in your projects. See the ["Getting Started" guide for more information](https://developer.movieous.cn/#/en-uk/iOS_Live?id=quict-start). You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build MovieousLive.

#### Podfile

To integrate MovieousLive into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
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