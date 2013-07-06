
#import "StrutSettingCell.h"
#import "StrutSetting.h"
#import "StrutView.h"
#import "SettingCell+SubclassHooks.h"
#import "UIView+Rob_FindAncestor.h"

@interface StrutSettingCell ()

@property (nonatomic, strong) StrutSetting *setting;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *showStrutButton;
@property (strong, nonatomic) IBOutlet UIButton *showArrowButton;
@property (strong, nonatomic) IBOutlet UICollectionView *dialView;

@end

@implementation StrutSettingCell

#pragma mark - Public API

+ (CGFloat)heightForSetting:(StrutSetting *)setting {
    // These must match the prototype cell in the storyboard.
    return setting.shouldShowControls ? 139.0f : 44.0f;
}

#pragma mark - SettingCell+SubclassingHooks

- (void)connect {
    self.nameLabel.text = self.setting.name;
    [self updateFromModel];
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

- (void)updateFromModel {
    self.showStrutButton.selected = !self.setting.strutView.hidden;
    self.showArrowButton.enabled = self.showStrutButton.selected;
}

@end
