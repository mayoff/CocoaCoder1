/*
Created by Rob Mayoff on 7/6/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

/*
Implementation notes

I use a UIScrollView for its internal scrolling.  Every time the scroll view scrolls, I recenter it.  I accumulate the “dial position” in points by looking at the scroll view's content offset before recentering it.  I convert the dial position to the value of the public API by dividing it by pointsPerUnit.
*/

#import "DialView.h"
@import QuartzCore;

static CGFloat const kScrollWidth = 4096.0f;
static CGFloat const kScrollZero = kScrollWidth / 2;

@interface DialView () <UIScrollViewDelegate>
@end

@implementation DialView {
    UIScrollView *scrollView;
    double dialPosition;
    NSMutableArray *tickLayersInUse;
    NSMutableArray *spareTickLayers;

    // These variables are calculated and used only during tick layout.
    CGRect myBounds;
    double xOffset;
    CGFloat myXCenter;
    double pointsPerTick;
}

#pragma mark - Public API

@synthesize label = _label;

- (float)value {
    return dialPosition / self.pointsPerUnit;
}

- (void)setValue:(float)value {
    dialPosition = value * self.pointsPerUnit;
    [self setNeedsLayout];
}

@synthesize pointsPerUnit = _pointsPerUnit;

- (void)setPointsPerUnit:(CGFloat)pointsPerUnit {
    _pointsPerUnit = pointsPerUnit;
    [self setNeedsLayout];
}

@synthesize unitsPerTick = _unitsPerTick;

- (void)setUnitsPerTick:(float)unitsPerTick {
    if (unitsPerTick == 0)
        return;
    _unitsPerTick = unitsPerTick;
    [self setNeedsLayout];
}

#pragma mark - UIView overrides

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

#pragma mark - NSObject overrides

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    return self;
}


- (void)setAutoresizesSubviews:(BOOL)autoresizesSubviews {
    super.autoresizesSubviews = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateUserInterface];
}

#pragma mark - UIScrollViewDelegate protocol

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGFloat offset = scrollView.contentOffset.x - kScrollZero;
    if (offset != 0) {
        [self updateDialPositionWithOffset:offset];
        [self updateUserInterface];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self recenterScrollView];
    }
}

#pragma mark - Implementation details

- (void)commonInit {
    self.autoresizesSubviews = YES;
    self.clipsToBounds = YES;
    self.pointsPerUnit = 10;
    self.formatString = @"%.0f";
    self.unitsPerTick = 5;
    self.tickHeight = 8;
    self.tickColor = [UIColor lightGrayColor];
    [self initScrollView];
    [self initLabel];
}

- (void)initScrollView {
    scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(kScrollWidth, 1);
    scrollView.contentOffset = CGPointMake(kScrollZero, 0);
    [self addSubview:scrollView];
}

- (void)initLabel {
    _label = [[UILabel alloc] initWithFrame:self.bounds];
    _label.backgroundColor = [UIColor clearColor];
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

- (void)updateUserInterface {
    [self updateLabel];
    [self updateTicks];
}

- (void)updateLabel {
    _label.text = [NSString stringWithFormat:self.formatString, self.value];
}

- (void)updateDialPositionWithOffset:(CGFloat)offset {
        [self willChangeValueForKey:@"value"];
        dialPosition += offset;
        [self didChangeValueForKey:@"value"];
}

- (void)recenterScrollView {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Doing this immediately inside scrollViewDidScroll: doesn't seem to work, but doing it this way does.
        scrollView.contentOffset = CGPointMake(kScrollZero, 0);
    });
}

- (void)updateTicks {
    [self updateTickViewParameters];

    [CATransaction begin]; {
        [CATransaction setDisableActions:YES];

        NSMutableArray *reusableTickLayers = tickLayersInUse;
        tickLayersInUse = [NSMutableArray array];
        [self forEachVisibleTick:^ (int32_t tickIndex) {
            CALayer *tickLayer = [self tickLayerWithReusableTickLayers:reusableTickLayers];
            [self setFrameOfTickLayer:tickLayer forTickIndex:tickIndex];
        }];

        if (reusableTickLayers.count > 0) {
            if (!spareTickLayers) {
                spareTickLayers = [NSMutableArray array];
            }
            for (CALayer *layer in reusableTickLayers) {
                [layer removeFromSuperlayer];
                [spareTickLayers addObject:layer];
            }
        }

    } [CATransaction commit];
}

- (void)updateTickViewParameters {
    pointsPerTick = (double)self.pointsPerUnit * self.unitsPerTick; // Use double to reduce rounding errors
    myBounds = self.bounds;
    xOffset = dialPosition - CGRectGetMidX(myBounds);
}

- (void)forEachVisibleTick:(void (^)(int32_t tickIndex))block {
    int32_t leftTickIndex = floor((CGRectGetMinX(myBounds) + xOffset) / pointsPerTick);
    int32_t rightTickIndex = ceil((CGRectGetMaxX(myBounds) + xOffset) / pointsPerTick);
    for (int32_t tickIndex = leftTickIndex; tickIndex <= rightTickIndex; ++tickIndex) {
        block(tickIndex);
    }
}

- (CALayer *)tickLayerWithReusableTickLayers:(NSMutableArray *)reusableTickLayers {
    CALayer *tickLayer = [reusableTickLayers firstObject];
    if (tickLayer) {
        [reusableTickLayers removeObjectAtIndex:0];
    } else {
        tickLayer = [spareTickLayers firstObject];
        if (tickLayer) {
            [spareTickLayers removeObjectAtIndex:0];
        } else {
            tickLayer = [CALayer layer];
            tickLayer.backgroundColor = self.tickColor.CGColor;
        }
        [self.layer insertSublayer:tickLayer atIndex:0];
    }

    [tickLayersInUse addObject:tickLayer];
    return tickLayer;
}

- (void)setFrameOfTickLayer:(CALayer *)tickLayer forTickIndex:(int32_t)tickIndex {
    tickLayer.frame = CGRectMake(tickIndex * pointsPerTick - xOffset - 0.5f, CGRectGetMaxY(myBounds), 1, -self.tickHeight);
}

@end
