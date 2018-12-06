//
//  BroadcastViewController.m
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2018/9/7.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import "BroadcastViewController.h"
#import "DynamicConfigurationViewController.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "FUManager.h"
#import "FULiveModel.h"
#import <FUAPIDemoBar/FUAPIDemoBar.h>
#import "MovieousLiveDemo-Swift.h"
#import "RTCVideoSource.h"

#define AgoraAppID @"e60c1f4119b74b5c93d3c3a9f79a3d9c"

@interface StickerCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation StickerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    _imageView.frame = self.bounds;
}

@end

@interface BroadcastViewController ()
<
AgoraRtcEngineDelegate,
MLControllerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
FUAPIDemoBarDelegate,
UIGestureRecognizerDelegate
>

@property (strong, nonatomic) IBOutlet UIButton *startBroadcastingButton;
@property (strong, nonatomic) IBOutlet UIButton *startRTCButton;
@property (strong, nonatomic) IBOutlet UITextField *roomNumberTextField;
@property (strong, nonatomic) IBOutlet UICollectionView *stickerView;
@property (strong, nonatomic) IBOutlet FUAPIDemoBar *demoBar;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *bottomViews;
@property (strong, nonatomic) IBOutlet UIView *previewContainer;

@end

@implementation BroadcastViewController {
    MLController *_movieousLiveController;
    AgoraRtcEngineKit *_rtcEngine;
    NSMutableArray<NSString *> *_FUItems;
    NSMutableArray<VideoSession *> *_videoSessions;
    VideoSession *_fullSession;
    BOOL _isRTCStreaming;
    BOOL _isStreaming;
    RTCVideoSource *_videoSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!_audioConfiguration) {
        _audioConfiguration = [MLAudioConfiguration defaultConfiguration];
    }
    if (!_videoConfiguration) {
        _videoConfiguration = [MLVideoConfiguration defaultConfiguration];
    }
    _movieousLiveController = [[MLController alloc] initWithURL:[NSURL URLWithString:_URL] audioConfiguration:_audioConfiguration videoConfiguration:_videoConfiguration];
    _movieousLiveController.delegate = self;
    _movieousLiveController.headphoneMonitor = YES;
    [_movieousLiveController startCapturingWithCompletion:^(AVAuthorizationStatus cameraAuthorizationStatus, AVAuthorizationStatus microphoneAuthorizationStatus, NSError *error) {
        NSString *errMsg = nil;
        if (error) {
            errMsg = error.localizedDescription;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:[NSString stringWithFormat:@"推流错误: %@", error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    __weak typeof(self) wSelf = self;
    _movieousLiveController.connectionChangeActionHandler = ^BOOL(MLNetworkStateTransition transition) {
        NSLog(@"transation: %lu", (unsigned long)transition);
        switch (transition) {
            case MLNetworkStateTransitionUnconnectedToWiFi:
            case MLNetworkStateTransitionUnconnectedToWWAN:
            case MLNetworkStateTransitionWiFiToWWAN:
            case MLNetworkStateTransitionWWANToWiFi:
                return YES;
            default:
                SHOW_ALERT_FOR(@"错误", @"网络断开", @"好的", wSelf)
                return NO;
        }
    };
    [self loadFU];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"动态参数调节" style:UIBarButtonItemStylePlain target:self action:@selector(configButtonPressed:)];
    _FUItems = [NSMutableArray array];
    for (FULiveModel *model in [FUManager shareManager].dataSource) {
        if (model.type == FULiveModelTypeMusicFilter || !model.enble) {
            continue;
        }
        if (model.items.count > 0) {
            [_FUItems addObjectsFromArray:model.items];
        }
    }
    [_stickerView registerClass:StickerCell.class forCellWithReuseIdentifier:@"Cell"];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    _demoBar.delegate = self;
    [self demoBarSetBeautyDefultParams];
    _videoSource = [RTCVideoSource new];
    VideoSession *session = [VideoSession localSession];
    session.hostingView = _movieousLiveController.preview;
    _videoSessions = [NSMutableArray arrayWithObject:session];
    [self updateInterfaceWithAnimation:YES];
}

- (void)dealloc {
    [_rtcEngine leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        [AgoraRtcEngineKit destroy];
    }];
}

- (IBAction)stickerButtonPressed:(UIButton *)sender {
    for (UIView *view in _bottomViews) {
        view.hidden = _stickerView.hidden;
    }
    _stickerView.hidden = !_stickerView.hidden;
    _demoBar.hidden = !_stickerView.hidden;
}

- (IBAction)faceBeautyButtonPressed:(UIButton *)sender {
    for (UIView *view in _bottomViews) {
        view.hidden = _demoBar.hidden;
    }
    _demoBar.hidden = !_demoBar.hidden;
    _stickerView.hidden = !_demoBar.hidden;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_demoBar] || [touch.view isDescendantOfView:_stickerView]) {
        return NO;
    }
    return YES;
}

