
#import "AxisSetting.h"
#import "AxisView.h"
#import "BoundsAnchor.h"
#import "CanvasView.h"
#import "CenterAnchor.h"
#import "ControlPanelViewController.h"
#import "DottedLayoutDemoView.h"
#import "FrameAnchor.h"
#import "LayoutDemoView.h"
#import "LayoutDemoViewController.h"
#import "NSRunLoop+Rob_Observer.h"
#import "OriginAnchor.h"
#import "RobGeometry.h"
#import "StrutSetting.h"
#import "StrutView.h"
#import "ViewVisibilitySetting.h"

// I use these to ensure that struts are drawn over axes.
static CGFloat const ZPosition_Axis = 1;
static CGFloat const ZPosition_Strut = 2;

// I use these to ensure that the dotted view is under the demo superview.
static CGFloat const ZPosition_DottedView = 1;
static CGFloat const ZPosition_DemoView = 2;

@import QuartzCore;

@interface LayoutDemoViewController ()

@property (nonatomic, strong) IBOutlet CanvasView *canvasView;
@property (strong, nonatomic) IBOutlet UIView *myView;

@end

@implementation LayoutDemoViewController {
    NSMutableArray *settings;
    ControlPanelViewController *controlPanelViewController;

    // This is the observer that sees when the layout of any demo view changes.
    id layoutDidChangeObserver;

    // This is the observer that is notified by the run loop before QuartzCore's layout pass.
    Rob_RunLoopObserver *preLayoutObserver;
}

#pragma mark - UIViewController overrides

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSuperview];
    [self initMyView];
    [self initDottedView];
    [self initSettings];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    if (identifier.length == 0)
        return;
    NSString *selectorString = [NSString stringWithFormat:@"prepareFor%@Segue:sender:", identifier];
    SEL selector = NSSelectorFromString(selectorString);
    if (!selector)
        return;
    if (![self respondsToSelector:selector])
        return;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector withObject:segue withObject:sender];
#pragma clang diagnostic pop
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startObservingLayoutDidChange];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self startObservingLayoutDidChange];
}

#pragma mark - NSObject overrides

- (void)dealloc {
    [self stopObservingLayoutDidChange];
}

#pragma mark - Storyboard actions and segues

- (IBAction)panGestureWasRecognized:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.myView.superview];
    CGPoint center = self.myView.center;
    center.x += translation.x;
    center.y += translation.y;
    self.myView.center = center;
    [recognizer setTranslation:CGPointZero inView:self.myView.superview];
}

- (void)prepareForControlPanelEmbeddingSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    controlPanelViewController = segue.destinationViewController;
    controlPanelViewController.settings = settings;
}

#pragma mark - Implementation details - Initialization

static void removeViewFromAutolayout(UIView *view) {
    // Removing a view from the view hierarchy removes all constraints linking it to views outside itself.
    UIView *superview = view.superview;
    [view removeFromSuperview];
    [view removeConstraints:view.constraints];
    view.translatesAutoresizingMaskIntoConstraints = YES;
    view.autoresizingMask = 0;
    [superview addSubview:view];
}

- (void)initSuperview {
    UIView *superview = self.myView.superview;
    superview.layer.zPosition = ZPosition_DemoView;
    removeViewFromAutolayout(superview);
}

- (void)initMyView {
    removeViewFromAutolayout(self.myView);
}

