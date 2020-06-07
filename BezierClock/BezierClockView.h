//
//  BezierClockView.h
//  BezierClock
//
//  Created by Philip Schneider on 12/31/14.
//  Copyright (c) 2014-2020 Code From Above, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BezierClockView : UIView

//
// Drawing and animation options
//
@property (nonatomic)         BOOL      drawControlLines;
@property (nonatomic)         BOOL      continualAnimation;
@property (nonatomic)         BOOL      showContinualShadows;
@property (nonatomic)         NSInteger animationType;
@property (nonatomic)         float     animDurationUser;
@property (nonatomic, strong) UIColor  *lineColor;
@property (nonatomic)         float     lineSize;
@property (nonatomic, strong) UIColor  *bgColor;
@property (nonatomic)         BOOL      transitioning;

@end
