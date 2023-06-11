//
//  DisplayOptionsViewController.h
//  BezierClock
//
//  Created by Philip Schneider on 1/2/15.
//  Copyright (c) 2015-2023 Code From Above, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BezierClockView;

@interface DisplayOptionsViewController : UIViewController

@property (weak, nonatomic)   BezierClockView *bcView;
@property (strong, nonatomic) UIColor         *lineSwatchColor;
@property (strong, nonatomic) UIColor         *backgroundSwatchColor;

@end
