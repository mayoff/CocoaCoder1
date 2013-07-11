/*
Created by Rob Mayoff on 7/11/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "RectAnchor.h"

@implementation RectAnchor

+ (instancetype)anchorWithUnitPosition:(CGPoint)position absoluteOffset:(CGPoint)offset inView:(UIView *)view {
    return [[self alloc] initWithUnitPosition:position absoluteOffset:offset inView:view];
}

+ (instancetype)anchorWithUnitPosition:(CGPoint)position inView:(UIView *)view {
    return [[self alloc] initWithUnitPosition:position absoluteOffset:CGPointZero inView:view];
}

- (instancetype)initWithUnitPosition:(CGPoint)position absoluteOffset:(CGPoint)offset inView:(UIView *)view {
    if (self = [super initWithView:view]) {
        _position = position;
        _offset = offset;
    }
    return self;
}

@end
