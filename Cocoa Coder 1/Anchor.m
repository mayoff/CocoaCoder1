
#import "Anchor.h"

@implementation Anchor

@dynamic point;

+ (instancetype)anchorWithXView:(UIView *)xView position:(CGFloat)xPosition yView:(UIView *)yView position:(CGFloat)yPosition {
    return [[self alloc] initWithXView:xView position:xPosition offset:0 yView:yView position:yPosition offset:0];
}

+ (instancetype)anchorWithXView:(UIView *)xView position:(CGFloat)xPosition offset:(CGFloat)xOffset yView:(UIView *)yView position:(CGFloat)yPosition offset:(CGFloat)yOffset {
    return [[self alloc] initWithXView:xView position:xPosition offset:xOffset yView:yView position:yPosition offset:yOffset];
}

- (instancetype)initWithXView:(UIView *)xView position:(CGFloat)xPosition offset:(CGFloat)xOffset yView:(UIView *)yView position:(CGFloat)yPosition offset:(CGFloat)yOffset {
    if (self = [super init]) {
        _xView = xView;
        _xPosition = xPosition;
        _xOffset = xOffset;
        _yView = yView;
        _yPosition = yPosition;
        _yOffset = yOffset;
    }
    return self;
}

- (CGPoint)pointInView:(UIView *)view {
    CGRect xBounds = _xView.bounds;
    CGPoint xPoint = CGPointMake(xBounds.origin.x + _xPosition * xBounds.size.width + _xOffset, 0);
    xPoint = [_xView convertPoint:xPoint toView:view];

    CGRect yBounds = _yView.bounds;
    CGPoint yPoint = CGPointMake(0, yBounds.origin.y + _yPosition * yBounds.size.height + _yOffset);
    yPoint = [_yView convertPoint:yPoint toView:view];

    return CGPointMake(xPoint.x, yPoint.y);
}

#pragma mark - Implementation details

+ (NSSet *)keyPathsForValuesAffectingPoint {
    return [NSSet setWithArray:@[@"xView.center", @"xView.bounds", @"xView.frame", @"yView.center", @"yView.bounds", @"yView.frame"]];
}

@end
