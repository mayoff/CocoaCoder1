
#import "LayoutDemoViewController.h"
#import "Setting.h"
#import "StrutView.h"
#import "Anchor.h"
#import "ControlPanelViewController.h"

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

    settings = [NSMutableArray array];
    [settings addObject:[[Setting alloc] initWithName:@"myView.center.x"
        strutView:[StrutView
            strutViewFromAnchor:[Anchor anchorWithXView:self.myView.superview xPosition:0 yView:self.myView position:0.5]
            toAnchor:[Anchor anchorWithXView:self.myView xPosition:0.5 yView:self.myView position:0.5]]]];
    [settings addObject:[[Setting alloc] initWithName:@"myView.center.y"
        strutView:[StrutView
            strutViewFromAnchor:[Anchor anchorWithXView:self.myView xPosition:0.5 yView:self.myView.superview position:0]
            toAnchor:[Anchor anchorWithXView:self.myView xPosition:0.5 yView:self.myView position:0.5]]]];
    for (Setting *setting in settings) {
        [self.view addSubview:setting.strutView];
    }
    controlPanelViewController.settings = settings;
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
}

@end
