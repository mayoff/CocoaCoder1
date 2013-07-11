/*
Created by Rob Mayoff on 7/10/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "CanvasView.h"
#import "CalloutView.h"

@implementation CanvasView {
    UIView *_calloutContainerView;
}

- (UIView *)calloutContainerView {
    if (!_calloutContainerView) {
        _calloutContainerView = [[UIView alloc] initWithFrame:self.bounds];
        _calloutContainerView.translatesAutoresizingMaskIntoConstraints = YES;
        _calloutContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _calloutContainerView.backgroundColor = nil;
        _calloutContainerView.userInteractionEnabled = NO;

        // Ensure callouts are drawn over the demo view hierarchy.
        _calloutContainerView.layer.zPosition = 1;

        [self addSubview:_calloutContainerView];
    }
    return _calloutContainerView;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // Make sure the demo view hierarchy gets laid out before the callouts, since the callouts use the demo view hierarchy layout.
    [self.demoView layoutIfNeeded];
    [self layoutCallouts];
}

- (void)layoutCallouts {
    for (CalloutView *view in _calloutContainerView.subviews) {
        [view layoutSelf];
    }
}

@end
