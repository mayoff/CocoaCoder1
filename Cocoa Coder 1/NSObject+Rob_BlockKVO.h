
#import <Foundation/Foundation.h>

typedef void (^Rob_BlockKVOBlock)(id self, NSString *observedKeyPath, id observedObject, NSDictionary *change);

@interface NSObject (Rob_BlockKVO)

/**
    I register the block as an observer of the given key path.  When the value of `[self valueForKeyPath:keyPath]` changes, I call the block.
    
    I return an token object representing the registration.  When the object is deallocated, I deregister the observer.  If I am deallocated before the token, I deregister the observer anyway.
    
    I store the `selfReference` object weakly.  I pass it to the block in the `self` argument as a strong reference.  This makes it easy to avoid retain cycles without having to declare a `weakSelf` variable wherever you use this API.
*/
- (id)addObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options selfReference:(id)selfReference block:(Rob_BlockKVOBlock)block;

@end
