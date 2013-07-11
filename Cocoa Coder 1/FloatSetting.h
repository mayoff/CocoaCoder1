/*
Created by Rob Mayoff on 7/10/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "Setting.h"

@interface FloatSetting : Setting

- (instancetype)initWithName:(NSString *)name calloutView:(UIView *)calloutView;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic) BOOL shouldShowControls;
@property (nonatomic, strong, readonly) UIView *calloutView;

/** Views in `otherCalloutViews` are to be hidden and shown when `calloutView` is hidden or shown, although doing so is up to you. */
@property (nonatomic, copy) NSSet *otherCalloutViews;

@property (nonatomic) float floatValue;

@end
