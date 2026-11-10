//
//  BezierDigitAnimator.m
//  BezierClock
//
//  Translated from original code source: Jack Frigaard, https://jackfrigaard.com/bezier-clock/
//  by Philip Schneider on 1/1/15.
//  Copyright (c) 2015-2026 Code From Above, LLC. All rights reserved.
//

#import "BezierDigitAnimator.h"
#import "BezierDigit.h"
#import <UIKit/UIKit.h>


static float lerp(float a, float b, float t)
{
    return (1 - t) * a + t * b;
}

static void bezierVertexFromArrayListsRatios(UIBezierPath *path, NSArray *from, NSArray *to, float ratio, float offsetX, float offsetY)
{
    [path addCurveToPoint:CGPointMake(lerp([[from objectAtIndex:4] floatValue], [[to objectAtIndex:4] floatValue], ratio) + offsetX,
                                      lerp([[from objectAtIndex:5] floatValue], [[to objectAtIndex:5] floatValue], ratio) + offsetY)
            controlPoint1:CGPointMake(lerp([[from objectAtIndex:0] floatValue], [[to objectAtIndex:0] floatValue], ratio) + offsetX,
                                      lerp([[from objectAtIndex:1] floatValue], [[to objectAtIndex:1] floatValue], ratio) + offsetY)
            controlPoint2:CGPointMake(lerp([[from objectAtIndex:2] floatValue], [[to objectAtIndex:2] floatValue], ratio) + offsetX,
                                      lerp([[from objectAtIndex:3] floatValue], [[to objectAtIndex:3] floatValue], ratio) + offsetY)];
}

@interface BezierDigitAnimator ()

@property (nonatomic) float origX;
@property (nonatomic) float origY;

@end

@implementation BezierDigitAnimator

static UIColor            *_lineColor;
static float               _lineSize;
static BOOL                _continualAnimation;
static BezierAnimationType _animationType;
static BOOL                _showContinualShadows;
static BOOL                _drawControlLines;

// Colors used when drawing control points/lines
static UIColor *_controlLineColor;
static UIColor *_controlRectColor;
static UIColor *_controlStartLineColor;
static UIColor *_controlStartRectColor;

+ (void)initialize
{
    if (self == [BezierDigitAnimator class]) {
        _lineColor            = [UIColor labelColor];
        _lineSize             = 1.0;
        _continualAnimation   = NO;
        _animationType        = BezierAnimationTypeSinusoidal;
        _showContinualShadows = NO;
        _drawControlLines     = NO;

        _controlLineColor      = [UIColor colorWithRed:230.0/255.0 green:21.0/255.0 blue:21.0/255.0  alpha:1.0];
        _controlRectColor      = [UIColor colorWithRed:78.0/255.0  green:78.0/255.0 blue:214.0/255.0 alpha:1.0];
        _controlStartLineColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        _controlStartRectColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
    }
}

- (instancetype)initWithOrigX:(float)origX
                        origY:(float)origY
{
    self = [super init];

    if (self)
    {
        _origX = origX;
        _origY = origY;
    }

    return self;
}

+ (UIColor *)lineColor
{
    return _lineColor;
}

+ (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
}

+ (float)lineSize
{
    return _lineSize;
}

+ (void)setLineSize:(float)lineSize
{
    _lineSize = lineSize;
}

+ (BOOL)continualAnimation
{
    return _continualAnimation;
}

+ (void)setContinualAnimation:(BOOL)continualAnimation
{
    _continualAnimation = continualAnimation;
}

+ (BezierAnimationType)animationType
{
    return _animationType;
}

+ (void)setAnimationType:(BezierAnimationType)animationType
{
    _animationType = animationType;
}

+ (BOOL)showContinualShadows
{
    return _showContinualShadows;
}

+ (void)setShowContinualShadows:(BOOL)showContinualShadows
{
    _showContinualShadows = showContinualShadows;
}

+ (BOOL)drawControlLines
{
    return _drawControlLines;
}

+ (void)setDrawControlLines:(BOOL)drawControlLines
{
    _drawControlLines = drawControlLines;
}

