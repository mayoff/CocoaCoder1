/*
Created by Rob Mayoff on 7/6/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "SettingCell.h"
#import "SettingCell+SubclassHooks.h"

@implementation SettingCell

+ (CGFloat)heightForSetting:(Setting *)setting {
    [self doesNotRecognizeSelector:_cmd];
    abort();
}

- (void)dealloc {
    if (_setting) {
        [self disconnect];
    }
}

- (void)setSetting:(Setting *)setting {
    if (setting != _setting) {
        if (_setting) {
            [self disconnect];
        }
        _setting = setting;
        if (_setting) {
            [self connect];
        }
    }
}

- (void)disconnect { }

- (void)connect { }

@end
