
#import <CoreGraphics/CoreGraphics.h>

static inline CGPoint pointByReplacingX(CGPoint point, CGFloat newValue) {
    point.x = newValue;
    return point;
}

static inline CGPoint pointByReplacingY(CGPoint point, CGFloat newValue) {
    point.y = newValue;
    return point;
}

static inline CGRect rectByReplacingX(CGRect rect, CGFloat newValue) {
    rect.origin.x = newValue;
    return rect;
}

static inline CGRect rectByReplacingY(CGRect rect, CGFloat newValue) {
    rect.origin.y = newValue;
    return rect;
}

static inline CGRect rectByReplacingWidth(CGRect rect, CGFloat newValue) {
    rect.size.width = newValue;
    return rect;
}

static inline CGRect rectByReplacingHeight(CGRect rect, CGFloat newValue) {
    rect.size.height = newValue;
    return rect;
}

