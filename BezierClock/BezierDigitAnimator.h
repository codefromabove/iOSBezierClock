//
//  BezierDigitAnimator.h
//  BezierClock
//
//  Created by Philip Schneider on 1/1/15.
//  Copyright (c) 2015-2026 Code From Above, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BezierDigit;

@interface BezierDigitAnimator : NSObject

@property (nonatomic) float animationStartRatio;

@property (class, nonatomic, strong) UIColor  *lineColor;
@property (class, nonatomic, assign) float     lineSize;
@property (class, nonatomic, assign) BOOL      continualAnimation;
@property (class, nonatomic, assign) NSInteger animationType;
@property (class, nonatomic, assign) BOOL      showContinualShadows;
@property (class, nonatomic, assign) BOOL      drawControlLines;

- (instancetype)init:(float)origX
               origY:(float)origY
       pauseDuration:(float)pauseDuration
        animDuration:(float)animDuration;

- (void)update:(BezierDigit *)current
          next:(BezierDigit *)next
         ratio:(float)ratio;

@end
