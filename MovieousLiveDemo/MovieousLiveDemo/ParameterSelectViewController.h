//
//  ParameterSelectiViewController.h
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2018/9/7.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParameterSelectViewController;

@protocol ParameterSelectViewControllerDelegate<NSObject>

@optional
- (void)parameterSelectViewController:(ParameterSelectViewController *)controller didSelectedAtIndex:(NSInteger)index;

@end

@interface ParameterSelectViewController : UITableViewController

@property (nonatomic, strong) id refCon;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray<NSString *> *parameterKeys;
@property (nonatomic, weak) id<ParameterSelectViewControllerDelegate> delegate;

@end
