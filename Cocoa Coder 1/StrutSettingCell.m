/*
Created by Rob Mayoff on 7/6/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "StrutSettingCell.h"
#import "StrutSetting.h"
#import "StrutView.h"
#import "UIView+Rob_FindAncestor.h"

@interface StrutSettingCell ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *showStrutButton;
@property (strong, nonatomic) IBOutlet UIButton *showArrowButton;
@property (strong, nonatomic) IBOutlet UICollectionView *dialView;
@end

@implementation StrutSettingCell

#pragma mark - Public API

- (void)setSetting:(StrutSetting *)setting {
    [self disconnect];
    _setting = setting;
    [self connect];
}

#pragma mark - NSObject overrides

- (void)dealloc {
    [self disconnect];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addTapGestureRecognizerToNameLabel];
}

#pragma mark - Storyboard actions

- (IBAction)showStrutButtonWasTapped:(id)sender {
    self.setting.strutView.hidden = !self.setting.strutView.hidden;
    [self updateFromModel];
}

#pragma mark - Implementation details

- (void)addTapGestureRecognizerToNameLabel {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameLabelWasTapped)];
    [self.nameLabel addGestureRecognizer:recognizer];
}

- (void)nameLabelWasTapped {
    self.setting.shouldShowControls = !self.setting.shouldShowControls;
    UITableView *tableView = [self Rob_ancestorPassingTest:^BOOL(UIView *ancestor) {
        return [ancestor isKindOfClass:[UITableView class]];
    }];
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (void)disconnect {
    if (!_setting)
        return;
}

- (void)connect {
    if (!_setting)
        return;
    self.nameLabel.text = _setting.name;
    [self updateFromModel];
}

- (void)updateFromModel {
    self.showStrutButton.selected = !self.setting.strutView.hidden;
    self.showArrowButton.enabled = self.showStrutButton.selected;
}

@end
