/*
Created by Rob Mayoff on 7/6/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "SettingCell.h"

@interface SettingCell (SubclassingHooks)

/** I send myself this when I am being deallocated or am going to change my `setting`.  When I call this, `setting` still has its old value. */
- (void)disconnect;

/** I send myself this after I change my `setting`. */
- (void)connect;

@end

