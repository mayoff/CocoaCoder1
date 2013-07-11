
#import "DottedLayoutDemoView.h"
#import "NSObject+Rob_BlockKVO.h"
@import QuartzCore;

@interface DottedLayoutDemoView ()

@property (nonatomic, readonly) CAShapeLayer *layer;

@end

@implementation DottedLayoutDemoView {
    UIView *originalView;
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

- (void)layoutSelf {
    [self setFrameFromOriginalView];
    [self setPath];
}

#pragma mark - UIView overrides

+ (Class)layerClass {
    return [CAShapeLayer class];
}

#pragma mark - Implementation details

- (void)initBorder {
    CAShapeLayer *layer = self.layer;
    CALayer *originalLayer = originalView.layer;
    layer.fillColor = nil;
    layer.strokeColor = originalLayer.borderColor;
    layer.lineWidth = originalLayer.borderWidth;
    layer.lineDashPattern = @[ @4.0f, @6.0f ];
    layer.lineJoin = kCGLineJoinMiter;
}

- (void)startObservingOriginalView {
    hiddenObserver = [originalView addObserverForKeyPath:@"hidden" options:NSKeyValueObservingOptionInitial selfReference:self block:^(DottedLayoutDemoView *self, NSString *observedKeyPath, id observedObject, NSDictionary *change) {
        self.hidden = self->originalView.hidden;
    }];
}

- (void)setFrameFromOriginalView {
    self.frame = [originalView convertRect:originalView.bounds toView:self.superview];
}

- (void)setPath {
    CGRect bounds = self.bounds;
    CGFloat inset = self.layer.lineWidth * 0.5f;
    CGPathRef path = CGPathCreateWithRect(CGRectInset(bounds, inset, inset), NULL);
    self.layer.path = path;
    CGPathRelease(path);
}

@end
