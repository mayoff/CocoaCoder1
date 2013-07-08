/*
Created by Rob Mayoff on 7/6/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "ViewVisibilitySettingCell.h"
#import "ViewVisibilitySetting.h"
#import "SettingCell+SubclassHooks.h"

@interface ViewVisibilitySettingCell ()

@property (nonatomic, strong) ViewVisibilitySetting *setting;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIButton *showViewButton;

@end

static char kViewVisibilitySettingCellContext;

@implementation ViewVisibilitySettingCell

+ (CGFloat)heightForSetting:(Setting *)setting {
    return 44.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateFromModel];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != &kViewVisibilitySettingCellContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
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
    [self addObserver:self forKeyPath:@"setting.view.hidden" options:NSKeyValueObservingOptionInitial context:&kViewVisibilitySettingCellContext];
}

- (void)disconnect {
    [self removeObserver:self forKeyPath:@"setting.view.hidden" context:&kViewVisibilitySettingCellContext];
}

@end
