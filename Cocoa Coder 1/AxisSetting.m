/*
Created by Rob Mayoff on 7/10/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "AxisSetting.h"

@implementation AxisSetting

- (float)floatValue {
    return self.calloutView.axisOffset;
}

- (void)setFloatValue:(float)floatValue {
    self.calloutView.axisOffset = floatValue;
}

+ (NSSet *)keyPathsForValuesAffectingFloatValue {
    return [NSSet setWithObject:@"calloutView.axisOffset"];
}

@end
