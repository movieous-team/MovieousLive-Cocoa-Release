# MovieousLive-Cocoa

`MovieousLive-Cocoa` 是 [Movieous](https://movieous.cn) 研发的适用于 iOS 平台的一站式 RTMP 直播推流 SDK。它提供简单易用的 API，兼容多机型及系统版本，拥有出色的性能、丰富的功能，支持包括美颜，特效，变声等在内的丰富第三方生态。集成 SDK 能够让开发者快速构建一款优秀的手机直播 app

*其他语言版本: [English](README.en-us.md), [简体中文](README.md).*

## 功能

- [x] 麦克风音频采集
- [x] 外部音频数据导入
- [x] 摄像头视频采集
- [x] UIView 录制
- [x] 外部视频数据导入
- [x] H.264 视频硬编
- [x] AAC 音频软编
- [x] RTMP 协议推流
- [x] 自定义视频分辨率
- [x] 内置美颜
- [x] LUT(look up table) 滤镜
- [x] 贴纸（水印）
- [x] 外部视频处理插件
- [x] 预览及编码的视频镜像独立配置
- [x] 内置点击对焦
- [x] 自定义手电筒模式
- [x] 自定义最大最小采集帧率
- [x] 自定义采集分辨率
- [x] 前后摄像头切换
- [x] 视频旋转
- [x] 相机变焦
- [x] 自定义对焦和曝光相关参数
- [x] 自定义 H.264 GOP 长度
- [x] 自定义 H.264 profile level
- [x] 静音
- [x] 自定义音视频码率
- [x] 推流状态实时统计
- [x] 纯音频推流
- [x] 纯视频推流
- [x] 生成快照
- [x] 自定义闪光灯模式

## 版本要求

iOS 8.0 及其以上

## 如何安装

### Cocoapods 集成

#### 安装 Cocoapods

如果您已安装 Cocoapods，则请直接跳过该步骤，直接进入下一步骤。
如果你未接触过 Cocoapods ，我们推荐您阅读 [唐巧的博客-用CocoaPods做iOS程序的依赖管理](https://blog.devtang.com/2014/05/25/use-cocoapod-to-manage-ios-lib-dependency/ "用CocoaPods做iOS程序的依赖管理") ，了解我们为何使用 Cocoapods 。另外文章中提及的淘宝源已经不再维护，需要使用 [Ruby-China RubyGems 镜像](https://gems.ruby-china.com/)替换。

如果觉得上面两个文章比较繁琐，可以直接根据我们提供的简要步骤，进行安装。
* 简要步骤：打开mac自带的 终端(terminal)，然后输入依次执行下述命令。

```bash
# 注释：Ruby-China 推荐2.6.x，实际 mac 自带的 ruby 也能用了
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem sources -l
# 注释：上面的命令，应该会输出以下内容，>>> 代表此处为输出
>>> https://gems.ruby-china.com
# 注释：确保只有 gems.ruby-china.com

sudo gem install cocoapods
# 注释：由于我们不需要使用官方库，所以可以不执行 pod setup。
```

#### 使用Podfile集成

通过 [CocoaPods](https://cocoapods.org/) 安装可以最大化地简化安装过程。
首先，在项目根目录下的 Podfile 文件中添加以下 pods（我们假设您的项目 target 名称为 `YourTargetName`）：

```ruby
target 'YourTargetName' do
    pod 'MovieousLive'
end
```

然后在项目根目录执行 `pod install` 命令，执行成功后，SDK 就集成到项目中了。如果长时间没有拉取过pod 仓库，可能出现无法找到我们的repo的情况，此时建议先使用 `pod repo update` 更新pod仓库。

## 使用方法

请参考开发者文档：[MovieousLive 开发指南](https://developer.movieous.cn/#/iOS_Live)

## 反馈及意见

当你遇到任何问题时，可以向我们提交 issue 来反馈。

[提交 issue](https://github.com/movieous-team/MovieousLive-Cocoa-Release/issues)。