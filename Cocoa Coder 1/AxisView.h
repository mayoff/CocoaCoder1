/*
Created by Rob Mayoff on 7/9/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import <UIKit/UIKit.h>
#import "CalloutView.h"

@interface AxisView : CalloutView

+ (instancetype)xAxisViewObservingView:(UIView *)view;
+ (instancetype)yAxisViewObservingView:(UIView *)view;

@property (nonatomic) CGFloat axisOffset;

@end
