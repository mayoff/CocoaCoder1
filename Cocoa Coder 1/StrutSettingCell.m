
#import "StrutSettingCell.h"
#import "StrutSetting.h"
#import "StrutView.h"
#import "SettingCell+SubclassHooks.h"
#import "UIView+Rob_FindAncestor.h"
#import "NumberCell.h"
#import "DialView.h"

@interface StrutSettingCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) StrutSetting *setting;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *showStrutButton;
@property (strong, nonatomic) IBOutlet UIButton *showArrowButton;
@property (strong, nonatomic) IBOutlet DialView *dialView;

@end

static char kStrutSettingCellContext;

@implementation StrutSettingCell {
    BOOL isUpdatingFromUserInterface : 1;
}

#pragma mark - Public API

+ (CGFloat)heightForSetting:(StrutSetting *)setting {
    // These must match the prototype cell in the storyboard.
    return setting.shouldShowControls ? 139.0f : 44.0f;
}

#pragma mark - SettingCell+SubclassingHooks

- (void)connect {
    self.nameLabel.text = self.setting.name;
    [self.setting.strutView addObserver:self forKeyPath:@"bounds" options:0 context:&kStrutSettingCellContext];
    [self.setting.strutView addObserver:self forKeyPath:@"frame" options:0 context:&kStrutSettingCellContext];
    [self updateFromModel];
}

- (void)disconnect {
    [self.setting.strutView removeObserver:self forKeyPath:@"bounds" context:&kStrutSettingCellContext];
    [self.setting.strutView removeObserver:self forKeyPath:@"frame" context:&kStrutSettingCellContext];
}

#pragma mark - NSObject overrides

- (void)dealloc {
    [self disconnect];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addTapGestureRecognizerToNameLabel];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kStrutSettingCellContext) {
        if (!isUpdatingFromUserInterface) {
            [self updateFromModel];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UICollectionViewDataSource overrides

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Number" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

#pragma mark - Storyboard actions

- (IBAction)showStrutButtonWasTapped:(id)sender {
    self.setting.strutView.hidden = !self.setting.strutView.hidden;
    [self updateFromModel];
}

- (IBAction)dialValueDidChange {
    isUpdatingFromUserInterface = YES;
    if (_setValue) {
        _setValue(self.dialView.value);
    }
    isUpdatingFromUserInterface = NO;
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