- (void)demoBarSetBeautyDefultParams {
    _demoBar.skinDetect = [FUManager shareManager].skinDetectEnable;
    _demoBar.heavyBlur = [FUManager shareManager].blurShape ;
    _demoBar.blurLevel = [FUManager shareManager].blurLevel ;
    _demoBar.colorLevel = [FUManager shareManager].whiteLevel ;
    _demoBar.redLevel = [FUManager shareManager].redLevel;
    _demoBar.eyeBrightLevel = [FUManager shareManager].eyelightingLevel ;
    _demoBar.toothWhitenLevel = [FUManager shareManager].beautyToothLevel ;
    _demoBar.faceShape = [FUManager shareManager].faceShape ;
    _demoBar.enlargingLevel = [FUManager shareManager].enlargingLevel ;
    _demoBar.thinningLevel = [FUManager shareManager].thinningLevel ;
    _demoBar.enlargingLevel_new = [FUManager shareManager].enlargingLevel_new ;
    _demoBar.thinningLevel_new = [FUManager shareManager].thinningLevel_new ;
    _demoBar.chinLevel = [FUManager shareManager].jewLevel ;
    _demoBar.foreheadLevel = [FUManager shareManager].foreheadLevel ;
    _demoBar.noseLevel = [FUManager shareManager].noseLevel ;
    _demoBar.mouthLevel = [FUManager shareManager].mouthLevel ;
    
    _demoBar.filtersDataSource = [FUManager shareManager].filtersDataSource ;
    _demoBar.beautyFiltersDataSource = [FUManager shareManager].beautyFiltersDataSource ;
    _demoBar.filtersCHName = [FUManager shareManager].filtersCHName ;
    _demoBar.selectedFilter = [FUManager shareManager].selectedFilter ;
    _demoBar.selectedFilterLevel = [FUManager shareManager].selectedFilterLevel;
}

- (void)syncBeautyParams {
    [FUManager shareManager].skinDetectEnable = _demoBar.skinDetect;
    [FUManager shareManager].blurShape = _demoBar.heavyBlur;
    [FUManager shareManager].blurLevel = _demoBar.blurLevel ;
    [FUManager shareManager].whiteLevel = _demoBar.colorLevel;
    [FUManager shareManager].redLevel = _demoBar.redLevel;
    [FUManager shareManager].eyelightingLevel = _demoBar.eyeBrightLevel;
    [FUManager shareManager].beautyToothLevel = _demoBar.toothWhitenLevel;
    [FUManager shareManager].faceShape = _demoBar.faceShape;
    [FUManager shareManager].enlargingLevel = _demoBar.enlargingLevel;
    [FUManager shareManager].thinningLevel = _demoBar.thinningLevel;
    [FUManager shareManager].enlargingLevel_new = _demoBar.enlargingLevel_new;
    [FUManager shareManager].thinningLevel_new = _demoBar.thinningLevel_new;
    [FUManager shareManager].jewLevel = _demoBar.chinLevel;
    [FUManager shareManager].foreheadLevel = _demoBar.foreheadLevel;
    [FUManager shareManager].noseLevel = _demoBar.noseLevel;
    [FUManager shareManager].mouthLevel = _demoBar.mouthLevel;
    
    [FUManager shareManager].selectedFilter = _demoBar.selectedFilter ;
    [FUManager shareManager].selectedFilterLevel = _demoBar.selectedFilterLevel;
}

- (void)demoBarBeautyParamChanged {
    [self syncBeautyParams];
}


- (CVPixelBufferRef)controller:(MLController *)controller didGetVideoData:(CVPixelBufferRef)videoData {
    videoData = [FUManager.shareManager renderItemsToPixelBuffer:videoData];
    static int64_t timestampValue = 0;
    if (_isRTCStreaming) {
        [_videoSource consumePixelBuffer:videoData withTimestamp:CMTimeMake(timestampValue, (int32_t)_videoConfiguration.frameRate) rotation:AgoraVideoRotationNone];
        timestampValue++;
        if (timestampValue < 0) {
            timestampValue = 0;
        }
    }
    return videoData;
}

