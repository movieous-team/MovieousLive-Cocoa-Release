//
//  ParameterInputTableViewController.m
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2018/9/7.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import "ParameterInputViewController.h"

@interface ParameterInputViewController ()

@property (strong, nonatomic) IBOutlet UITextField *inputView;

@end

@implementation ParameterInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)];
    _inputView.text = _text;
    _inputView.delegate = self;
    [_inputView becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doneButtonPressed:nil];
    return YES;
}

- (void)doneButtonPressed:(UIBarButtonItem *)sender {
    if ([_delegate respondsToSelector:@selector(parameterInputTableViewController:didInputText:)]) {
        [_delegate parameterInputTableViewController:self didInputText:_inputView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
