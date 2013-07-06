/*
Created by Rob Mayoff on 7/5/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import <UIKit/UIKit.h>

@class Anchor;

@interface StrutView : UIView

+ (instancetype)strutViewFromAnchor:(Anchor *)anchor0 toAnchor:(Anchor *)anchor1;

@property (nonatomic, strong, readonly) Anchor *anchor0;
@property (nonatomic, strong, readonly) Anchor *anchor1;

@end
