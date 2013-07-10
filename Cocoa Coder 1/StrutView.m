
#import "StrutView.h"
#import "Anchor.h"
#import "RobGeometry.h"
#import "NSObject+Rob_BlockKVO.h"
@import QuartzCore;

@interface StrutView ()

@property (nonatomic, readonly) CAShapeLayer *layer;
@property (nonatomic, readwrite) CGFloat signedLength;

@end

@implementation StrutView {
    double dx;
    double dy;
    double length;
    CGFloat thickness;
    UILabel *nameLabel;
    id anchor0Observer;
    id anchor1Observer;
}

#pragma mark - Public API

+ (instancetype)strutViewWithName:(NSString *)name fromAnchor:(Anchor *)anchor0 toAnchor:(Anchor *)anchor1 measuringAxis:(StrutViewAxis)axis {
    return [[self alloc] initWithName:(NSString *)name fromAnchor:anchor0 toAnchor:anchor1 measuringAxis:axis withThickness:2];
}

- (instancetype)initWithName:(NSString *)name fromAnchor:(Anchor *)anchor0 toAnchor:(Anchor *)anchor1 measuringAxis:(StrutViewAxis)axis withThickness:(CGFloat)myThickness {
    if (self = [super init]) {
        _name = [name copy];
        _anchor0 = anchor0;
        _anchor1 = anchor1;
        _axis = axis;
        thickness = myThickness;
        self.autoresizesSubviews = NO;
        [self initShapeLayer];
        [self initNameLabel];
        anchor0Observer = [self observerForAnchor:_anchor0];
        anchor1Observer = [self observerForAnchor:_anchor1];
        self.userInteractionEnabled = NO;
    }
    return self;
}

#pragma mark - UIView overrides

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(3 * thickness, UIViewNoIntrinsicMetric);
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self updateParameters];
    [self setCenterWithCurrentParameters];
    [self setBoundsWithCurrentParameters];
    [self setTransformWithCurrentParameters];
    [self setPathWithCurrentParameters];
    [self layoutNameLabel];
}

#pragma mark - Implementation details

- (void)initShapeLayer {
    CAShapeLayer *layer = self.layer;
    layer.anchorPoint = CGPointMake(0, 0.5f);
    layer.strokeColor = nil;
    layer.fillColor = [UIColor yellowColor].CGColor;
    self.backgroundColor = nil;
}

- (void)initNameLabel {
    nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    nameLabel.text = self.name;
    nameLabel.numberOfLines = 1;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor colorWithCGColor:self.layer.fillColor];
    nameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    nameLabel.layer.cornerRadius = 2 * thickness;
    [self addSubview:nameLabel];
}

- (void)updateParameters {
    CGPoint p0 = [self.anchor0 pointInView:self.superview];
    CGPoint p1 = [self.anchor1 pointInView:self.superview];
    dx = p1.x - p0.x;
    dy = p1.y - p0.y;
    length = hypot(dx, dy);
    self.signedLength = _axis == StrutViewAxisHorizontal ? dx : dy;
}

- (void)setCenterWithCurrentParameters {
    self.center = [self.anchor0 pointInView:self.superview];
}

- (void)setBoundsWithCurrentParameters {
    self.bounds = CGRectMake(0, -1.5f * thickness, length, 3 * thickness);
}

- (void)setTransformWithCurrentParameters {
    CGFloat c = dx / length;
    CGFloat s = dy / length;
    self.transform = CGAffineTransformMake(c, s, -s, c, 0, 0);
}

- (void)setPathWithCurrentParameters {
    CGFloat x0 = 0;
    CGFloat x3 = length;
    CGFloat x1 = MIN(x0 + thickness, x3);
    CGFloat x2 = MAX(x0, x3 - thickness);

    CGFloat y0 = -1.5f * thickness;
    CGFloat y1 = -0.5f * thickness;
    CGFloat y2 = -y1;
    CGFloat y3 = -y0;

    static size_t const kPointCount = 12;
    CGPoint points[kPointCount] = {
        { x0, y0 },
        { x1, y0 },
        { x1, y1 },
        { x2, y1 },
        { x2, y0 },
        { x3, y0 },
        { x3, y3 },
        { x2, y3 },
        { x2, y2 },
        { x1, y2 },
        { x1, y3 },
        { x0, y3 },
    };

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddLines(path, NULL, points, kPointCount);
    CGPathCloseSubpath(path);
    self.layer.path = path;
    CGPathRelease(path);
}

- (id)observerForAnchor:(Anchor *)anchor {
    return [anchor addObserverForKeyPath:@"point" options:NSKeyValueObservingOptionInitial selfReference:self block:^(StrutView *self, NSString *observedKeyPath, id observedObject, NSDictionary *change) {
        [self setNeedsLayout];
    }];
}

- (void)layoutNameLabel {
    CGRect myBounds = self.bounds;
    CGRect labelBounds = CGRectInset((CGRect){ CGPointZero, nameLabel.intrinsicContentSize }, -thickness, -0.5f * thickness);
    if (labelBounds.size.width + 4 * thickness > myBounds.size.width) {
        nameLabel.hidden = YES;
    } else {
        nameLabel.hidden = NO;
        nameLabel.center = pointOffset(rectMidpoint(self.bounds), 0, 0.5f * labelBounds.size.height + 2 * thickness);
        nameLabel.bounds = labelBounds;
        nameLabel.frame = CGRectIntegral(nameLabel.frame);
    }
}

@end
