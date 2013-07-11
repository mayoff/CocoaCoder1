/*
Created by Rob Mayoff on 7/10/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import <UIKit/UIKit.h>

@interface CanvasView : UIView

/** This is the subview which holds the dotted views. I create it automatically. */
@property (nonatomic, strong, readonly) UIView *dottedContainerView;

/** This is the subview which holds the demo views. You must set this. */
@property (nonatomic, strong) IBOutlet UIView *demoContainerView;

/** This is the subview which holds the callouts. I create it automatically. */
@property (nonatomic, strong, readonly) UIView *calloutContainerView;

@end
