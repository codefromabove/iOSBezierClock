//
//  BezierDigitAnimator.h
//  BezierClock
//
//  Created by Philip Schneider on 1/1/15.
//  Copyright (c) 2015 Code From Above, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BezierDigit;

@interface BezierDigitAnimator : NSObject

@property (nonatomic) float animationStartRatio;

- (instancetype)init:(float)origX
               origY:(float)origY
       pauseDuration:(float)pauseDuration
        animDuration:(float)animDuration;

- (void)update:(BezierDigit *)current
          next:(BezierDigit *)next
         ratio:(float)ratio;

+ (void)setLineColor:(UIColor *)color;
+ (void)setLineSize:(float)size;
+ (void)setContinualAnimation:(BOOL)on;
+ (void)setAnimationType:(NSInteger)type;
+ (void)setShowContinualShadows:(BOOL)on;
+ (void)setDrawControlLines:(BOOL)on;

@end
