/*
Created by Rob Mayoff on 7/10/13.
Copyright (c) 2013 Rob Mayoff. All rights reserved.
*/

#import <UIKit/UIKit.h>

@interface CanvasView : UIView

@property (nonatomic, strong) IBOutlet UIView *demoView;
@property (nonatomic, strong, readonly) UIView *calloutContainerView;

@end
