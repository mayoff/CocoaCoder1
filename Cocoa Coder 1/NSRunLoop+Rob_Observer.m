/*
Created by Rob Mayoff on 7/10/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "NSRunLoop+Rob_Observer.h"

@interface Rob_RunLoopObserver ()

@property (nonatomic, readonly) CFRunLoopObserverRef cfObserver;

@end

static void Rob_RunLoopObserver_callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);

@implementation Rob_RunLoopObserver {
    __weak id weakObject;
    Rob_RunLoopObserverBlock block;
}

#pragma mark - Public API

- (instancetype)initWithActivities:(CFOptionFlags)activities repeats:(BOOL)repeats order:(CFIndex)order weakObject:(id)object block:(Rob_RunLoopObserverBlock)originalBlock {
    if ((self = [super init])) {
        weakObject = object;
        block = [originalBlock copy];
        _cfObserver = CFRunLoopObserverCreate(NULL, activities, repeats, order, Rob_RunLoopObserver_callback, &(CFRunLoopObserverContext){
            .version = 0,
            .info = (__bridge void *)(self),
            .retain = NULL,
            .release = NULL,
            .copyDescription = CFCopyDescription
        });
    }
    return self;
}

- (void)invalidate {
    if (_cfObserver) {
        CFRunLoopObserverInvalidate(_cfObserver);
        CFRelease(_cfObserver);
        _cfObserver = nil;
        weakObject = nil;
        block = nil;
    }
}

- (void)dealloc {
    [self invalidate];
}

- (void)invokeWithActivity:(CFRunLoopActivity)activity {
    id strongObject = weakObject;
    block(strongObject, activity);
}

@end

static void Rob_RunLoopObserver_callback(CFRunLoopObserverRef cfObserver, CFRunLoopActivity activity, void *info) {
    Rob_RunLoopObserver *observer = (__bridge Rob_RunLoopObserver *)(info);
    [observer invokeWithActivity:activity];
}

@implementation NSRunLoop (Rob_Observer)

- (void)Rob_addObserver:(Rob_RunLoopObserver *)observer forMode:(NSString *)mode {
    CFRunLoopAddObserver(self.getCFRunLoop, observer.cfObserver, (__bridge CFStringRef)(mode));
}

@end
