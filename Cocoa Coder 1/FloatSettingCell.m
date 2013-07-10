
#import "FloatSettingCell.h"
#import "FloatSetting.h"
#import "SettingCell+SubclassHooks.h"
#import "UIView+Rob_FindAncestor.h"
#import "NumberCell.h"
#import "DialView.h"
#import "NSObject+Rob_BlockKVO.h"

@interface FloatSettingCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) FloatSetting *setting;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *showCalloutButton;
@property (strong, nonatomic) IBOutlet DialView *dialView;

@end

@implementation FloatSettingCell {
    id floatValueObserver;
    BOOL isUpdatingFromUserInterface : 1;
}

#pragma mark - Public API

+ (CGFloat)heightForSetting:(FloatSetting *)setting {
    // These must match the prototype cell in the storyboard.
    return setting.shouldShowControls ? 91.0f : 44.0f;
}

#pragma mark - SettingCell+SubclassingHooks

- (void)connect {
    self.nameLabel.text = self.setting.name;
    floatValueObserver = [self.setting addObserverForKeyPath:@"floatValue" options:NSKeyValueObservingOptionInitial selfReference:self block:^(FloatSettingCell *self, NSString *observedKeyPath, id observedObject, NSDictionary *change) {
        if (!self->isUpdatingFromUserInterface) {
            [self updateFromModel];
        }
    }];
}

- (void)disconnect {
    floatValueObserver = nil;
}

#pragma mark - NSObject overrides

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addTapGestureRecognizerToNameLabel];
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

- (IBAction)showCalloutButtonWasTapped:(id)sender {
    self.setting.calloutView.hidden = !self.setting.calloutView.hidden;
    [self updateFromModel];
}

- (IBAction)dialValueDidChange {
    isUpdatingFromUserInterface = YES;
    self.setting.floatValue = roundf(self.dialView.value);
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
    self.showCalloutButton.selected = !self.setting.calloutView.hidden;
    if (self.dialView.value != self.setting.floatValue) {
        self.dialView.value = self.setting.floatValue;
    }
}

@end
