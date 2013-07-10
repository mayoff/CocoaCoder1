
#import <Foundation/Foundation.h>

typedef void (^Rob_BlockKVOBlock)(NSString *observedKeyPath, id observedObject, NSDictionary *change);

@interface NSObject (Rob_BlockKVO)

/**
    I register the block as an observer of the given key path.  When the value of `[self valueForKeyPath:keyPath]` changes, I call the block.
    
    I return an token object representing the registration.  When the object is deallocated, I deregister the observer.  If I am deallocated before the token, I deregister the observer anyway.
*/
- (id)addObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(Rob_BlockKVOBlock)block;

@end
