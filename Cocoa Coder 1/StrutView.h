
#import <UIKit/UIKit.h>
#import "CalloutView.h"

typedef enum {
    StrutViewAxisHorizontal = 0,
    StrutViewAxisVertical = 1
} StrutViewAxis;

@class Anchor;

@interface StrutView : CalloutView

/** I return a StrutView parallel to the X axis, spanning the X distance from anchor0 to anchor1, along the Y coordinate of yAnchor (which may be the same as either of the other anchors). */
+ (instancetype)horizontalStrutViewWithName:(NSString *)name fromAnchor:(Anchor *)fromAnchor toAnchor:(Anchor *)toAnchor yAnchor:(Anchor *)yAnchor;

/** I return a StrutView parallel to the Y axis, spanning the Y distance from anchor0 to anchor1, along the X coordinate of xAnchor (which may be the same as either of the other anchors). */
+ (instancetype)verticalStrutViewWithName:(NSString *)name fromAnchor:(Anchor *)fromAnchor toAnchor:(Anchor *)toAnchor xAnchor:(Anchor *)xAnchor;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) Anchor *fromXAnchor;
@property (nonatomic, strong, readonly) Anchor *fromYAnchor;
@property (nonatomic, strong, readonly) Anchor *toXAnchor;
@property (nonatomic, strong, readonly) Anchor *toYAnchor;
@property (nonatomic, readonly) StrutViewAxis axis;

@property (nonatomic, readonly) CGFloat signedLength;

@end
