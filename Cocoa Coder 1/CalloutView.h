/*
Created by Rob Mayoff on 7/10/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import <UIKit/UIKit.h>

/** CalloutView is the superclass of strut and axis views.  A CalloutView knows how to lay itself out based on the layout of the views it is tracking. */

@interface CalloutView : UIView

- (void)layoutSelf;

@end
