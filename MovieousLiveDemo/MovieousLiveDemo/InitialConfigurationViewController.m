//
//  PreConfigurationViewController.m
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2018/9/6.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import "InitialConfigurationViewController.h"
#import <MovieousLive/MovieousLive.h>
#import "BroadcastViewController.h"
#import "ParameterInputViewController.h"
#import "CustomUISwitch.h"

typedef NS_ENUM(NSInteger, ParameterType) {
    ParameterTypeBool,
    ParameterTypeMultiValue,
    ParameterTypeStringValue,
};

@interface StreamConfigurations : NSObject

@property (nonatomic, strong) NSString *URL;

@end

@implementation StreamConfigurations

@end

@interface InitialConfigurationViewController ()

@property (nonatomic, strong) MLAudioConfiguration *audioConfiguration;
@property (nonatomic, strong) MLVideoConfiguration *videoConfiguration;
@property (nonatomic, strong) StreamConfigurations *streamConfigurations;

@end

@implementation InitialConfigurationViewController {
    NSArray<NSArray *> *_parameters;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开始直播" style:UIBarButtonItemStyleDone target:self action:@selector(beginLiveBroadcat)];
    _audioConfiguration = [MLAudioConfiguration defaultConfiguration];
    _videoConfiguration = [MLVideoConfiguration defaultConfiguration];
    _streamConfigurations = [[StreamConfigurations alloc] init];
    _streamConfigurations.URL = [[NSUserDefaults standardUserDefaults] stringForKey:@"URL"];
    _parameters = @[
                    @[
                        @"Stream Configurations",
                        @"streamConfigurations",
                        @[
                            @"URL",
                            @(ParameterTypeStringValue),
                            ],
                        ],
                    @[
                        @"MLAudioConfiguration",
                        @"audioConfiguration",
                        @[
                            @"enable",
                            @(ParameterTypeBool),
                            ],
                        @[
                            @"acousticEchoCancellationEnable",
                            @(ParameterTypeBool),
                            ],
                        @[
                            @"audioBitRate",
                            @(ParameterTypeMultiValue),
                            @[
                                @"MLAudioBitRate64Kbps",
                                @"MLAudioBitRate96Kbps",
                                @"MLAudioBitRate128Kbps",
                                ],
                            @[
                                @(MLAudioBitRate64Kbps),
                                @(MLAudioBitRate96Kbps),
                                @(MLAudioBitRate128Kbps)
                                ]
                            ],
                        ],
                    @[
                        @"MLVideoConfiguration",
                        @"videoConfiguration",
                        @[
                            @"enable",
                            @(ParameterTypeBool),
                            ],
                        @[
                            @"mirrorFrontPreview",
                            @(ParameterTypeBool),
                            ],
                        @[
                            @"mirrorBackPreview",
                            @(ParameterTypeBool),
                            ],
                        @[
                            @"mirrorFrontStream",
                            @(ParameterTypeBool),
                            ],
                        @[
                            @"mirrorBackStream",
                            @(ParameterTypeBool),
                            ],
                        @[
                            @"frameRate",
                            @(ParameterTypeMultiValue),
                            @[
                                @"15",
                                @"20",
                                @"24",
                                @"30",
                                ],
                            @[
                                @15,
                                @20,
                                @24,
                                @30,
                                ]
                            ],
                        @[
                            @"cameraResolution",
                            @(ParameterTypeMultiValue),
                            @[
                                @"AVCaptureSessionPresetPhoto",
                                @"AVCaptureSessionPresetHigh",
                                @"AVCaptureSessionPresetMedium",
                                @"AVCaptureSessionPresetLow",
                                @"AVCaptureSessionPreset352x288",
                                @"AVCaptureSessionPreset640x480",
                                @"AVCaptureSessionPreset1280x720",
                                @"AVCaptureSessionPreset1920x1080",
                                @"AVCaptureSessionPreset3840x2160",
                                @"AVCaptureSessionPresetiFrame960x540",
                                @"AVCaptureSessionPresetiFrame1280x720",
                                ],
                            @[
                                AVCaptureSessionPresetPhoto,
                                AVCaptureSessionPresetHigh,
                                AVCaptureSessionPresetMedium,
                                AVCaptureSessionPresetLow,
                                AVCaptureSessionPreset352x288,
                                AVCaptureSessionPreset640x480,
                                AVCaptureSessionPreset1280x720,
                                AVCaptureSessionPreset1920x1080,
                                AVCaptureSessionPreset3840x2160,
                                AVCaptureSessionPresetiFrame960x540,
                                AVCaptureSessionPresetiFrame1280x720,
                                ],
                            ],
                        @[
                            @"cameraPosition",
                            @(ParameterTypeMultiValue),
                            @[
                                @"AVCaptureDevicePositionUnspecified",
                                @"AVCaptureDevicePositionBack",
                                @"AVCaptureDevicePositionFront",
                                ],
                            @[
                                @(AVCaptureDevicePositionUnspecified),
                                @(AVCaptureDevicePositionBack),
                                @(AVCaptureDevicePositionFront),
                                ]
                            ],
                        @[
                            @"profileLevel",
                            @(ParameterTypeMultiValue),
                            @[
                                @"AVVideoProfileLevelH264Baseline30",
                                @"AVVideoProfileLevelH264Baseline31",
                                @"AVVideoProfileLevelH264Baseline41",
                                @"AVVideoProfileLevelH264BaselineAutoLevel",
                                @"AVVideoProfileLevelH264Main30",
                                @"AVVideoProfileLevelH264Main31",
                                @"AVVideoProfileLevelH264Main32",
                                @"AVVideoProfileLevelH264Main41",
                                @"AVVideoProfileLevelH264MainAutoLevel",
                                @"AVVideoProfileLevelH264High40",
                                @"AVVideoProfileLevelH264High41",
                                @"AVVideoProfileLevelH264HighAutoLevel",
                                ],
                            @[
                                AVVideoProfileLevelH264Baseline30,
                                AVVideoProfileLevelH264Baseline31,
                                AVVideoProfileLevelH264Baseline41,
                                AVVideoProfileLevelH264BaselineAutoLevel,
                                AVVideoProfileLevelH264Main30,
                                AVVideoProfileLevelH264Main31,
                                AVVideoProfileLevelH264Main32,
                                AVVideoProfileLevelH264Main41,
                                AVVideoProfileLevelH264MainAutoLevel,
                                AVVideoProfileLevelH264High40,
                                AVVideoProfileLevelH264High41,
                                AVVideoProfileLevelH264HighAutoLevel,
                                ]
                            ],
                        @[
                            @"size",
                            @(ParameterTypeMultiValue),
                            @[
                                @"240x320",
                                @"480x640",
                                @"544x966",
                                @"720x1280",
                                @"1080x1920",
                                @"320x240",
                                @"640x480",
                                @"960x544",
                                @"1280x720",
                                @"1920x1080",
                                ],
                            @[
                                @(CGSizeMake(240, 320)),
                                @(CGSizeMake(480, 640)),
                                @(CGSizeMake(544, 960)),
                                @(CGSizeMake(720, 1280)),
                                @(CGSizeMake(1080, 1920)),
                                @(CGSizeMake(320, 240)),
                                @(CGSizeMake(640, 480)),
                                @(CGSizeMake(960, 544)),
                                @(CGSizeMake(1280, 720)),
                                @(CGSizeMake(1920, 1080)),
                                ]
                            ],
                        @[
                            @"gop",
                            @(ParameterTypeMultiValue),
                            @[
                                @"45",
                                @"60",
                                @"72",
                                @"81",
                                @"90",
                                @"120",
                                ],
                            @[
                                @45,
                                @60,
                                @72,
                                @81,
                                @90,
                                @120,
                                ]
                            ],
                        @[
                            @"averageBitRate",
                            @(ParameterTypeMultiValue),
                            @[
                                @"256kbps",
                                @"512kbps",
                                @"1mbps",
                                @"2mbps",
                                @"3mbps",
                                @"4mbps",
                                @"5mbps",
                                ],
                            @[
                                @(256 * 1024),
                                @(512 * 1024),
                                @(1 * 1024 * 1024),
                                @(2 * 1024 * 1024),
                                @(3 * 1024 * 1024),
                                @(4 * 1024 * 1024),
                                @(5 * 1024 * 1024),
                                ]
                            ],
                        ],
                    ];
}