- (void)viewTapped:(UITapGestureRecognizer *)sender {
    for (UIView *view in _bottomViews) {
        view.hidden = NO;
    }
    _stickerView.hidden = YES;
    _demoBar.hidden = YES;
    [self.view endEditing:YES];
}

- (void)loadFU {
    [FUManager.shareManager loadFilter];
    [FUManager.shareManager setAsyncTrackFaceEnable:YES];
}

- (void)configButtonPressed:(UIBarButtonItem *)sender {
    DynamicConfigurationViewController *dynamicConfigurationViewController = [[DynamicConfigurationViewController alloc] initWithStyle:UITableViewStyleGrouped];
    dynamicConfigurationViewController.movieousLiveController = _movieousLiveController;
    [self.navigationController pushViewController:dynamicConfigurationViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    VideoSession *session = [self videoSessionWithUid:uid];
    [_rtcEngine setupRemoteVideo:session.canvas];
    [self updateTranscoding];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    VideoSession *sessionToDelete;
    for (VideoSession *session in _videoSessions) {
        if (session.uid == uid) {
            sessionToDelete = session;
            break;
        }
    }
    [sessionToDelete.hostingView removeFromSuperview];
    [_videoSessions removeObject:sessionToDelete];
    if (sessionToDelete == _fullSession) {
        _fullSession = nil;
    }
    [self updateInterfaceWithAnimation:YES];
}

- (void)updateInterfaceWithAnimation:(BOOL)animation {
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self updateInterface];
            [self.view layoutIfNeeded];
        }];
    } else {
        [self updateInterface];
    }
}

- (void)updateInterface {
    if (_videoSessions.count == 1) {
        for (int i = 0; i < _videoSessions.count; i++) {
            VideoSession *session = _videoSessions[i];
            [session.hostingView removeFromSuperview];
        }
        _videoSessions[0].hostingView.frame = _previewContainer.bounds;
        [_previewContainer addSubview:_videoSessions[0].hostingView];
    } else if (_videoSessions.count == 2) {
        for (int i = 0; i < _videoSessions.count; i++) {
            VideoSession *session = _videoSessions[i];
            [session.hostingView removeFromSuperview];
        }
        _videoSessions[0].hostingView.frame = CGRectMake(0, 0, _previewContainer.frame.size.width, _previewContainer.frame.size.height / 2);
        [_previewContainer addSubview:_videoSessions[0].hostingView];
        
        _videoSessions[1].hostingView.frame = CGRectMake(0, _previewContainer.frame.size.height / 2, _previewContainer.frame.size.width, _previewContainer.frame.size.height / 2);
        [_previewContainer addSubview:_videoSessions[1].hostingView];
    } else {
        for (int i = 0; i < _videoSessions.count; i++) {
            VideoSession *session = _videoSessions[i];
            [session.hostingView removeFromSuperview];
        }
        _videoSessions[0].hostingView.frame = CGRectMake(0, 0, _previewContainer.frame.size.width, _previewContainer.frame.size.height / 3);
        [_previewContainer addSubview:_videoSessions[0].hostingView];
        
        _videoSessions[1].hostingView.frame = CGRectMake(0, _previewContainer.frame.size.height / 3, _previewContainer.frame.size.width, _previewContainer.frame.size.height / 3);
        [_previewContainer addSubview:_videoSessions[1].hostingView];
        
        _videoSessions[2].hostingView.frame = CGRectMake(0, _previewContainer.frame.size.height * 2 / 3, _previewContainer.frame.size.width, _previewContainer.frame.size.height / 3);
        [_previewContainer addSubview:_videoSessions[2].hostingView];
    }
}

- (void)setStreamTypeForSessions:(NSArray<VideoSession *> *)sessions fullSession:(VideoSession *)fullSession {
    if (fullSession) {
        for (VideoSession *session in sessions) {
            [_rtcEngine setRemoteVideoStream:session.uid type:session == fullSession ? AgoraVideoStreamTypeHigh : AgoraVideoStreamTypeLow];
        }
    } else {
        for (VideoSession *session in sessions) {
            [_rtcEngine setRemoteVideoStream:session.uid type:AgoraVideoStreamTypeHigh];
        }
    }
}

