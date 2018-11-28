//
//  DynamicConfigurationViewController.m
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2018/9/8.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import "DynamicConfigurationViewController.h"
#import "CustomUISwitch.h"

typedef NS_ENUM(NSInteger, ParameterType) {
    ParameterTypeBool,
    ParameterTypeMultiValue,
    ParameterTypeStringValue,
};

@interface DynamicConfigurationViewController ()

@end

@implementation DynamicConfigurationViewController {
    NSArray<NSArray *> *_parameters;
}

- (NSString *)title {
    return @"动态参数调节";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _parameters = @[
                    @[
                        @"Basic Configuration",
                        @"movieousLiveController",
                        @[
                            @"scalingMode",
                            @(ParameterTypeMultiValue),
                            @[
                                @"MLScalingModeAspectFit",
                                @"MLScalingModeAspectFill",
                                @"MLScalingModeFill",
                                ],
                            @[
                                @(MovieousScalingModeAspectFit),
                                @(MovieousScalingModeAspectFill),
                                @(MovieousScalingModeFill),
                                ]
                            ],
                        @[
                            @"dynamicFrameRate",
                            @(ParameterTypeBool),
                            ],
                        @[
                            @"autoReconnect",
                            @(ParameterTypeBool),
                            ],
                        @[
                            @"monitorNetwork",
                            @(ParameterTypeBool),
                            ],
                        ],
                    @[
                        @"Video Configuration",
                        @"movieousLiveController",
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
                            @"cameraOrientation",
                            @(ParameterTypeMultiValue),
                            @[
                                @"AVCaptureVideoOrientationPortrait",
                                @"AVCaptureVideoOrientationPortraitUpsideDown",
                                @"AVCaptureVideoOrientationLandscapeRight",
                                @"AVCaptureVideoOrientationLandscapeLeft",
                                ],
                            @[
                                @(AVCaptureVideoOrientationPortrait),
                                @(AVCaptureVideoOrientationPortraitUpsideDown),
                                @(AVCaptureVideoOrientationLandscapeRight),
                                @(AVCaptureVideoOrientationLandscapeLeft),
                                ]
                            ],
                        @[
                            @"continuousAutofocus",
                            @(ParameterTypeBool),
                            ],
                        @[
                            @"cameraZoomFactor",
                            @(ParameterTypeMultiValue),
                            @[
                                @"1",
                                @"2",
                                @"3",
                                @"5",
                                @"10",
                                ],
                            @[
                                @1,
                                @2,
                                @3,
                                @5,
                                @10,
                                ]
                            ],
                        @[
                            @"torchOn",
                            @(ParameterTypeBool),
                            ],
                        ],
                    ];
}

- (void)switchValueChanged:(CustomUISwitch *)s {
    NSIndexPath *indexPath = s.indexPath;
    if ([[self valueForKeyPath:[NSString stringWithFormat:@"%@.%@", _parameters[indexPath.section][1], _parameters[indexPath.section][2 + indexPath.row][0]]] isEqual:@(s.isOn)]) {
        return;
    }
    @try {
        [self setValue:@(s.isOn) forKeyPath:[NSString stringWithFormat:@"%@.%@", _parameters[indexPath.section][1], _parameters[indexPath.section][2 + indexPath.row][0]]];
    } @catch (NSException *exception) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:exception.name message:exception.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        s.on = !s.isOn;
        return;
    }
}

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicConfigurationViewController"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DynamicConfigurationViewController"];
    }
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
    @try {
        [self setValue:_parameters[indexPath.section][indexPath.row + 2][3][index] forKeyPath:[NSString stringWithFormat:@"%@.%@", _parameters[indexPath.section][1], _parameters[indexPath.section][2 + indexPath.row][0]]];
    } @catch (NSException *exception) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:exception.name message:exception.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = _parameters[indexPath.section][indexPath.row + 2][2][index];
}

- (void)parameterInputTableViewController:(ParameterInputViewController *)controller didInputText:(NSString *)text {
    NSIndexPath *indexPath = controller.refCon;
    [self setValue:text forKeyPath:[NSString stringWithFormat:@"%@.%@", _parameters[indexPath.section][1], _parameters[indexPath.section][2 + indexPath.row][0]]];
    [[NSUserDefaults standardUserDefaults] setObject:text forKey:_parameters[indexPath.section][2 + indexPath.row][0]];
    [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = text;
}

@end
