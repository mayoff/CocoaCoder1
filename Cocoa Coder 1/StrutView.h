
#import <UIKit/UIKit.h>

typedef enum {
    StrutViewAxisHorizontal = 0,
    StrutViewAxisVertical = 1
} StrutViewAxis;

@class Anchor;

@interface StrutView : UIView

+ (instancetype)strutViewFromAnchor:(Anchor *)anchor0 toAnchor:(Anchor *)anchor1 measuringAxis:(StrutViewAxis)axis;

@property (nonatomic, strong, readonly) Anchor *anchor0;
@property (nonatomic, strong, readonly) Anchor *anchor1;
@property (nonatomic, readonly) StrutViewAxis axis;

@property (nonatomic, readonly) CGFloat signedLength;

@end
