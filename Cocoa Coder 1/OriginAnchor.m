/*
Created by Rob Mayoff on 7/10/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "OriginAnchor.h"

@implementation OriginAnchor

#pragma mark - Public API

+ (instancetype)anchorObservingView:(UIView *)observedView {
    return [[self alloc] initWithObservedView:observedView];
}

#pragma mark - Implementation details

- (instancetype)initWithObservedView:(UIView *)observedView {
    if (self = [super init]) {
        _observedView = observedView;
    }
    return self;
}

+ (NSSet *)keyPathsForValuesAffectingPoint {
    return [NSSet setWithArray:@[@"observedView.bounds", @"observedView.center", @"observedView.frame"]];
}

- (CGPoint)pointInView:(UIView *)view {
    return [self.observedView convertPoint:CGPointZero toView:view];
}

@end
