# MovieousShortVideo-Cocoa

`Movieous 直播 SDK` 是 [Movieous](https://movieous.cn/) 研发的一站式 RTMP 直播推流 SDK，它提供简单易用的 API，并且拥有超强的机型及版本兼容性，极致的性能表现，丰富的功能以及众多的三方生态支持。集成 `Movieous 直播 SDK` 能够让开发者快速构建一款优秀的手机直播 app。

*其他语言版本: [English](README.md), [简体中文](README.zh-cn.md).*

## 功能

- [x] 音频数据采集
- [x] 音频采集参数配置
- [x] 视频数据采集
- [x] 视频采集参数配置
- [x] H.264 视频编码
- [x] H.264 视频编码参数配置
- [x] H.264 硬件编码
- [x] AAC 音频编码
- [x] AAC 音频编码参数配置
- [x] AAC 硬件编码
- [x] RTMP 协议推流
- [x] 返听
- [x] 内置背景音乐播放器
- [x] 麦克风与背景音乐混音
- [x] 多种音效
- [x] 自定义音频处理
- [x] 静音
- [x] 美颜
- [x] 水印
- [x] 镜像
- [x] 自定义视频处理
- [x] 纯音频或纯视频推流
- [x] 自适应码率
- [x] 动态帧率
- [x] 弱网丢帧优化
- [x] 断线或网络切换自动重连
- [x] 后台推图片 + 音频

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
首先，在项目根目录下的 Podfile 文件中添加以下 pods（我们假设您的项目 target 名称为 `iOSDemo`）：

```ruby
target 'iOSDemo' do
    pod 'MovieousLive'
end
```

<span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)">然后在项目根目录执行 </span></span>`pod install`<span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)"> </span></span>命令，执行成功后，SDK 就集成到项目中了。
<em>如果长时间没有拉取过pod 仓库，可能出现无法找到我们的repo的情况，此时建议先使用 </em><code><em>pod repo update</em></code><em> 更新pod仓库。</em>

## 使用方法

请参考开发者文档：[MovieousLive 开发指南](https://developer.movieous.cn/#/iOS_Live)

## 反馈及意见

当你遇到任何问题时，可以向我们提交 issue 来反馈。

[提交 issue](https://github.com/movieous-team/MovieousLive-Cocoa-Release/issues)。