- (void)update:(BezierDigit *)current
          next:(BezierDigit *)next
         ratio:(float)ratio
{
    float animationRatio = 0.0;
    if (ratio > [self animationStartRatio])
    {
        animationRatio = (ratio - [self animationStartRatio]) / (1 - [self animationStartRatio]);
    }
    if (_continualAnimation)
    {
        animationRatio = ratio;
    }
    if (ratio < 0.0)
    {
        animationRatio = 0.0;
    }
    if (ratio > 1.0)
    {
        animationRatio = 1;
    }
    if (_animationType == BezierAnimationTypeQuadratic)
    {
        animationRatio = animationRatio * animationRatio;
        ratio = ratio * ratio; // we don't need ratio any more
    }
    else if (_animationType == BezierAnimationTypeCubic)
    {
        animationRatio = animationRatio * animationRatio * animationRatio;
        ratio = ratio * ratio * ratio;
    }
    else if (_animationType == BezierAnimationTypeSinusoidal)
    {
        animationRatio = 0.5 * (-cos(animationRatio * M_PI) + 1);
        ratio = 0.5 * (-cos(ratio * M_PI) + 1);
    }

    //
    // Optional drawing of "shadows" showing continual animation.
    //
    if (_showContinualShadows && !_continualAnimation)
    {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [[UIColor lightGrayColor] setStroke];

        [path setLineWidth:5.0 * _lineSize];
        [path setLineCapStyle:kCGLineCapRound];
        [path moveToPoint:CGPointMake(lerp([current vertexX], [next vertexX], ratio) + [self origX],
                                      lerp([current vertexY], [next vertexY], ratio) + [self origY])];

        for (int i = 0; i < 4; i++)
        {
            NSArray *currentPoints = [current getControl:i];
            NSArray *nextPoints    = [next    getControl:i];

            bezierVertexFromArrayListsRatios(path, currentPoints, nextPoints, ratio, [self origX], [self origY]);
        }
        [path stroke];
    }

    //
    // Draw the digits
    //
    const float   rad  = 5 * _lineSize; // rectangle width & circle diameter, confusingly..
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [_lineColor setStroke];

    [path setLineWidth:5.0 * _lineSize];
    [path setLineCapStyle:kCGLineCapRound];
    [path moveToPoint:CGPointMake(lerp([current vertexX], [next vertexX], animationRatio) + [self origX],
                                  lerp([current vertexY], [next vertexY], animationRatio) + [self origY])];
    for (int i = 0; i < 4; i++)
    {
        NSArray *currentPoints = [current getControl:i];
        NSArray *nextPoints    = [next    getControl:i];

        bezierVertexFromArrayListsRatios(path, currentPoints, nextPoints, animationRatio, [self origX], [self origY]);
    }
    [path stroke];

    //
    // Optional rendering of control points/lines
    //
    if (_drawControlLines)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 1.5 * _lineSize);

        for (int i = 0; i < 4; i++)
        {
            // spline lines & circles
            CGContextSetStrokeColorWithColor(context, _controlLineColor.CGColor);

            NSArray *from = [current getControl:i];
            NSArray *to   = [next    getControl:i];

            CGContextMoveToPoint(context,
                                 lerp([[from objectAtIndex:2] floatValue], [[to objectAtIndex:2] floatValue], animationRatio) + [self origX],
                                 lerp([[from objectAtIndex:3] floatValue], [[to objectAtIndex:3] floatValue], animationRatio) + [self origY]);
            CGContextAddLineToPoint(context,
                                    lerp([[from objectAtIndex:4] floatValue], [[to objectAtIndex:4] floatValue], animationRatio) + [self origX],
                                    lerp([[from objectAtIndex:5] floatValue], [[to objectAtIndex:5] floatValue], animationRatio) + [self origY]);
            CGContextStrokePath(context);

            CGRect rectangle = CGRectMake(lerp([[from objectAtIndex:2] floatValue], [[to objectAtIndex:2] floatValue], animationRatio) + [self origX] - rad/2,
                                          lerp([[from objectAtIndex:3] floatValue], [[to objectAtIndex:3] floatValue], animationRatio) + [self origY] - rad/2,
                                          rad,
                                          rad);

            CGContextAddEllipseInRect(context, rectangle);
            CGContextStrokePath(context);
            CGContextFillEllipseInRect(context, rectangle);

            if (i < 3)
            {
                NSArray *fromPlus1 = [current getControl:i+1];
                NSArray *toPlus1   = [next    getControl:i+1];

                CGContextMoveToPoint(context,
                                     lerp([[fromPlus1 objectAtIndex:0] floatValue], [[toPlus1 objectAtIndex:0] floatValue], animationRatio) + [self origX],
                                     lerp([[fromPlus1 objectAtIndex:1] floatValue], [[toPlus1 objectAtIndex:1] floatValue], animationRatio) + [self origY]);
                CGContextAddLineToPoint(context,
                                        lerp([[from objectAtIndex:4] floatValue], [[to objectAtIndex:4] floatValue], animationRatio) + [self origX],
                                        lerp([[from objectAtIndex:5] floatValue], [[to objectAtIndex:5] floatValue], animationRatio) + [self origY]);
                CGContextStrokePath(context);

                CGRect rectangle = CGRectMake(lerp([[fromPlus1 objectAtIndex:0] floatValue], [[toPlus1 objectAtIndex:0] floatValue], animationRatio) + [self origX] - rad/2,
                                              lerp([[fromPlus1 objectAtIndex:1] floatValue], [[toPlus1 objectAtIndex:1] floatValue], animationRatio) + [self origY] - rad/2,
                                              rad,
                                              rad);

                CGContextAddEllipseInRect(context, rectangle);
                CGContextStrokePath(context);
                CGContextFillEllipseInRect(context, rectangle);
            }

            // control point rectangles
            CGContextSetStrokeColorWithColor(context, _controlRectColor.CGColor);
            CGRect rect = CGRectMake(lerp([[from objectAtIndex:4] floatValue], [[to objectAtIndex:4] floatValue], animationRatio) + [self origX] - rad/2,
                                     lerp([[from objectAtIndex:5] floatValue], [[to objectAtIndex:5] floatValue], animationRatio) + [self origY] - rad/2,
                                     rad,
                                     rad);
            CGContextAddRect(context, rect);
            CGContextStrokePath(context);
            CGContextFillRect(context, rect);

            if (i == 0)
            {
                // All the edge cases that can't go in the for loop - end points etc.
                CGContextSetStrokeColorWithColor(context, _controlStartLineColor.CGColor);

                NSArray *fromZero = [current getControl:0];
                NSArray *toZero   = [next    getControl:0];

                CGContextMoveToPoint(context,
                                     lerp([current vertexX], [next vertexX], animationRatio) + [self origX],
                                     lerp([current vertexY], [next vertexY], animationRatio) + [self origY]);
                CGContextAddLineToPoint(context,
                                        lerp([[fromZero objectAtIndex:0] floatValue], [[toZero objectAtIndex:0] floatValue], animationRatio) + [self origX],
                                        lerp([[fromZero objectAtIndex:1] floatValue], [[toZero objectAtIndex:1] floatValue], animationRatio) + [self origY]);
                CGContextStrokePath(context);

                CGRect rectangle = CGRectMake(lerp([[fromZero objectAtIndex:0] floatValue], [[toZero objectAtIndex:0] floatValue], animationRatio) + [self origX] - rad/2,
                                              lerp([[fromZero objectAtIndex:1] floatValue], [[toZero objectAtIndex:1] floatValue], animationRatio) + [self origY] - rad/2,
                                              rad,
                                              rad);

                CGContextAddEllipseInRect(context, rectangle);
                CGContextStrokePath(context);
                CGContextFillEllipseInRect(context, rectangle);

                CGContextSetStrokeColorWithColor(context, _controlStartRectColor.CGColor);
                CGRect rect = CGRectMake(lerp([current vertexX], [next vertexX], animationRatio) + [self origX] - rad/2,
                                         lerp([current vertexY], [next vertexY], animationRatio) + [self origY] - rad/2,
                                         rad,
                                         rad);

                CGContextAddRect(context, rect);
                CGContextStrokePath(context);
                CGContextFillRect(context, rect);
            }
        }
    }
}

@end