- (void)beginLiveBroadcat {
    if (!_streamConfigurations.URL.length) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"请指定推流 URL" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    BroadcastViewController *controller = [[BroadcastViewController alloc] initWithNibName:nil bundle:nil];
    controller.URL = _streamConfigurations.URL;
    controller.audioConfiguration = _audioConfiguration;
    controller.videoConfiguration = _videoConfiguration;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _parameters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _parameters[section].count - 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _parameters[section][0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InitialConfigurationViewController" forIndexPath:indexPath];
    CustomUISwitch *customSwitch;
    NSArray *currentParameter = _parameters[indexPath.section][indexPath.row + 2];
    NSString *configName = _parameters[indexPath.section][1];
    NSString *paramName = currentParameter[0];
    ParameterType type = [currentParameter[1] integerValue];
    NSArray *parameterKeys;
    NSArray *parameterValues;
    switch (type) {
        case ParameterTypeBool:
            customSwitch = [[CustomUISwitch alloc] init];
            customSwitch.indexPath = indexPath;
            customSwitch.on = [[self valueForKeyPath:[NSString stringWithFormat:@"%@.%@", configName, paramName]] boolValue];
            [customSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.textLabel.text = paramName;
            cell.detailTextLabel.text = nil;
            cell.accessoryView = customSwitch;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case ParameterTypeMultiValue:
            parameterKeys = currentParameter[2];
            parameterValues = currentParameter[3];
            cell.textLabel.text = paramName;
            for (int i = 0; i < parameterKeys.count; i++) {
                if ([[self valueForKeyPath:[NSString stringWithFormat:@"%@.%@", configName, paramName]] isEqual:parameterValues[i]]) {
                    cell.detailTextLabel.text = parameterKeys[i];
                }
            }
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
        case ParameterTypeStringValue:
            cell.textLabel.text = paramName;
            cell.detailTextLabel.text = [self valueForKeyPath:[NSString stringWithFormat:@"%@.%@", configName, paramName]];
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        default:
            break;
    }
    return cell;
}

- (void)switchValueChanged:(CustomUISwitch *)s {
    NSIndexPath *indexPath = s.indexPath;
    [self setValue:@(s.isOn) forKeyPath:[NSString stringWithFormat:@"%@.%@", _parameters[indexPath.section][1], _parameters[indexPath.section][2 + indexPath.row][0]]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ParameterSelectViewController *parameterSelectViewController;
    ParameterInputViewController *parameterInputViewController;
    NSArray *currentParameter = _parameters[indexPath.section][indexPath.row + 2];
    NSString *configName = _parameters[indexPath.section][1];
    NSString *paramName = currentParameter[0];
    ParameterType type = [currentParameter[1] integerValue];
    NSArray *parameterKeys;
    NSArray *parameterValues;
    switch (type) {
        case ParameterTypeMultiValue:
            parameterSelectViewController = [[ParameterSelectViewController alloc] initWithStyle:UITableViewStylePlain];
            parameterKeys = currentParameter[2];
            parameterValues = currentParameter[3];
            parameterSelectViewController.title = _parameters[indexPath.section][indexPath.row + 2][0];
            parameterSelectViewController.parameterKeys = _parameters[indexPath.section][indexPath.row + 2][2];
            parameterSelectViewController.refCon = indexPath;
            parameterSelectViewController.delegate = self;
            for (int i = 0; i < parameterKeys.count; i++) {
                if ([[self valueForKeyPath:[NSString stringWithFormat:@"%@.%@", configName, paramName]] isEqual:parameterValues[i]]) {
                    parameterSelectViewController.selectedIndex = i;
                }
            }
            [self.navigationController pushViewController:parameterSelectViewController animated:YES];
            break;
        case ParameterTypeStringValue:
            parameterInputViewController = [[ParameterInputViewController alloc] initWithNibName:nil bundle:nil];
            parameterInputViewController.title = _parameters[indexPath.section][indexPath.row + 2][0];
            parameterInputViewController.text = [self valueForKeyPath:[NSString stringWithFormat:@"%@.%@", _parameters[indexPath.section][1], _parameters[indexPath.section][2 + indexPath.row][0]]];
            parameterInputViewController.refCon = indexPath;
            parameterInputViewController.delegate = self;
            [self.navigationController pushViewController:parameterInputViewController animated:YES];
        default:
            break;
    }
}

- (void)parameterSelectViewController:(ParameterSelectViewController *)controller didSelectedAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = controller.refCon;
    [self setValue:_parameters[indexPath.section][indexPath.row + 2][3][index] forKeyPath:[NSString stringWithFormat:@"%@.%@", _parameters[indexPath.section][1], _parameters[indexPath.section][2 + indexPath.row][0]]];
    [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = _parameters[indexPath.section][indexPath.row + 2][2][index];
}

- (void)parameterInputTableViewController:(ParameterInputViewController *)controller didInputText:(NSString *)text {
    NSIndexPath *indexPath = controller.refCon;
    [self setValue:text forKeyPath:[NSString stringWithFormat:@"%@.%@", _parameters[indexPath.section][1], _parameters[indexPath.section][2 + indexPath.row][0]]];
    [[NSUserDefaults standardUserDefaults] setObject:text forKey:_parameters[indexPath.section][2 + indexPath.row][0]];
    [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = text;
}

@end
