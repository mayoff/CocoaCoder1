
#import "Anchor.h"

static char kAnchorContext;

@implementation Anchor

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

        [self startObservingLayoutOfView:_xView];
        [self startObservingLayoutOfView:_yView];
    }
    return self;
}

- (void)dealloc {
    [self stopObservingLayoutOfView:_xView];
    [self stopObservingLayoutOfView:_yView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != &kAnchorContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }

    [self willChangeValueForKey:@"point"];
    [self didChangeValueForKey:@"point"];
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

- (void)startObservingLayoutOfView:(UIView *)view {
    [view addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionInitial context:&kAnchorContext];
    [view addObserver:self forKeyPath:@"bounds" options:0 context:&kAnchorContext];
    [view addObserver:self forKeyPath:@"frame" options:0 context:&kAnchorContext];
}

- (void)stopObservingLayoutOfView:(UIView *)view {
    [view removeObserver:self forKeyPath:@"center" context:&kAnchorContext];
    [view removeObserver:self forKeyPath:@"bounds" context:&kAnchorContext];
    [view removeObserver:self forKeyPath:@"frame" context:&kAnchorContext];
}

@end
