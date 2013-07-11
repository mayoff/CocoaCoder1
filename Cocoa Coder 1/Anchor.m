
#import "Anchor.h"

@implementation Anchor

// My entire API must be implemented by subclasses.

- (CGPoint)pointInView:(UIView *)view {
    [self doesNotRecognizeSelector:_cmd]; abort();
}

@end
