
#import "StrutSetting.h"
#import "StrutSettingCell.h"

@implementation StrutSetting

- (instancetype)initWithName:(NSString *)name strutView:(StrutView *)strutView setLengthBlock:(void (^)(CGFloat))block {
    if (!(self = [super init]))
        return nil;

    _name = [name copy];
    _strutView = strutView;
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
