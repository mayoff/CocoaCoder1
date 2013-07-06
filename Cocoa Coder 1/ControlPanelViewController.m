/*
Created by Rob Mayoff on 7/6/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "ControlPanelViewController.h"
#import "SettingCell.h"
#import "Setting.h"

@interface ControlPanelViewController ()

@end

@implementation ControlPanelViewController

#pragma mark - Public API

- (void)setSettings:(NSArray *)settings {
    _settings = [settings copy];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.setting = [self settingForIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate protocol

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self settingForIndexPath:indexPath].shouldShowControls ? 139.0f : 44.0f;
}

#pragma mark - Implementation details

- (Setting *)settingForIndexPath:(NSIndexPath *)indexPath {
    return self.settings[indexPath.row];
}

@end