- (VideoSession *)fetchSessionWithUid:(int64_t)uid {
    for (VideoSession *session in _videoSessions) {
        if (session.uid == uid) {
            return session;
        }
    }
    return nil;
}

- (VideoSession *)videoSessionWithUid:(int64_t)uid {
    VideoSession *session = [self fetchSessionWithUid:uid];
    if (!session) {
        session = [[VideoSession alloc] initWithUid:uid];
        [_videoSessions addObject:session];
        [self updateInterfaceWithAnimation:YES];
    }
    return session;
}

- (IBAction)startButtonPressed:(UIButton *)sender {
    if (sender.selected) {
        if (_isRTCStreaming) {
            [_rtcEngine removePublishStreamUrl:_URL];
        } else {
            [_movieousLiveController stopBroadcasting];
        }
        sender.selected = NO;
    } else {
        sender.enabled = NO;
        if (_isRTCStreaming) {
            [self updateTranscoding];
            [_rtcEngine addPublishStreamUrl:_URL transcodingEnabled:YES];
            _isStreaming = YES;
        } else {
            __weak typeof(self) wSelf = self;
            [_movieousLiveController startBroadcastingWithCompletion:^(NSError *error) {
                __strong typeof(wSelf) strongSelf = wSelf;
                if (!error) {
                    sender.selected = YES;
                    strongSelf->_isStreaming = YES;
                } else {
                    SHOW_ERROR_ALERT
                }
                sender.enabled = YES;
            }];
        }
    }
}

