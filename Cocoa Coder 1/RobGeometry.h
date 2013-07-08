
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

static inline CGPoint rectMidpoint(CGRect rect) {
    // I'm not using CGRectGetMid[XY] to avoid unnecessary calls to CGRectStandardize.
    return CGPointMake(rect.origin.x + rect.size.width * 0.5f, rect.origin.y + rect.size.height * 0.5f);
}

static inline CGPoint pointOffset(CGPoint point, CGFloat dx, CGFloat dy) {
    return CGPointMake(point.x + dx, point.y + dy);
}
