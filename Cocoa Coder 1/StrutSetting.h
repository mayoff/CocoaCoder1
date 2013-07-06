/*
Created by Rob Mayoff on 7/6/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import <Foundation/Foundation.h>

@class StrutView;

@interface StrutSetting : NSObject

- (instancetype)initWithName:(NSString *)name strutView:(StrutView *)strutView;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic) BOOL shouldShowControls;
@property (nonatomic, strong, readonly) StrutView *strutView;

@end
