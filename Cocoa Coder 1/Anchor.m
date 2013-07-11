
#import "Anchor.h"

@implementation Anchor

#pragma mark - NSObject overrides

- (instancetype)initWithView:(UIView *)view {
    if ((self = [super init])) {
        _view = view;
    }
    return self;
}

- (CGPoint)pointInView:(UIView *)view {
    [self doesNotRecognizeSelector:_cmd]; abort();
}

@end
