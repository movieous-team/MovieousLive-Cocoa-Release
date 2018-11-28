//
//  BroadcastViewController.h
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2018/9/7.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MovieousLive/MovieousLive.h>

@interface BroadcastViewController : UIViewController
<
MLControllerDelegate
>

@property (nonatomic, strong) MLAudioConfiguration *audioConfiguration;
@property (nonatomic, strong) MLVideoConfiguration *videoConfiguration;
@property (nonatomic, strong) NSString *URL;

@end
