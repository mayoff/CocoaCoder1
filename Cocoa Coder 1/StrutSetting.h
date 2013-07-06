
#import <Foundation/Foundation.h>
#import "Setting.h"

@class StrutView;

@interface StrutSetting : Setting

- (instancetype)initWithName:(NSString *)name strutView:(StrutView *)strutView;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic) BOOL shouldShowControls;
@property (nonatomic, strong, readonly) StrutView *strutView;

@end
