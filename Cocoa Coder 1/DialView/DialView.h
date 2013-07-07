/*
Created by Rob Mayoff on 7/6/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import <UIKit/UIKit.h>

@interface DialView : UIControl

/** One unit of value is this wide on the dial. The default is 10. */
@property (nonatomic) CGFloat pointsPerUnit;

/** The value I am currently displaying. */
@property (nonatomic) float value;

/** I draw tick marks for values that are integer multiples of `unitsPerTick`. The default is 5. */
@property (nonatomic) float unitsPerTick;

/** This is the height of each tick in points. The default is 8. */
@property (nonatomic) CGFloat tickHeight;

/** This is the color of each tick.  The default is light gray. */
@property (nonatomic, strong) UIColor *tickColor;

/** The label I use to display the current value.  You can set the display properties such as font and color. */
@property (nonatomic, strong, readonly) UILabel *label;

/** The format string I use to display my current value in `label`.  This needs exactly one `%f` format specifier. The default is `%.0f`. */
@property (nonatomic, copy) NSString *formatString;

@end
