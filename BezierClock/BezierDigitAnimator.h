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

//
// Easing applied to the digit animation. Values are persisted in
// NSUserDefaults, so don't renumber them.
//
typedef NS_ENUM(NSInteger, BezierAnimationType) {
    BezierAnimationTypeLinear     = 1,
    BezierAnimationTypeQuadratic  = 2,
    BezierAnimationTypeCubic      = 3,
    BezierAnimationTypeSinusoidal = 4,
};

@interface BezierDigitAnimator : NSObject

@property (nonatomic) float animationStartRatio;

@property (class, nonatomic, strong) UIColor            *lineColor;
@property (class, nonatomic, assign) float               lineSize;
@property (class, nonatomic, assign) BOOL                continualAnimation;
@property (class, nonatomic, assign) BezierAnimationType animationType;
@property (class, nonatomic, assign) BOOL                showContinualShadows;
@property (class, nonatomic, assign) BOOL                drawControlLines;

- (instancetype)initWithOrigX:(float)origX
                        origY:(float)origY;

- (void)update:(BezierDigit *)current
          next:(BezierDigit *)next
         ratio:(float)ratio;

@end
