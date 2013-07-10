
#import <UIKit/UIKit.h>

typedef enum {
    StrutViewAxisHorizontal = 0,
    StrutViewAxisVertical = 1
} StrutViewAxis;

@class BoundsAnchor;

@interface StrutView : UIView

+ (instancetype)strutViewWithName:(NSString *)name fromAnchor:(BoundsAnchor *)anchor0 toAnchor:(BoundsAnchor *)anchor1 measuringAxis:(StrutViewAxis)axis;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) BoundsAnchor *anchor0;
@property (nonatomic, strong, readonly) BoundsAnchor *anchor1;
@property (nonatomic, readonly) StrutViewAxis axis;

@property (nonatomic, readonly) CGFloat signedLength;

@end
