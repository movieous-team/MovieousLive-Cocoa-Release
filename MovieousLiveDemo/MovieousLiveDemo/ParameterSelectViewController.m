//
//  ParameterSelectiViewController.m
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2018/9/7.
//  Copyright © 2018 Movieous Team. All rights reserved.
//

#import "ParameterSelectViewController.h"

@interface ParameterSelectViewController ()

@end

@implementation ParameterSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"ParameterSelect"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _parameterKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParameterSelect" forIndexPath:indexPath];
    if (indexPath.row == _selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = _parameterKeys[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (UITableViewCell *cell in tableView.visibleCells) {
        if ([[tableView indexPathForCell:cell] isEqual:indexPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        [cell setSelected:NO animated:YES];
    }
    if ([_delegate respondsToSelector:@selector(parameterSelectViewController:didSelectedAtIndex:)]) {
        [_delegate parameterSelectViewController:self didSelectedAtIndex:indexPath.row];
    }
}

@end
