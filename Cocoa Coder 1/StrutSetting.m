
#import "StrutSetting.h"
#import "StrutView.h"

@implementation StrutSetting

- (instancetype)initWithName:(NSString *)name strutView:(StrutView *)strutView setLengthBlock:(StrutSettingSetLengthBlock)block {
    if (!(self = [super initWithName:name calloutView:strutView]))
        return nil;

    _setLength = [block copy];

    return self;
}

- (float)floatValue {
    return self.calloutView.signedLength;
}

- (void)setFloatValue:(float)floatValue {
    self.setLength(floatValue);
}

+ (NSSet *)keyPathsForValuesAffectingFloatValue {
    return [NSSet setWithObject:@"calloutView.signedLength"];
}

@end
