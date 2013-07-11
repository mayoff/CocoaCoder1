
#import "OriginAnchor.h"

@implementation OriginAnchor

- (CGPoint)pointInView:(UIView *)view {
    return [self.view convertPoint:CGPointZero toView:view];
}

@end
