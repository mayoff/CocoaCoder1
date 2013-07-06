/*
Created by Rob Mayoff on 7/6/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "Setting.h"

@implementation Setting

- (instancetype)initWithName:(NSString *)name strutView:(StrutView *)strutView {
    if (!(self = [super init]))
        return nil;

    _name = [name copy];
    _strutView = strutView;

    return self;
}

@end