- (void)initSettings {
    settings = [NSMutableArray array];
    UIView *myView = self.myView;
    UIView *superview = self.myView.superview;

    [self addVisibilitySettingWithName:@"myView" view:myView];
    [self addVisibilitySettingWithName:@"superview" view:superview];

    OriginAnchor *superviewOriginAnchor = [[OriginAnchor alloc] initWithView:superview];
    CenterAnchor *myViewCenterAnchor = [[CenterAnchor alloc] initWithView:myView];
    BoundsAnchor *superviewTopLeftAnchor = [BoundsAnchor anchorWithUnitPosition:CGPointZero inView:superview];
    BoundsAnchor *superviewTopLeftAnchorWithTweak = [BoundsAnchor anchorWithUnitPosition:CGPointZero absoluteOffset:CGPointMake(1, 1) inView:superview]; // 1 = half the strut thickness; looks better
    BoundsAnchor *myViewBoundsTopLeftAnchor = [BoundsAnchor anchorWithUnitPosition:CGPointZero inView:myView];
    FrameAnchor *myViewFrameTopLeftAnchor = [FrameAnchor anchorWithUnitPosition:CGPointZero inView:myView];

    [self addHorizontalStrutSettingWithName:@"myView.center.x" fromAnchor:superviewOriginAnchor toAnchor:myViewCenterAnchor setLengthBlock:^(CGFloat length) {
        myView.center = pointByReplacingX(myView.center, length);
        [myView layoutIfNeeded];
    }];

    [self addVerticalStrutSettingWithName:@"myView.center.y" fromAnchor:superviewOriginAnchor toAnchor:myViewCenterAnchor setLengthBlock:^(CGFloat length) {
        myView.center = pointByReplacingY(myView.center, length);
        [myView layoutIfNeeded];
    }];

    [self addHorizontalStrutSettingWithName:@"myView.bounds.size.width" fromAnchor:myViewBoundsTopLeftAnchor toAnchor:[BoundsAnchor anchorWithUnitPosition:CGPointMake(1, 1) absoluteOffset:CGPointMake(0, 6) inView:myView] setLengthBlock:^(CGFloat length) {
        myView.bounds = rectByReplacingWidth(myView.bounds, length);
        [myView layoutIfNeeded];
    }];

    [self addVerticalStrutSettingWithName:@"myView.bounds.size.height" fromAnchor:myViewBoundsTopLeftAnchor toAnchor:[BoundsAnchor anchorWithUnitPosition:CGPointMake(1, 1) absoluteOffset:CGPointMake(6, 0) inView:myView] setLengthBlock:^(CGFloat length) {
        myView.bounds = rectByReplacingHeight(myView.bounds, length);
        [myView layoutIfNeeded];
    }];

    [self addHorizontalStrutSettingWithName:@"myView.frame.origin.x" fromAnchor:superviewOriginAnchor toAnchor:myViewFrameTopLeftAnchor setLengthBlock:^(CGFloat length) {
        myView.frame = rectByReplacingX(myView.frame, length);
        [myView layoutIfNeeded];
    }];

    [self addVerticalStrutSettingWithName:@"myView.frame.origin.y" fromAnchor:superviewOriginAnchor toAnchor:myViewFrameTopLeftAnchor setLengthBlock:^(CGFloat length) {
        myView.frame = rectByReplacingY(myView.frame, length);
        [myView layoutIfNeeded];
    }];

    [self addHorizontalStrutSettingWithName:@"myView.frame.size.width" fromAnchor:myViewFrameTopLeftAnchor toAnchor:[FrameAnchor anchorWithUnitPosition:CGPointMake(1, 1) absoluteOffset:CGPointMake(0, 30) inView:myView] setLengthBlock:^(CGFloat length) {
        myView.bounds = rectByReplacingWidth(myView.bounds, length);
        [myView layoutIfNeeded];
    }];

    [self addVerticalStrutSettingWithName:@"myView.frame.size.height" fromAnchor:myViewFrameTopLeftAnchor toAnchor:[FrameAnchor anchorWithUnitPosition:CGPointMake(1, 1) absoluteOffset:CGPointMake(30, 0) inView:myView] setLengthBlock:^(CGFloat length) {
        myView.bounds = rectByReplacingHeight(myView.bounds, length);
        [myView layoutIfNeeded];
    }];

    [self addAxisSettingWithName:@"superview.bounds.origin.x" axisView:[AxisView yAxisViewObservingView:superview] strutView:[StrutView horizontalStrutViewWithName:@"superview.bounds.origin.x" fromAnchor:superviewOriginAnchor toAnchor:superviewTopLeftAnchor yAnchor:superviewTopLeftAnchorWithTweak]];
    [self addAxisSettingWithName:@"superview.bounds.origin.y" axisView:[AxisView xAxisViewObservingView:superview] strutView:[StrutView verticalStrutViewWithName:@"superview.bounds.origin.y" fromAnchor:superviewOriginAnchor toAnchor:superviewTopLeftAnchor xAnchor:superviewTopLeftAnchorWithTweak]];

    controlPanelViewController.settings = settings;
}

