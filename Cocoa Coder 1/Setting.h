
#import <Foundation/Foundation.h>

@interface Setting : NSObject

/** I return the cell reuse identifier to use with the table view of `ControlPanelViewController`.  Each subclass must override this to return the identifier corresponding to its prototype cell in the storyboard.
*/
- (NSString *)cellReuseIdentifier;

/** I return the class of cell to use with the table view of `ControlPanelViewController`.  Each subclass must override this to return the class corresponding to its prototype cell in the storyboard.
*/
- (Class)cellClass;

@end
