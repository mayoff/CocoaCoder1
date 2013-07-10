
#import <Foundation/Foundation.h>
#import "FloatSetting.h"
#import "StrutView.h"

@interface StrutSetting : FloatSetting

- (instancetype)initWithName:(NSString *)name strutView:(StrutView *)strutView setLengthBlock:(void (^)(CGFloat length))block;

@property (nonatomic, strong, readonly) StrutView *calloutView;

@property (nonatomic, copy, readonly) void (^setLength)(CGFloat length);

@end
