
#import <UIKit/UIKit.h>

@class Setting;

@interface SettingCell : UITableViewCell

+ (CGFloat)heightForSetting:(Setting *)setting;

@property (nonatomic, strong) Setting *setting;

@end
