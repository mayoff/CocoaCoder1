
#import "StrutSetting.h"
#import "StrutSettingCell.h"

@implementation StrutSetting

- (instancetype)initWithName:(NSString *)name strutView:(StrutView *)strutView {
    if (!(self = [super init]))
        return nil;

    _name = [name copy];
    _strutView = strutView;

    return self;
}

- (NSString *)cellReuseIdentifier {
    return @"StrutSetting";
}

- (Class)cellClass {
    return [StrutSettingCell class];
}

@end
