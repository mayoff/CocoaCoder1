
#import "DottedLayoutDemoView.h"
#import "NSObject+Rob_BlockKVO.h"
@import QuartzCore;

@interface DottedLayoutDemoView ()

@property (nonatomic, readonly) CAShapeLayer *layer;

@end

@implementation DottedLayoutDemoView {
    UIView *originalView;
    CGRect originalViewBoundsInMyCoordinateSystem;
    id layoutObserver;
    id hiddenObserver;
}

#pragma mark - Public API

- (id)initWithOriginalView:(UIView *)theOriginalView {
    if (!(self = [super init]))
        return nil;

    originalView = theOriginalView;
    [self initBorder];
    [self startObservingOriginalView];

    return self;
}

#pragma mark - UIView overrides

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setPath];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return CGRectContainsPoint(originalViewBoundsInMyCoordinateSystem, point);
}

#pragma mark - Implementation details

- (void)startObservingOriginalView {
    layoutObserver = [originalView addObserverForKeyPaths:@[@"center", @"bounds", @"frame"] options:NSKeyValueObservingOptionInitial selfReference:self block:^(DottedLayoutDemoView *self, NSString *observedKeyPath, id observedObject, NSDictionary *change) {
        [self setNeedsLayout];
    }];

    hiddenObserver = [originalView addObserverForKeyPath:@"hidden" options:NSKeyValueObservingOptionInitial selfReference:self block:^(DottedLayoutDemoView *self, NSString *observedKeyPath, id observedObject, NSDictionary *change) {
        self.hidden = self->originalView.hidden;
    }];
}

- (void)initBorder {
    CAShapeLayer *layer = self.layer;
    CALayer *originalLayer = originalView.layer;
    layer.fillColor = nil;
    layer.strokeColor = originalLayer.borderColor;
    layer.lineWidth = originalLayer.borderWidth;
    layer.lineDashPattern = @[ @4.0f, @6.0f ];
    layer.lineJoin = kCGLineJoinMiter;
}

- (void)setPath {
    originalViewBoundsInMyCoordinateSystem = [originalView convertRect:originalView.bounds toView:self];
    CGFloat inset = self.layer.lineWidth * 0.5f;
    CGPathRef path = CGPathCreateWithRect(CGRectInset(originalViewBoundsInMyCoordinateSystem, inset, inset), NULL);
    self.layer.path = path;
    CGPathRelease(path);
}

@end
