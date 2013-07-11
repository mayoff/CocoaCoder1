/*
Created by Rob Mayoff on 7/11/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "FrameAnchor.h"

@implementation FrameAnchor

- (CGPoint)pointInView:(UIView *)targetView {
    UIView *view = self.view;
    CGRect frame = view.frame;
    CGPoint position = self.position;
    CGPoint offset = self.offset;
    CGPoint point = CGPointMake(frame.origin.x + position.x * frame.size.width + offset.x, frame.origin.y + position.y * frame.size.height + offset.y);
    return [view.superview convertPoint:point toView:targetView];
}

@end
