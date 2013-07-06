
#import "LayoutDemoViewController.h"
#import "StrutView.h"
#import "Anchor.h"

@interface LayoutDemoViewController ()

@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myViewTopEdgeConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myViewLeftEdgeConstraint;

@end

@implementation LayoutDemoViewController {
    NSMutableArray *struts;
}

#pragma mark - UIViewController overrides

- (void)viewDidLoad {
    [super viewDidLoad];

    struts = [NSMutableArray array];
    [struts addObject:[StrutView strutViewFromAnchor:[Anchor anchorWithXView:self.myView xPosition:0.5 yView:self.myView.superview position:0]
        toAnchor:[Anchor anchorWithXView:self.myView xPosition:0.5 yView:self.myView position:0.5]]];
    [struts addObject:[StrutView strutViewFromAnchor:[Anchor anchorWithXView:self.myView.superview xPosition:0 yView:self.myView position:0.5]
        toAnchor:[Anchor anchorWithXView:self.myView xPosition:0.5 yView:self.myView position:0.5]]];
    for (UIView *strut in struts) {
        [self.view addSubview:strut];
    }
}

#pragma mark - Storyboard actions

- (IBAction)panGestureWasRecognized:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.myView.superview];
    self.myViewLeftEdgeConstraint.constant += translation.x;
    self.myViewTopEdgeConstraint.constant += translation.y;
    [recognizer setTranslation:CGPointZero inView:self.myView.superview];
}

@end
