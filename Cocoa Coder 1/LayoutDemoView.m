
#import "LayoutDemoView.h"
#import "CanvasView.h"
#import "UIColor+my_projectColors.h"
@import QuartzCore;

@interface LayoutDemoView ()

@end

@implementation LayoutDemoView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderWidth = 2;
    self.layer.borderColor = [self.backgroundColor my_borderColor].CGColor;
}


- (void)setCenter:(CGPoint)center {
    if (!CGPointEqualToPoint(center, self.center)) {
        [super setCenter:center];
        [self postLayoutDidChangeNotification];
    }
}

- (void)setBounds:(CGRect)bounds {
    if (!CGRectEqualToRect(bounds, self.bounds)) {
        [super setBounds:bounds];
        [self postLayoutDidChangeNotification];
    }
}

- (void)setFrame:(CGRect)frame {
    if (!CGRectEqualToRect(frame, self.frame)) {
        [super setFrame:frame];
        [self postLayoutDidChangeNotification];
    }
}

- (void)postLayoutDidChangeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:LayoutDemoViewLayoutDidChange object:self];
}

@end

NSString *const LayoutDemoViewLayoutDidChange = @"LayoutDemoViewLayoutDidChange";
