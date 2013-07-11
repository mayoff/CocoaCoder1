/*
Created by Rob Mayoff on 7/10/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import <Foundation/Foundation.h>

typedef void (^Rob_RunLoopObserverBlock)(id self, CFRunLoopActivity activity);

@interface Rob_RunLoopObserver : NSObject

/**
    I initialize myself with the specified `activities`, `repeats`, and `order` parameters.  See the `CFRunLoopObserverCreate` documentation for details.
    
    I keep a weak reference to `weakObject`.

    When the run loop notifies me, I call `block`.  I pass it a strong reference to `weakObject` as its first parameter and the current activity as its second parameter.
*/
- (instancetype)initWithActivities:(CFOptionFlags)activities repeats:(BOOL)repeats order:(CFIndex)order weakObject:(id)weakObject block:(Rob_RunLoopObserverBlock)block;

/** I remove myself from any run loops to which I was added.  I do this automatically when I am deallocated. */
- (void)invalidate;

@end


@interface NSRunLoop (Rob_Observer)

/** I add `observer` as an observer for the specified `mode`.  See the `CFRunLoopAddObserver` documentation for details.

To remove `observer`, send it the `invalidate` message or just let it be deallocated.
*/

- (void)Rob_addObserver:(Rob_RunLoopObserver *)observer forMode:(NSString *)mode;

@end
