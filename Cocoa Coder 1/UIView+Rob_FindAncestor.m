/*
Created by Rob Mayoff on 7/6/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "UIView+Rob_FindAncestor.h"

@implementation UIView (Rob_FindAncestor)

- (id)Rob_ancestorPassingTest:(BOOL (^)(UIView *))test {
    for (UIView *view = self; view != nil; view = view.superview) {
        if (test(view))
            return view;
    }
    return nil;
}

@end
