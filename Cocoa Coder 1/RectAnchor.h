/*
Created by Rob Mayoff on 7/11/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "Anchor.h"

/** A RectAnchor tracks a relative position in some rectangle associated with a view.  The position is defined in unit coordinates: 0 means the minimum coordinate of the rectangle and 1 means the maximum coordinate of the rectangle.  The exact definition of the rectangle is the responsibility of my subclasses. */

@interface RectAnchor : Anchor

+ (instancetype)anchorWithUnitPosition:(CGPoint)position inView:(UIView *)view;
+ (instancetype)anchorWithUnitPosition:(CGPoint)position absoluteOffset:(CGPoint)offset inView:(UIView *)view;

@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) CGPoint offset;

@end
