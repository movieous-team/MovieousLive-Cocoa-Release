//
//  DynamicConfigurationViewController.h
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2018/9/8.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MovieousLive/MovieousLive.h>
#import "ParameterSelectViewController.h"
#import "ParameterInputViewController.h"

@interface DynamicConfigurationViewController : UITableViewController
<
ParameterSelectViewControllerDelegate,
ParameterInputViewControllerDelegate
>

@property (nonatomic, strong) MLController *movieousLiveController;

@end
