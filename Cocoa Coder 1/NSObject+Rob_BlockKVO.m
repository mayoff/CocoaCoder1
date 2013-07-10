/*
Created by Rob Mayoff on 7/10/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import "NSObject+Rob_BlockKVO.h"
#import <objc/runtime.h>

static char const *Rob_BlockKVODeallocationDetectorKey = "Rob_BlockKVODeallocationDetectorKey";

@class Rob_BlockKVODeallocationDetector;

/**
The `addObserverForKeyPath:options:block:` method creates me.  I am the observer passed to `addObserver:forKeyPath:options:context:`.  I am also the object returned by `addObserverForKeyPath:options:block:`.

There are two ways I can be deregistered.

1. I can be deallocated before the subject is deallocated.  In that case, I remove the detector from the subject.  Removing the detector will cause the detector to be deallocated, and it will then tell me to deregister.
2. The subject can be deallocated before me.  In that case, the subject will release the detector, which will cause the detector to be deallocated, and the detector will tell me to deregister.
*/

@interface Rob_BlockKVOObserver : NSObject {
@public
    Rob_BlockKVOBlock block;
    NSString *observedKeyPath;
    __unsafe_unretained NSObject *observedObject;
    __unsafe_unretained Rob_BlockKVODeallocationDetector *deallocationDetector;
}
@end

@implementation Rob_BlockKVOObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    block(keyPath, object, change);
}

- (void)deregister {
    [observedObject removeObserver:self forKeyPath:observedKeyPath];
    block = nil;
    observedKeyPath = nil;
    observedObject = nil;
    deallocationDetector = nil;
}

- (void)dealloc {
    if (deallocationDetector) {
        objc_setAssociatedObject(observedObject, Rob_BlockKVODeallocationDetectorKey, nil, OBJC_ASSOCIATION_ASSIGN);
        // That caused the detector to be deallocated, which told me to deregister.
    }
}

@end

/**
I create a Rob_BlockKVODeallocationDetector for each registration.  I attach this object to the observed object as a retained associate.  The observed object has the only reference to the detector, so when the observed object is deallocated, the detector is also deallocated.  When that happens, it tells the Rob_BlockKVOObserver to deregister itself.
*/
@interface Rob_BlockKVODeallocationDetector : NSObject {
@public
    __unsafe_unretained Rob_BlockKVOObserver *observer;
}
@end

@implementation Rob_BlockKVODeallocationDetector

- (void)dealloc {
    [observer deregister];
}

@end

@implementation NSObject (Rob_BlockKVO)

- (id)addObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(Rob_BlockKVOBlock)block {
    NSAssert(block != nil, @"%s requires that block not be nil", __func__);

    keyPath = [keyPath copy];
    block = [block copy];

    Rob_BlockKVOObserver *observer = [[Rob_BlockKVOObserver alloc] init];
    observer->block = block;
    observer->observedKeyPath = keyPath;
    observer->observedObject = self;

    Rob_BlockKVODeallocationDetector *detector = [[Rob_BlockKVODeallocationDetector alloc] init];
    detector->observer = observer;

    observer->deallocationDetector = detector;

    objc_setAssociatedObject(self, Rob_BlockKVODeallocationDetectorKey, detector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    detector = nil;

    [self addObserver:observer forKeyPath:keyPath options:options context:NULL];
    return observer;
}

@end
