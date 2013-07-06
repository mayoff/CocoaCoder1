/*
Created by Rob Mayoff on 7/6/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import <UIKit/UIKit.h>

@interface UIView (Rob_FindAncestor)

/** I walk up the view tree, starting with myself, passing each view to `test`.  When `test` returns `YES`, I return the view.  If I reach the top of the tree without finding a view that passes `test`, I return `nil`. */
- (id)Rob_ancestorPassingTest:(BOOL (^)(UIView *ancestor))test;

@end
