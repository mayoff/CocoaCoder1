/*
Created by Rob Mayoff on 7/9/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "AxisView.h"

static char kAxisViewContext;

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

#pragma mark - Subclass API

- (CGRect)frameForConvertedOrigin:(CGPoint)point {
    [self doesNotRecognizeSelector:_cmd]; abort();
}

#pragma mark - UIView overrides

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutSelf];
}

#pragma mark - NSObject overrides

- (void)dealloc {
    [self stopObservingView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kAxisViewContext) {
        [self setNeedsLayout];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Implementation details

- (instancetype)initWithObservedView:(UIView *)view {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:1 green:124.0f/255 blue:247.0f/255 alpha:1];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.userInteractionEnabled = NO;

        _observedView = view;
        [self startObservingView];
    }
    return self;
}

- (void)startObservingView {
    [self.observedView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionInitial context:&kAxisViewContext];
    [self.observedView addObserver:self forKeyPath:@"center" options:0 context:&kAxisViewContext];
    [self.observedView addObserver:self forKeyPath:@"frame" options:0 context:&kAxisViewContext];
}

- (void)stopObservingView {
    [self.observedView removeObserver:self forKeyPath:@"bounds" context:&kAxisViewContext];
    [self.observedView removeObserver:self forKeyPath:@"center" context:&kAxisViewContext];
    [self.observedView removeObserver:self forKeyPath:@"frame" context:&kAxisViewContext];
}

- (void)layoutSelf {
    CGPoint origin = [self.observedView convertPoint:CGPointZero toView:self.superview];
    self.frame = [self frameForConvertedOrigin:origin];
}

@end

@implementation XAxisView

- (CGRect)frameForConvertedOrigin:(CGPoint)point {
    CGRect frame = self.superview.frame;
    frame.origin.y = point.y;
    frame.size.height = 2;
    return frame;
}

@end

@implementation YAxisView

- (CGRect)frameForConvertedOrigin:(CGPoint)point {
    CGRect frame = self.superview.frame;
    frame.origin.x = point.x;
    frame.size.width = 2;
    return frame;
}

@end
