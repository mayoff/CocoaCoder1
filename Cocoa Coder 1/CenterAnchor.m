
#import "CenterAnchor.h"

@implementation CenterAnchor

- (CGPoint)pointInView:(UIView *)view {
    return [self.view.superview convertPoint:self.view.center toView:view];
}

@end
