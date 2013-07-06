/*
Created by Rob Mayoff on 7/6/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "ViewVisibilitySetting.h"
#import "ViewVisibilitySettingCell.h"

@implementation ViewVisibilitySetting

- (NSString *)cellReuseIdentifier {
    return @"ViewVisibilitySetting";
}

- (Class)cellClass {
    return [ViewVisibilitySettingCell class];
}

@end
