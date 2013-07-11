
#import "BoundsAnchor.h"

@implementation BoundsAnchor

+ (instancetype)anchorWithUnitPosition:(CGPoint)position absoluteOffset:(CGPoint)offset inView:(UIView *)view {
    return [[self alloc] initWithUnitPosition:position absoluteOffset:offset inView:view];
}

+ (instancetype)anchorWithUnitPosition:(CGPoint)position inView:(UIView *)view {
    return [[self alloc] initWithUnitPosition:position absoluteOffset:CGPointZero inView:view];
}

- (instancetype)initWithUnitPosition:(CGPoint)position absoluteOffset:(CGPoint)offset inView:(UIView *)view {
    if (self = [super init]) {
        _view = view;
        _position = position;
        _offset = offset;
    }
    return self;
}

- (CGPoint)pointInView:(UIView *)targetView {
    CGRect bounds = _view.bounds;
    CGPoint point = CGPointMake(bounds.origin.x + _position.x * bounds.size.width + _offset.x, bounds.origin.y + _position.y * bounds.size.width + _offset.y);
    return [_view convertPoint:point toView:targetView];
}

#pragma mark - Implementation details

+ (NSSet *)keyPathsForValuesAffectingPoint {
    return [NSSet setWithArray:@[@"view.center", @"view.bounds", @"view.frame" ]];
}

@end
