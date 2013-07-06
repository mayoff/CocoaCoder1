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

@end

static char kViewVisibilitySettingCellContext;

@implementation ViewVisibilitySettingCell

+ (CGFloat)heightForSetting:(Setting *)setting {
    return 44.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initTapGestureRecognizer];
    [self updateFromModel];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != &kViewVisibilitySettingCellContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    [self updateFromModel];
}

- (void)initTapGestureRecognizer {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasTapped:)];
    [self.contentView addGestureRecognizer:recognizer];
}

- (void)cellWasTapped:(UITapGestureRecognizer *)recognizer {
    self.setting.view.hidden = !self.setting.view.hidden;
}

- (void)updateFromModel {
    self.accessoryType = self.setting.view.hidden ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
}

- (void)connect {
    self.nameLabel.text = self.setting.name;
    [self addObserver:self forKeyPath:@"setting.view.hidden" options:NSKeyValueObservingOptionInitial context:&kViewVisibilitySettingCellContext];
}

- (void)disconnect {
    [self removeObserver:self forKeyPath:@"setting.view.hidden" context:&kViewVisibilitySettingCellContext];
}

@end
