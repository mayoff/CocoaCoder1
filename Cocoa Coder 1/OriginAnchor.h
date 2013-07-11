/*
Created by Rob Mayoff on 7/10/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "Anchor.h"

@interface OriginAnchor : Anchor

+ (instancetype)anchorObservingView:(UIView *)observedView;

@property (nonatomic, strong, readonly) UIView *observedView;

@end