- (IBAction)startLianmaiPressed:(UIButton *)sender {
    if (_roomNumberTextField.text.length == 0) {
        SHOW_ALERT(@"错误", @"请输入房间号", @"好的")
        return;
    }
    if (!sender.selected) {
        sender.enabled = NO;
        __weak typeof(self) wSelf = self;
        [_movieousLiveController pauseAudioCapturing];
        [self loadAgoraKit];
        [_rtcEngine joinChannelByToken:nil channelId:_roomNumberTextField.text info:nil uid:0 joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
            __strong typeof(wSelf) strongSelf = wSelf;
            strongSelf->_isRTCStreaming = YES;
            sender.enabled = YES;
            sender.selected = YES;
            strongSelf->_videoSessions[0].uid = uid;
            if (strongSelf->_isStreaming) {
                [strongSelf updateTranscoding];
                [strongSelf->_movieousLiveController stopBroadcasting];
                [strongSelf->_rtcEngine addPublishStreamUrl:strongSelf->_URL transcodingEnabled:YES];
            }
        }];
    } else {
        sender.enabled = NO;
        __weak typeof(self) wSelf = self;
        if (_isStreaming) {
            [_rtcEngine removePublishStreamUrl:_URL];
        } else {
            [_rtcEngine leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
                __strong typeof(wSelf) strongSelf = wSelf;
                strongSelf->_isRTCStreaming = NO;
                sender.enabled = YES;
                sender.selected = NO;
                for (int i = 1; i < strongSelf->_videoSessions.count; i++) {
                    [strongSelf->_videoSessions[i].hostingView removeFromSuperview];
                }
                strongSelf->_videoSessions = [NSMutableArray arrayWithObject:strongSelf->_videoSessions[0]];
                [strongSelf updateInterfaceWithAnimation:YES];
                [strongSelf destroyAgoraKit];
            }];
        }
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine streamUnpublishedWithUrl:(NSString *)url {
    if (_isStreaming) {
        __weak typeof(self) wSelf = self;
        [_rtcEngine leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
            __strong typeof(wSelf) strongSelf = wSelf;
            strongSelf->_isRTCStreaming = NO;
            strongSelf->_startRTCButton.enabled = YES;
            strongSelf->_startRTCButton.selected = NO;
            for (int i = 1; i < strongSelf->_videoSessions.count; i++) {
                [strongSelf->_videoSessions[i].hostingView removeFromSuperview];
            }
            strongSelf->_videoSessions = [NSMutableArray arrayWithObject:strongSelf->_videoSessions[0]];
            [strongSelf updateInterfaceWithAnimation:YES];
            [strongSelf destroyAgoraKit];
            [strongSelf->_movieousLiveController resumeAudioCapturing];
            [strongSelf->_movieousLiveController startBroadcastingWithCompletion:^(NSError *error) {
                if (error) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:[NSString stringWithFormat:@"推流错误: %@", error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
        }];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine streamPublishedWithUrl:(NSString *)url errorCode:(AgoraErrorCode)errorCode {
    if (errorCode == 0) {
        __weak typeof(self) wSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(wSelf) strongSelf = wSelf;
            strongSelf->_startBroadcastingButton.enabled = YES;
            strongSelf->_startBroadcastingButton.selected = YES;
        });
    } else {
        NSString *errMsg = [NSString stringWithFormat:@"服务器推流错误: %ld", (long)errorCode];
        SHOW_ALERT(@"错误", errMsg, @"好的")
    }
}

- (void)updateTranscoding {
    AgoraLiveTranscoding *transcoding = [AgoraLiveTranscoding defaultTranscoding];
    transcoding.size = _videoConfiguration.size;
    transcoding.videoBitrate = _videoConfiguration.averageBitRate / 1024;
    transcoding.videoFramerate = _videoConfiguration.frameRate;
    transcoding.videoGop = _videoConfiguration.gop;
    CGSize canvasSize = _videoConfiguration.size;
    if (_videoSessions.count == 1) {
        AgoraLiveTranscodingUser *user = [AgoraLiveTranscodingUser new];
        user.uid = (NSUInteger)_videoSessions[0].uid;
        user.rect = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
        [transcoding addUser:user];
    } else if (_videoSessions.count == 2) {
        AgoraLiveTranscodingUser *user1 = [AgoraLiveTranscodingUser new];
        user1.uid = (NSUInteger)_videoSessions[0].uid;
        user1.rect = CGRectMake(0, 0, canvasSize.width, canvasSize.height / 2);
        [transcoding addUser:user1];
        
        AgoraLiveTranscodingUser *user2 = [AgoraLiveTranscodingUser new];
        user2.uid = (NSUInteger)_videoSessions[1].uid;
        user2.rect = CGRectMake(0, canvasSize.height / 2, canvasSize.width, canvasSize.height / 2);
        [transcoding addUser:user2];
    } else {
        AgoraLiveTranscodingUser *user1 = [AgoraLiveTranscodingUser new];
        user1.uid = (NSUInteger)_videoSessions[0].uid;
        user1.rect = CGRectMake(0, 0, canvasSize.width, canvasSize.height / 3);
        [transcoding addUser:user1];
        
        AgoraLiveTranscodingUser *user2 = [AgoraLiveTranscodingUser new];
        user2.uid = (NSUInteger)_videoSessions[1].uid;
        user2.rect = CGRectMake(0, canvasSize.height / 3, canvasSize.width, canvasSize.height / 3);
        [transcoding addUser:user2];
        
        AgoraLiveTranscodingUser *user3 = [AgoraLiveTranscodingUser new];
        user3.uid = (NSUInteger)_videoSessions[2].uid;
        user3.rect = CGRectMake(0, canvasSize.height * 2 / 3, canvasSize.width, canvasSize.height / 3);
        [transcoding addUser:user3];
    }
    [_rtcEngine setLiveTranscoding:transcoding];
}

- (void)loadAgoraKit {
    _rtcEngine = [AgoraRtcEngineKit sharedEngineWithAppId:AgoraAppID delegate:self];
    [_rtcEngine setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [_rtcEngine enableVideo];
    [_rtcEngine enableDualStreamMode:YES];
    [_rtcEngine setVideoEncoderConfiguration:[[AgoraVideoEncoderConfiguration alloc] initWithSize:_videoConfiguration.size frameRate:_videoConfiguration.frameRate bitrate:_videoConfiguration.averageBitRate orientationMode:AgoraVideoOutputOrientationModeAdaptative]];
    [_rtcEngine setClientRole:AgoraClientRoleBroadcaster];
    [_rtcEngine setVideoSource:_videoSource];
}

- (void)destroyAgoraKit {
    [AgoraRtcEngineKit destroy];
    _rtcEngine = nil;
}

- (void)controller:(MLController *)controller stateDidChange:(MLState)state error:(NSError *)error {
    if (state == MLStateError) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:[NSString stringWithFormat:@"推流错误: %@", error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        _startBroadcastingButton.selected = NO;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _FUItems.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"noitem"];
    } else {
        cell.imageView.image = [UIImage imageNamed:_FUItems[indexPath.row - 1]];
    }
    // Configure the cell
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [[FUManager shareManager] loadItem:@"noitem"];
    } else if (indexPath.row <= _FUItems.count) {
        [[FUManager shareManager] loadItem:_FUItems[indexPath.row - 1]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
