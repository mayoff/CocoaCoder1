
@import Foundation;

/** I am an abstract base class. */
@interface Anchor : NSObject

- (instancetype)initWithView:(UIView *)view;

@property (nonatomic, strong, readonly) UIView *view;

/** I return the point to which I am anchored, in the coordinate system of `view`. */
- (CGPoint)pointInView:(UIView *)view;

@end
