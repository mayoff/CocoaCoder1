
#import <Foundation/Foundation.h>

@interface Anchor : NSObject

+ (instancetype)anchorWithXView:(UIView *)xView position:(CGFloat)xPosition yView:(UIView *)yView position:(CGFloat)yPosition;
+ (instancetype)anchorWithXView:(UIView *)xView position:(CGFloat)xPosition offset:(CGFloat)xOffset yView:(UIView *)yView position:(CGFloat)yPosition offset:(CGFloat)yOffset;

@property (nonatomic, strong, readonly) UIView *xView;
@property (nonatomic, readonly) CGFloat xPosition;
@property (nonatomic, readonly) CGFloat xOffset;
@property (nonatomic, strong, readonly) UIView *yView;
@property (nonatomic, readonly) CGFloat yPosition;
@property (nonatomic, readonly) CGFloat yOffset;

- (CGPoint)pointInView:(UIView *)view;

@end
