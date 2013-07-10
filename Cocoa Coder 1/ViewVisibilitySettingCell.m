/*
Created by Rob Mayoff on 7/6/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "ViewVisibilitySettingCell.h"
#import "ViewVisibilitySetting.h"
#import "SettingCell+SubclassHooks.h"
#import "NSObject+Rob_BlockKVO.h"

@interface ViewVisibilitySettingCell ()

@property (nonatomic, strong) ViewVisibilitySetting *setting;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIButton *showViewButton;

@end

@implementation ViewVisibilitySettingCell {
    id observer;
}

+ (CGFloat)heightForSetting:(Setting *)setting {
    return 44.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateFromModel];
}

- (IBAction)showViewButtonWasTapped {
    self.setting.view.hidden = !self.setting.view.hidden;
}

- (void)updateFromModel {
    self.showViewButton.selected = !self.setting.view.hidden;
}

- (void)connect {
    self.nameLabel.text = self.setting.name;
    observer = [self.setting addObserverForKeyPath:@"view.hidden" options:NSKeyValueObservingOptionInitial selfReference:self block:^(id self, NSString *observedKeyPath, id observedObject, NSDictionary *change) {
        [self updateFromModel];
    }];
}

@end
