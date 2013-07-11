/*
Created by Rob Mayoff on 7/9/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "AxisView.h"
#import "NSObject+Rob_BlockKVO.h"
#import "RobGeometry.h"

@interface AxisView ()

@property (nonatomic, strong) UIView *observedView;

- (CGRect)frameForConvertedOrigin:(CGPoint)point;

@end

@interface XAxisView : AxisView

@end

@interface YAxisView : AxisView

@end

@implementation AxisView

#pragma mark - Public API

+ (instancetype)xAxisViewObservingView:(UIView *)view {
    return [[XAxisView alloc] initWithObservedView:view];
}

+ (instancetype)yAxisViewObservingView:(UIView *)view {
    return [[YAxisView alloc] initWithObservedView:view];
}

// Subclasses must implement this.
@dynamic axisOffset;

- (void)layoutSelf {
    CGPoint origin = [self.observedView convertPoint:CGPointZero toView:self.superview];
    self.frame = [self frameForConvertedOrigin:origin];
}

#pragma mark - Subclass API

- (CGRect)frameForConvertedOrigin:(CGPoint)point {
    [self doesNotRecognizeSelector:_cmd]; abort();
}

#pragma mark - Implementation details

- (instancetype)initWithObservedView:(UIView *)view {
    if (self = [super init]) {
        self.observedView = view;
        self.backgroundColor = [UIColor colorWithRed:1 green:124.0f/255 blue:247.0f/255 alpha:1];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}

+ (NSSet *)keyPathsForValuesAffectingValueForAxisOffset {
    // I update my frame in `layoutSelf`, so I don't need to mention center or bounds.
    return [NSSet setWithObject:@"frame"];
}

@end

@implementation XAxisView

- (CGRect)frameForConvertedOrigin:(CGPoint)point {
    CGRect frame = self.superview.frame;
    frame.origin.y = point.y;
    frame.size.height = 2;
    return frame;
}

- (CGFloat)axisOffset {
    return self.observedView.bounds.origin.y;
}

- (void)setAxisOffset:(CGFloat)axisOffset {
    self.observedView.bounds = rectByReplacingY(self.observedView.bounds, axisOffset);
}

@end

@implementation YAxisView

- (CGRect)frameForConvertedOrigin:(CGPoint)point {
    CGRect frame = self.superview.frame;
    frame.origin.x = point.x;
    frame.size.width = 2;
    return frame;
}

- (CGFloat)axisOffset {
    return self.observedView.bounds.origin.x;
}

- (void)setAxisOffset:(CGFloat)axisOffset {
    self.observedView.bounds = rectByReplacingX(self.observedView.bounds, axisOffset);
}

@end
