
#import <UIKit/UIKit.h>
#import "SettingCell.h"

@interface StrutSettingCell : SettingCell

/** I call this to set the value based on a user action. */
@property (nonatomic, copy) void (^setValue)(CGFloat value);

@end
