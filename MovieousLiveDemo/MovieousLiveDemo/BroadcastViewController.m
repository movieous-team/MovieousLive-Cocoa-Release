//
//  BroadcastViewController.m
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2018/9/7.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import "BroadcastViewController.h"
#import "DynamicConfigurationViewController.h"

@interface BroadcastViewController () {
    MLController *_movieousLiveController;
}

@property (strong, nonatomic) IBOutlet UIButton *startBroadcastingButton;

@end

@implementation BroadcastViewController

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
        UIAlertController *alertController;
        switch (transition) {
            case MLNetworkStateTransitionUnconnectedToWiFi:
            case MLNetworkStateTransitionUnconnectedToWWAN:
            case MLNetworkStateTransitionWiFiToWWAN:
            case MLNetworkStateTransitionWWANToWiFi:
                return YES;
            default:
                alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"网络断开" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [wSelf.navigationController popViewControllerAnimated:YES];
                }]];
                [wSelf presentViewController:alertController animated:YES completion:nil];
                return NO;
                break;
        }
    };
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"动态参数调节" style:UIBarButtonItemStylePlain target:self action:@selector(configButtonPressed:)];
    [self.view insertSubview:_movieousLiveController.preview atIndex:0];
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

- (IBAction)startButtonPressed:(UIButton *)sender {
    if (sender.selected) {
        [_movieousLiveController stopBroadcasting];
        sender.selected = NO;
    } else {
        [_movieousLiveController startBroadcastingWithCompletion:^(NSError *error) {
            if (!error) {
                sender.selected = YES;
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:[NSString stringWithFormat:@"推流错误: %@", error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }
}

- (void)controller:(MLController *)controller stateDidChange:(MLState)state error:(NSError *)error {
    if (state == MLStateError) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:[NSString stringWithFormat:@"推流错误: %@", error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        _startBroadcastingButton.selected = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