- (void)addVisibilitySettingWithName:(NSString *)name view:(UIView *)view {
    view.hidden = YES;
    ViewVisibilitySetting *setting = [[ViewVisibilitySetting alloc] init];
    setting.name = name;
    setting.view = view;
    [settings addObject:setting];
}

- (void)addAxisSettingWithName:(NSString *)name axisView:(UIView *)calloutView strutView:(UIView *)strutView {
    calloutView.hidden = YES;
    calloutView.layer.zPosition = ZPosition_Axis;
    [self.canvasView.calloutContainerView addSubview:calloutView];

    strutView.hidden = YES;
    strutView.layer.zPosition = ZPosition_Strut;
    [self.canvasView.calloutContainerView addSubview:strutView];

    AxisSetting *setting = [[AxisSetting alloc] initWithName:name calloutView:calloutView];
    setting.otherCalloutViews = [NSSet setWithObject:strutView];
    [settings addObject:setting];
}

- (void)addHorizontalStrutSettingWithName:(NSString *)name fromAnchor:(Anchor *)fromAnchor toAnchor:(Anchor *)toAnchor setLengthBlock:(StrutSettingSetLengthBlock)block {
    StrutView *strutView = [StrutView horizontalStrutViewWithName:name fromAnchor:fromAnchor toAnchor:toAnchor yAnchor:toAnchor];
    return [self addStrutSettingWithName:name strutView:strutView setLengthBlock:block];
}

- (void)addVerticalStrutSettingWithName:(NSString *)name fromAnchor:(Anchor *)fromAnchor toAnchor:(Anchor *)toAnchor setLengthBlock:(StrutSettingSetLengthBlock)block {
    StrutView *strutView = [StrutView verticalStrutViewWithName:name fromAnchor:fromAnchor toAnchor:toAnchor xAnchor:toAnchor];
    return [self addStrutSettingWithName:name strutView:strutView setLengthBlock:block];
}

- (void)addStrutSettingWithName:(NSString *)name strutView:(StrutView *)strutView setLengthBlock:(StrutSettingSetLengthBlock)block {
    strutView.hidden = YES;
    strutView.layer.zPosition = ZPosition_Strut;
    [self.canvasView.calloutContainerView addSubview:strutView];
    [settings addObject:[[StrutSetting alloc] initWithName:name strutView:strutView setLengthBlock:block]];
}

- (void)initDottedView {
    DottedLayoutDemoView *view = [[DottedLayoutDemoView alloc] initWithOriginalView:self.myView];
    view.layer.zPosition = ZPosition_DottedView;
    [self.canvasView.dottedContainerView insertSubview:view atIndex:0];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureWasRecognized:)];
    [view addGestureRecognizer:recognizer];
}

#pragma mark - Implementation details - model/view sync

- (void)startObservingLayoutDidChange {
    if (!layoutDidChangeObserver) {
        layoutDidChangeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:LayoutDemoViewLayoutDidChange object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            [self scheduleCalloutAndControlPanelUpdate];
        }];
    }
}

- (void)stopObservingLayoutDidChange {
    if (layoutDidChangeObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:layoutDidChangeObserver];
        layoutDidChangeObserver = nil;
    }
}

- (void)scheduleCalloutAndControlPanelUpdate {
    if (!preLayoutObserver) {
        preLayoutObserver = [[Rob_RunLoopObserver alloc] initWithActivities:kCFRunLoopBeforeWaiting repeats:NO order:0 weakObject:self block:^(LayoutDemoViewController *self, CFRunLoopActivity activity) {
            [self syncViewsToModel];
            self->preLayoutObserver = nil;
        }];
        [[NSRunLoop mainRunLoop] Rob_addObserver:preLayoutObserver forMode:NSRunLoopCommonModes];
    }
}

- (void)syncViewsToModel {
    // The demo views are the “model”.  I need to make sure they are laid out (which should actually be a no-op in the current setup).  Then I need to get the callout views laid out.  The control panel views observe the callout views so they will update themselves.
    [self.canvasView setNeedsLayout];
    [self.canvasView layoutIfNeeded];
}

@end
