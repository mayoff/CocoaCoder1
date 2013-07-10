
#import "StrutSetting.h"
#import "StrutView.h"
#import "NSObject+Rob_BlockKVO.h"

@implementation StrutSetting {
    CGFloat priorSignedLength;
    id signedLengthObserver;
}

#pragma mark - Public API

- (instancetype)initWithName:(NSString *)name strutView:(StrutView *)strutView setLengthBlock:(void (^)(CGFloat))block {
    if (!(self = [super initWithName:name calloutView:strutView]))
        return nil;

    _setLength = [block copy];
    signedLengthObserver = [strutView addObserverForKeyPath:@"signedLength" options:0 selfReference:self block:^(id self, NSString *observedKeyPath, id observedObject, NSDictionary *change) {
        [self willChangeValueForKey:@"floatValue"];
        [self didChangeValueForKey:@"floatValue"];
    }];

    return self;
}

- (float)floatValue {
    return self.calloutView.signedLength;
}

- (void)setFloatValue:(float)floatValue {
    self.setLength(floatValue);
}

@end
