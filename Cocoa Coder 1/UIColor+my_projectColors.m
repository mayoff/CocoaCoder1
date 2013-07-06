/*
Created by Rob Mayoff on 7/5/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "UIColor+my_projectColors.h"

@implementation UIColor (my_projectColors)

- (UIColor *)my_borderColor {
    CGFloat hue, saturation, brightness, alpha;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    brightness = (1.0f + brightness) * 0.5f;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

@end
