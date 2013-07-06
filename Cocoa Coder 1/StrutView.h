
#import <UIKit/UIKit.h>

@class Anchor;

@interface StrutView : UIView

+ (instancetype)strutViewFromAnchor:(Anchor *)anchor0 toAnchor:(Anchor *)anchor1;

@property (nonatomic, strong, readonly) Anchor *anchor0;
@property (nonatomic, strong, readonly) Anchor *anchor1;

@end
