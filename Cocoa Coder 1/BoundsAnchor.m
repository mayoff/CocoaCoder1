
#import "BoundsAnchor.h"

@implementation BoundsAnchor

- (CGPoint)pointInView:(UIView *)targetView {
    UIView *view = self.view;
    CGRect bounds = view.bounds;
    CGPoint position = self.position;
    CGPoint offset = self.offset;
    CGPoint point = CGPointMake(bounds.origin.x + position.x * bounds.size.width + offset.x, bounds.origin.y + position.y * bounds.size.height + offset.y);
    return [view convertPoint:point toView:targetView];
}

@end
