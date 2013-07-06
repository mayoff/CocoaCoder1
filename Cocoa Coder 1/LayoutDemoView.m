
#import "LayoutDemoView.h"
@import QuartzCore;
#import "UIColor+my_projectColors.h"

@implementation LayoutDemoView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderWidth = 2;
    self.layer.borderColor = [self.backgroundColor my_borderColor].CGColor;
}

@end
