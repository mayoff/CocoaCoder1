
#import "DottedLayoutDemoView.h"
@import QuartzCore;

@interface DottedLayoutDemoView ()

@property (nonatomic, readonly) CAShapeLayer *layer;

@end

static char kLayoutContext;
static char kHiddenContext;

@implementation DottedLayoutDemoView {
    UIView *originalView;
    CGRect originalViewBoundsInMyCoordinateSystem;
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

#pragma mark - NSObject overrides

- (void)dealloc {
    [self stopObservingOriginalView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kLayoutContext) {
        [self setNeedsLayout];
    } else if (context == &kHiddenContext) {
        self.hidden = originalView.hidden;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Implementation details

- (void)startObservingOriginalView {
    [originalView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionInitial context:&kLayoutContext];
    [originalView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionInitial context:&kLayoutContext];
    [originalView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionInitial context:&kLayoutContext];
    [originalView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionInitial context:&kHiddenContext];
}

- (void)stopObservingOriginalView {
    [originalView removeObserver:self forKeyPath:@"center" context:&kLayoutContext];
    [originalView removeObserver:self forKeyPath:@"bounds" context:&kLayoutContext];
    [originalView removeObserver:self forKeyPath:@"frame" context:&kLayoutContext];
    [originalView removeObserver:self forKeyPath:@"hidden" context:&kHiddenContext];
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
