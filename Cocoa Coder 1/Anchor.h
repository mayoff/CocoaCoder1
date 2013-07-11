
@import Foundation;

@interface Anchor : NSObject

/** I return the point to which I am anchored, in the coordinate system of `view`. */
- (CGPoint)pointInView:(UIView *)view;

@end
