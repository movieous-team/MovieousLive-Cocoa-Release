//
//  ParameterInputTableViewController.h
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2018/9/7.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParameterInputViewController;

@protocol ParameterInputViewControllerDelegate<NSObject>

@optional
- (void)parameterInputTableViewController:(ParameterInputViewController *)controller didInputText:(NSString *)text;

@end

@interface ParameterInputViewController : UIViewController
<
UITextFieldDelegate
>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) id refCon;
@property (nonatomic, weak) id<ParameterInputViewControllerDelegate> delegate;

@end
