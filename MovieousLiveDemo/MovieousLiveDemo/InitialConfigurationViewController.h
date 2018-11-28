//
//  PreConfigurationViewController.h
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2018/9/6.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterSelectViewController.h"
#import "ParameterInputViewController.h"

@interface InitialConfigurationViewController : UITableViewController
<
ParameterSelectViewControllerDelegate,
ParameterInputViewControllerDelegate
>

@end
