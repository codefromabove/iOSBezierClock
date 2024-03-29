//
//  BezierDigitAnimator.m
//  BezierClock
//
//  Translated from original code source: Jack Frigaard, http://jackf.net/bezier-clock/
//  by Philip Schneider on 1/1/15.
//  Copyright (c) 2015-2023 Code From Above, LLC. All rights reserved.
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

@property (class, nonatomic, strong) UIColor  *lineColor;
@property (class, nonatomic, assign) float     lineSize;
@property (class, nonatomic, assign) BOOL      continualAnimation;
@property (class, nonatomic, assign) NSInteger animationType;
@property (class, nonatomic, assign) BOOL      showContinualShadows;
@property (class, nonatomic, assign) BOOL      drawControlLines;

@end

@implementation BezierDigitAnimator

static UIColor  *_lineColor;
static float     _lineSize;
static BOOL      _continualAnimation;
static NSInteger _animationType;
static BOOL      _showContinualShadows;
static BOOL      _drawControlLines;


+ (void)initialize
{
    if (self == [BezierDigitAnimator class]) {
        _lineColor            = [UIColor labelColor];
        _lineSize             = 1.0;
        _continualAnimation   = NO;
        _animationType        = 4;
        _showContinualShadows = NO;
        _drawControlLines     = NO;
    }
}

- (instancetype)init:(float)origX
               origY:(float)origY
       pauseDuration:(float)pauseDuration
        animDuration:(float)animDuration
{
    self = [super init];

    if (self)
    {
        _origX = origX;
        _origY = origY;
        _animationStartRatio = pauseDuration / (pauseDuration + animDuration);
    }

    return self;
}

+ (UIColor *)lineColor
{
    return _lineColor;
}

+ (void)setLineColor:(UIColor *)color
{
    _lineColor = color;
}

+ (float)lineSize
{
    return _lineSize;
}

+ (void)setLineSize:(float)size
{
    _lineSize = size;
}

+ (BOOL)continualAnimation
{
    return _continualAnimation;
}

+ (void)setContinualAnimation:(BOOL)on
{
    _continualAnimation = on;
}

+ (NSInteger)animationType
{
    return _animationType;
}

+ (void)setAnimationType:(NSInteger)type
{
    _animationType = type;
}

+ (BOOL)showContinualShadows
{
    return _showContinualShadows;
}

+ (void)setShowContinualShadows:(BOOL)on
{
    _showContinualShadows = on;
}

+ (BOOL)drawControlLines
{
    return _drawControlLines;
}

+ (void)setDrawControlLines:(BOOL)on
{
    _drawControlLines = on;
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
    if (_animationType == 2)
    { // quadratic
        animationRatio = animationRatio * animationRatio;
        ratio = ratio * ratio; // we don't need ratio any more
    }
    else if (_animationType == 3)
    { // cubic
        animationRatio = animationRatio * animationRatio * animationRatio;
        ratio = ratio * ratio * ratio;
    }
    else if (_animationType == 4)
    { // sinusoidal
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
        [path moveToPoint:CGPointMake(lerp([current vertexX], [next vertexX], animationRatio) + [self origX],
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
        CGContextRef    context    = UIGraphicsGetCurrentContext();
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();

        CGFloat    componentsLine[] = { 230.0/255.0, 21.0/255.0, 21.0/255.0, 1.0 };
        CGColorRef colorLine        = CGColorCreate(colorspace, componentsLine);

        CGFloat    componentsRect[] = { 78.0/255.0, 78.0/255.0, 214.0/255.0, 1.0 };
        CGColorRef colorRect        = CGColorCreate(colorspace, componentsRect);

        CGFloat    componentsRed[]  = { 255.0/255.0, 0.0/255.0, 0.0/255.0, 1.0 };
        CGColorRef colorRed         = CGColorCreate(colorspace, componentsRed);

        CGFloat    componentsBlue[] = { 0.0/255.0, 0.0/255.0, 255/255.0, 1.0 };
        CGColorRef colorBlue        = CGColorCreate(colorspace, componentsBlue);

        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 1.5 * _lineSize);

        for (int i = 0; i < 4; i++)
        {
            // spline lines & circles
            CGContextSetStrokeColorWithColor(context, colorLine);

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
            CGContextSetStrokeColorWithColor(context, colorRect);
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
                CGContextSetStrokeColorWithColor(context, colorRed);

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

                CGContextSetStrokeColorWithColor(context, colorBlue);
                CGRect rect = CGRectMake(lerp([current vertexX], [next vertexX], animationRatio) + [self origX] - rad/2,
                                         lerp([current vertexY], [next vertexY], animationRatio) + [self origY] - rad/2,
                                         rad,
                                         rad);

                CGContextAddRect(context, rect);
                CGContextStrokePath(context);
                CGContextFillRect(context, rect);
            }
        }

        CGColorSpaceRelease(colorspace);

        CGColorRelease(colorLine);
        CGColorRelease(colorRect);
        CGColorRelease(colorRed);
        CGColorRelease(colorBlue);
    }
}

@end
