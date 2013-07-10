/*
Created by Rob Mayoff on 7/10/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "FloatSetting.h"

@implementation FloatSetting

- (instancetype)initWithName:(NSString *)name calloutView:(UIView *)calloutView {
    if (self = [super init]) {
        _name = [name copy];
        _calloutView = calloutView;
    }
    return self;
}

// Subclasses must implement the accessors for this and make it KVO-compliant.
@dynamic floatValue;

@end
