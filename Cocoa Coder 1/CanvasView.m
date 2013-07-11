/*
Created by Rob Mayoff on 7/10/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "CanvasView.h"
#import "CalloutView.h"
#import "DottedLayoutDemoView.h"

static CGFloat const ZPosition_Dotted = 0;
static CGFloat const ZPosition_Demo = 1;
static CGFloat const ZPosition_Callout = 2;

@implementation CanvasView {
    UIView *_dottedContainerView;
    UIView *_calloutContainerView;
}

- (void)setDemoContainerView:(UIView *)demoContainerView {
    _demoContainerView = demoContainerView;
    _demoContainerView.layer.zPosition = ZPosition_Demo;
}

- (UIView *)calloutContainerView {
    if (!_calloutContainerView) {
        _calloutContainerView = [[UIView alloc] initWithFrame:self.bounds];
        _calloutContainerView.translatesAutoresizingMaskIntoConstraints = YES;
        _calloutContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _calloutContainerView.backgroundColor = nil;
        _calloutContainerView.userInteractionEnabled = NO;

        _calloutContainerView.layer.zPosition = ZPosition_Callout;

        [self addSubview:_calloutContainerView];
    }
    return _calloutContainerView;
}

- (UIView *)dottedContainerView {
    if (!_dottedContainerView) {
        _dottedContainerView = [[UIView alloc] initWithFrame:self.bounds];
        _dottedContainerView.translatesAutoresizingMaskIntoConstraints = YES;
        _dottedContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _dottedContainerView.backgroundColor = nil;
        _dottedContainerView.userInteractionEnabled = NO;

        _dottedContainerView.layer.zPosition = ZPosition_Dotted;

        [self addSubview:_dottedContainerView];
    }
    return _dottedContainerView;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // Make sure the demo view hierarchy gets laid out before the callouts, since the callouts and dotted views use the demo view hierarchy layout.
    [self.demoContainerView layoutIfNeeded];
    [self layoutDottedViews];
    [self layoutCallouts];
}

- (void)layoutDottedViews {
    for (DottedLayoutDemoView *view in _dottedContainerView.subviews) {
        [view layoutSelf];
    }
}

- (void)layoutCallouts {
    for (CalloutView *view in _calloutContainerView.subviews) {
        [view layoutSelf];
    }
}

@end
