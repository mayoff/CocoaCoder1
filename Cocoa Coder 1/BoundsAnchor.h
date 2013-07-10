
#import <Foundation/Foundation.h>

#import "Anchor.h"

/**
A BoundsAnchor is attached to a relative horizontal position in some view's bounds rectangle, and to a possibly different relative vertical position in some possibly different view's bounds rectangle.  A position of 0 refers to the minimum coordinate in the bounds rectangle, and a position of 1 refers to the maximum coordinate in the bounds rectangle.
*/

@interface BoundsAnchor : Anchor

+ (instancetype)anchorWithXView:(UIView *)xView position:(CGFloat)xPosition yView:(UIView *)yView position:(CGFloat)yPosition;
+ (instancetype)anchorWithXView:(UIView *)xView position:(CGFloat)xPosition offset:(CGFloat)xOffset yView:(UIView *)yView position:(CGFloat)yPosition offset:(CGFloat)yOffset;

@property (nonatomic, strong, readonly) UIView *xView;
@property (nonatomic, readonly) CGFloat xPosition;
@property (nonatomic, readonly) CGFloat xOffset;
@property (nonatomic, strong, readonly) UIView *yView;
@property (nonatomic, readonly) CGFloat yPosition;
@property (nonatomic, readonly) CGFloat yOffset;

@end
