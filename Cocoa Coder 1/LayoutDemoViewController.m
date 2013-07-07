
#import "LayoutDemoViewController.h"
#import "ViewVisibilitySetting.h"
#import "StrutSetting.h"
#import "StrutView.h"
#import "Anchor.h"
#import "ControlPanelViewController.h"
#import "DottedLayoutDemoView.h"

@interface LayoutDemoViewController ()

@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myViewTopEdgeConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myViewLeftEdgeConstraint;

@end

@implementation LayoutDemoViewController {
    NSMutableArray *settings;
    ControlPanelViewController *controlPanelViewController;
}

#pragma mark - UIViewController overrides

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSettings];
    [self initDottedViews];
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

#pragma mark - Storyboard actions and segues

- (IBAction)panGestureWasRecognized:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.myView.superview];
    self.myViewLeftEdgeConstraint.constant += translation.x;
    self.myViewTopEdgeConstraint.constant += translation.y;
    [recognizer setTranslation:CGPointZero inView:self.myView.superview];
}

- (void)prepareForControlPanelEmbeddingSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    controlPanelViewController = segue.destinationViewController;
    controlPanelViewController.settings = settings;
}

#pragma mark - Implementation details

- (void)initSettings {
    settings = [NSMutableArray array];
    UIView *myView = self.myView;
    UIView *superview = self.myView.superview;
    [self addVisibilitySettingWithName:@"myView" view:myView];
    [self addVisibilitySettingWithName:@"superview" view:superview];
    [self addHorizontalStrutSettingWithName:@"myView.center.x" yView:myView position:0.5 offset:0 fromXView:superview position:0 toXView:myView position:0];
//    [self addVerticalStrutSettingWithName:@"myView.center.y" xView:myView position:0.5 offset:0 fromYView:superview position:0 toYView:myView position:0];
//    [self addHorizontalStrutSettingWithName:@"myView.bounds.size.width" yView:myView position:1 offset:6 fromXView:myView position:0 toXView:myView position:1];
//    [self addVerticalStrutSettingWithName:@"myView.bounds.size.height" xView:myView position:1 offset:6 fromYView:myView position:0 toYView:myView position:1];
    controlPanelViewController.settings = settings;
}

- (void)addVisibilitySettingWithName:(NSString *)name view:(UIView *)view {
    view.hidden = YES;
    ViewVisibilitySetting *setting = [[ViewVisibilitySetting alloc] init];
    setting.name = name;
    setting.view = view;
    [settings addObject:setting];
}

- (void)addHorizontalStrutSettingWithName:(NSString *)name yView:(UIView *)yView position:(CGFloat)yPosition offset:(CGFloat)yOffset fromXView:(UIView *)xView0 position:(CGFloat)xPosition0 toXView:(UIView *)xView1 position:(CGFloat)xPosition1 {
    Anchor *anchor0 = [Anchor anchorWithXView:xView0 position:xPosition0 offset:0 yView:yView position:yPosition offset:yOffset];
    Anchor *anchor1 = [Anchor anchorWithXView:xView1 position:xPosition1 offset:0 yView:yView position:yPosition offset:yOffset];
    StrutView *strutView = [StrutView strutViewFromAnchor:anchor0 toAnchor:anchor1];
    strutView.hidden = YES;
    [settings addObject:[[StrutSetting alloc] initWithName:name strutView:strutView]];
    [self.view addSubview:strutView];
}

- (void)addVerticalStrutSettingWithName:(NSString *)name xView:(UIView *)xView position:(CGFloat)xPosition offset:(CGFloat)xOffset fromYView:(UIView *)yView0 position:(CGFloat)yPosition0 toYView:(UIView *)yView1 position:(CGFloat)yPosition1 {
    Anchor *anchor0 = [Anchor anchorWithXView:xView position:xPosition offset:xOffset yView:yView0 position:yPosition0 offset:0];
    Anchor *anchor1 = [Anchor anchorWithXView:xView position:xPosition offset:xOffset yView:yView1 position:yPosition1 offset:0];
    StrutView *strutView = [StrutView strutViewFromAnchor:anchor0 toAnchor:anchor1];
    strutView.hidden = YES;
    [settings addObject:[[StrutSetting alloc] initWithName:name strutView:strutView]];
    [self.view addSubview:strutView];
}

- (void)initDottedViews {
    DottedLayoutDemoView *view = [[DottedLayoutDemoView alloc] initWithOriginalView:self.myView];
    [self.view insertSubview:view atIndex:0];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureWasRecognized:)];
    [view addGestureRecognizer:recognizer];
}

@end
