/*
Created by Rob Mayoff on 7/5/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import <Foundation/Foundation.h>

@interface Anchor : NSObject

+ (instancetype)anchorWithXView:(UIView *)xView xPosition:(CGFloat)xPosition yView:(UIView *)yView position:(CGFloat)yPosition;

@property (nonatomic, strong, readonly) UIView *xView;
@property (nonatomic, readonly) CGFloat xPosition;
@property (nonatomic, strong, readonly) UIView *yView;
@property (nonatomic, readonly) CGFloat yPosition;

- (CGPoint)pointInView:(UIView *)view;

@end
