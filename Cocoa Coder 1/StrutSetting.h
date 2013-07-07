
#import <Foundation/Foundation.h>
#import "Setting.h"

@class StrutView;

@interface StrutSetting : Setting

- (instancetype)initWithName:(NSString *)name strutView:(StrutView *)strutView setLengthBlock:(void (^)(CGFloat length))block;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic) BOOL shouldShowControls;
@property (nonatomic, strong, readonly) StrutView *strutView;

/** You need to set this to a block that sets the strut length. */
@property (nonatomic, copy) void (^setLength)(CGFloat length);

@end
