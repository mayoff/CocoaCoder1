
#import "StrutSetting.h"
#import "StrutSettingCell.h"
#import "StrutView.h"

@implementation StrutSetting

#pragma mark - Public API

- (instancetype)initWithName:(NSString *)name strutView:(StrutView *)strutView setLengthBlock:(void (^)(CGFloat))block {
    if (!(self = [super initWithName:name calloutView:strutView]))
        return nil;

    _setLength = [block copy];

    return self;
}

- (NSString *)cellReuseIdentifier {
    return @"StrutSetting";
}

- (Class)cellClass {
    return [StrutSettingCell class];
}

@end
