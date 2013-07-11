
#import "StrutView.h"
#import "Anchor.h"
#import "RobGeometry.h"
#import "NSObject+Rob_BlockKVO.h"
@import QuartzCore;

@interface StrutView ()

@property (nonatomic, readonly) CAShapeLayer *layer;
@property (nonatomic, readwrite) CGFloat signedLength;

@end

static CGFloat const kThickness = 2;

@implementation StrutView {
    CGPoint fromPoint;
    CGPoint toPoint;
    double dx;
    double dy;
    double length;
    UILabel *nameLabel;
    NSMutableArray *anchorObservers;
    id anchor0Observer;
    id anchor1Observer;
}

#pragma mark - Public API

+ (instancetype)horizontalStrutViewWithName:(NSString *)name fromAnchor:(Anchor *)fromAnchor toAnchor:(Anchor *)toAnchor yAnchor:(Anchor *)yAnchor {
    return [[self alloc] initWithName:name fromXAnchor:fromAnchor yAnchor:yAnchor toXAnchor:toAnchor yAnchor:yAnchor measuringAxis:StrutViewAxisHorizontal];
}

+ (instancetype)verticalStrutViewWithName:(NSString *)name fromAnchor:(Anchor *)fromAnchor toAnchor:(Anchor *)toAnchor xAnchor:(Anchor *)xAnchor {
    return [[self alloc] initWithName:name fromXAnchor:xAnchor yAnchor:fromAnchor toXAnchor:xAnchor yAnchor:toAnchor measuringAxis:StrutViewAxisVertical];
}

- (instancetype)initWithName:(NSString *)name fromXAnchor:(Anchor *)fromXAnchor yAnchor:(Anchor *)fromYAnchor toXAnchor:(Anchor *)toXAnchor yAnchor:(Anchor *)toYAnchor measuringAxis:(StrutViewAxis)axis {
    if (self = [super init]) {
        _name = [name copy];
        _fromXAnchor = fromXAnchor;
        _fromYAnchor = fromYAnchor;
        _toXAnchor = toXAnchor;
        _toYAnchor = toYAnchor;
        _axis = axis;

        self.autoresizesSubviews = NO;
        self.userInteractionEnabled = NO;
        [self initShapeLayer];
        [self initNameLabel];

        anchorObservers = [NSMutableArray array];
        for (Anchor *anchor in [NSSet setWithArray:@[_fromXAnchor, _fromYAnchor, _toXAnchor, _toYAnchor]]) {
            [anchorObservers addObject:[self observerForAnchor:anchor]];
        }
    }
    return self;
}

#pragma mark - UIView overrides

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(3 * kThickness, UIViewNoIntrinsicMetric);
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
    nameLabel.layer.cornerRadius = 2 * kThickness;
    [self addSubview:nameLabel];
}

- (CGPoint)uncachedFromPoint {
    return CGPointMake([self.fromXAnchor pointInView:self.superview].x, [self.fromYAnchor pointInView:self.superview].y);
}

- (CGPoint)uncachedToPoint {
    return CGPointMake([self.toXAnchor pointInView:self.superview].x, [self.toYAnchor pointInView:self.superview].y);
}

- (void)updateParameters {
    fromPoint = [self uncachedFromPoint];
    toPoint = [self uncachedToPoint];
    dx = toPoint.x - fromPoint.x;
    dy = toPoint.y - fromPoint.y;
    length = hypot(dx, dy);
    self.signedLength = _axis == StrutViewAxisHorizontal ? dx : dy;
}

- (void)setCenterWithCurrentParameters {
    self.center = fromPoint;
}

- (void)setBoundsWithCurrentParameters {
    self.bounds = CGRectMake(0, -1.5f * kThickness, length, 3 * kThickness);
}

- (void)setTransformWithCurrentParameters {
    CGFloat c = dx / length;
    CGFloat s = dy / length;
    self.transform = CGAffineTransformMake(c, s, -s, c, 0, 0);
}

- (void)setPathWithCurrentParameters {
    CGFloat x0 = 0;
    CGFloat x3 = length;
    CGFloat x1 = MIN(x0 + kThickness, x3);
    CGFloat x2 = MAX(x0, x3 - kThickness);

    CGFloat y0 = -1.5f * kThickness;
    CGFloat y1 = -0.5f * kThickness;
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
    CGRect labelBounds = CGRectInset((CGRect){ CGPointZero, nameLabel.intrinsicContentSize }, -kThickness, -0.5f * kThickness);
    if (labelBounds.size.width + 4 * kThickness > myBounds.size.width) {
        nameLabel.hidden = YES;
    } else {
        nameLabel.hidden = NO;
        nameLabel.center = pointOffset(rectMidpoint(self.bounds), 0, 0.5f * labelBounds.size.height + 2 * kThickness);
        nameLabel.bounds = labelBounds;
        nameLabel.frame = CGRectIntegral(nameLabel.frame);
    }
}

@end
