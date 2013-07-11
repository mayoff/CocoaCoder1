
#import <Foundation/Foundation.h>

#import "Anchor.h"

/**
A BoundsAnchor is attached to a relative horizontal position in a view's bounds rectangle.  A position of 0 refers to the minimum coordinate in the bounds rectangle, and a position of 1 refers to the maximum coordinate in the bounds rectangle.
*/

@interface BoundsAnchor : Anchor

+ (instancetype)anchorWithUnitPosition:(CGPoint)position inView:(UIView *)view;
+ (instancetype)anchorWithUnitPosition:(CGPoint)position absoluteOffset:(CGPoint)offset inView:(UIView *)view;

@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) CGPoint offset;

@end
