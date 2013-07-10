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

@property (nonatomic) float floatValue;

@end
