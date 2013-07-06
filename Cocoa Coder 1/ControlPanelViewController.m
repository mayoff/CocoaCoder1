
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
    Setting *setting = [self settingForIndexPath:indexPath];
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:setting.cellReuseIdentifier];

    cell.setting = setting;
    
    return cell;
}

#pragma mark - UITableViewDelegate protocol

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Setting *setting = [self settingForIndexPath:indexPath];
    Class cellClass = setting.cellClass;
    return [cellClass heightForSetting:setting];
}

#pragma mark - Implementation details

- (Setting *)settingForIndexPath:(NSIndexPath *)indexPath {
    return self.settings[indexPath.row];
}

@end
