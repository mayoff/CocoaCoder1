
#import <Foundation/Foundation.h>
#import "FloatSetting.h"
#import "StrutView.h"

typedef void (^StrutSettingSetLengthBlock)(CGFloat length);

@interface StrutSetting : FloatSetting

- (instancetype)initWithName:(NSString *)name strutView:(StrutView *)strutView setLengthBlock:(StrutSettingSetLengthBlock)block;

@property (nonatomic, strong, readonly) StrutView *calloutView;

@property (nonatomic, copy, readonly) StrutSettingSetLengthBlock setLength;

@end
