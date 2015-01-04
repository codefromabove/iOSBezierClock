//
//  BezierDigitAnimator.m
//  BezierClock
//
//  Created by Philip Schneider on 1/1/15.
//  Copyright (c) 2015 Code From Above, LLC. All rights reserved.
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

static UIColor *lineColor;
static float    lineSize             = 1.0;
static BOOL     continualAnimation   = NO;
static int      animationType        = 4;
static BOOL     showContinualShadows = NO;
static BOOL     drawControlLines     = NO;


@interface BezierDigitAnimator ()

@property (nonatomic) float origX;
@property (nonatomic) float origY;

@end

@implementation BezierDigitAnimator

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
        if (!lineColor)
        {
            lineColor = [UIColor blackColor];
        }
    }

    return self;
}

+ (void)setLineColor:(UIColor *)color
{
    lineColor = color;
}

+ (void)setLineSize:(float)size
{
    lineSize = size;
}

+ (void)setContinualAnimation:(BOOL)on
{
    continualAnimation = on;
}

+ (void)setAnimationType:(int)type
{
    animationType = type;
}

+ (void)setShowContinualShadows:(BOOL)on
{
    showContinualShadows = on;
}

+ (void)setDrawControlLines:(BOOL)on
{
    drawControlLines = on;
}

- (void)update:(BezierDigit *)current
          next:(BezierDigit *)next
         ratio:(float)ratio
{
    float animationRatio = 0.0;
    if (ratio > _animationStartRatio)
    {
        animationRatio = (ratio - _animationStartRatio) / (1 - _animationStartRatio);
    }
    if (continualAnimation)
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
    if (animationType == 2)
    { // quadratic
        animationRatio = animationRatio * animationRatio;
        ratio = ratio * ratio; // we don't need ratio any more
    }
    else if (animationType == 3)
    { // cubic
        animationRatio = animationRatio * animationRatio * animationRatio;
        ratio = ratio * ratio * ratio;
    }
    else if (animationType == 4)
    { // sinusoidal
        animationRatio = 0.5 * (-cos(animationRatio * M_PI) + 1);
        ratio = 0.5 * (-cos(ratio * M_PI) + 1);
    }

    //
    // Optional drawing of "shadows" showing continual animation.
    //
    if (showContinualShadows && !continualAnimation)
    {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [[UIColor lightGrayColor] setStroke];

        [path setLineWidth:3.0 * lineSize];
        [path setLineCapStyle:kCGLineCapRound];
        [path moveToPoint:CGPointMake(lerp([current vertexX], [next vertexX], animationRatio) + _origX,
                                      lerp([current vertexY], [next vertexY], ratio) + _origY)];

        for (int i = 0; i < 4; i++)
        {
            NSArray *currentPoints = [current getControl:i];
            NSArray *nextPoints    = [next    getControl:i];

            bezierVertexFromArrayListsRatios(path, currentPoints, nextPoints, ratio, _origX, _origY);
        }
        [path stroke];
    }

    //
    // Draw the digits
    //
    const float   rad  = 5 * lineSize; // rectangle width & circle diameter, confusingly..
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [lineColor setStroke];

    [path setLineWidth:4.0 * lineSize];
    [path setLineCapStyle:kCGLineCapRound];
    [path moveToPoint:CGPointMake(lerp([current vertexX], [next vertexX], animationRatio) + _origX,
                                  lerp([current vertexY], [next vertexY], animationRatio) + _origY)];
    for (int i = 0; i < 4; i++)
    {
        NSArray *currentPoints = [current getControl:i];
        NSArray *nextPoints    = [next    getControl:i];

        bezierVertexFromArrayListsRatios(path, currentPoints, nextPoints, animationRatio, _origX, _origY);
    }
    [path stroke];

    //
    // Optional rendering of control points/lines
    //
    if (drawControlLines)
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
        CGContextSetLineWidth(context, 1.5 * lineSize);

        for (int i = 0; i < 4; i++)
        {
            // spline lines & circles
            CGContextSetStrokeColorWithColor(context, colorLine);

            NSArray *from = [current getControl:i];
            NSArray *to   = [next    getControl:i];

            CGContextMoveToPoint(context,
                                 lerp([[from objectAtIndex:2] floatValue], [[to objectAtIndex:2] floatValue], animationRatio) + _origX,
                                 lerp([[from objectAtIndex:3] floatValue], [[to objectAtIndex:3] floatValue], animationRatio) + _origY);
            CGContextAddLineToPoint(context,
                                    lerp([[from objectAtIndex:4] floatValue], [[to objectAtIndex:4] floatValue], animationRatio) + _origX,
                                    lerp([[from objectAtIndex:5] floatValue], [[to objectAtIndex:5] floatValue], animationRatio) + _origY);
            CGContextStrokePath(context);

            CGRect rectangle = CGRectMake(lerp([[from objectAtIndex:2] floatValue], [[to objectAtIndex:2] floatValue], animationRatio) + _origX - rad/2,
                                          lerp([[from objectAtIndex:3] floatValue], [[to objectAtIndex:3] floatValue], animationRatio) + _origY - rad/2,
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
                                     lerp([[fromPlus1 objectAtIndex:0] floatValue], [[toPlus1 objectAtIndex:0] floatValue], animationRatio) + _origX,
                                     lerp([[fromPlus1 objectAtIndex:1] floatValue], [[toPlus1 objectAtIndex:1] floatValue], animationRatio) + _origY);
                CGContextAddLineToPoint(context,
                                        lerp([[from objectAtIndex:4] floatValue], [[to objectAtIndex:4] floatValue], animationRatio) + _origX,
                                        lerp([[from objectAtIndex:5] floatValue], [[to objectAtIndex:5] floatValue], animationRatio) + _origY);
                CGContextStrokePath(context);

                CGRect rectangle = CGRectMake(lerp([[fromPlus1 objectAtIndex:0] floatValue], [[toPlus1 objectAtIndex:0] floatValue], animationRatio) + _origX - rad/2,
                                              lerp([[fromPlus1 objectAtIndex:1] floatValue], [[toPlus1 objectAtIndex:1] floatValue], animationRatio) + _origY - rad/2,
                                              rad,
                                              rad);

                CGContextAddEllipseInRect(context, rectangle);
                CGContextStrokePath(context);
                CGContextFillEllipseInRect(context, rectangle);
            }

            // control point rectangles
            CGContextSetStrokeColorWithColor(context, colorRect);
            CGRect rect = CGRectMake(lerp([[from objectAtIndex:4] floatValue], [[to objectAtIndex:4] floatValue], animationRatio) + _origX - rad/2,
                                     lerp([[from objectAtIndex:5] floatValue], [[to objectAtIndex:5] floatValue], animationRatio) + _origY - rad/2,
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
                                     lerp([current vertexX], [next vertexX], animationRatio) + _origX,
                                     lerp([current vertexY], [next vertexY], animationRatio) + _origY);
                CGContextAddLineToPoint(context,
                                        lerp([[fromZero objectAtIndex:0] floatValue], [[toZero objectAtIndex:0] floatValue], animationRatio) + _origX,
                                        lerp([[fromZero objectAtIndex:1] floatValue], [[toZero objectAtIndex:1] floatValue], animationRatio) + _origY);
                CGContextStrokePath(context);

                CGRect rectangle = CGRectMake(lerp([[fromZero objectAtIndex:0] floatValue], [[toZero objectAtIndex:0] floatValue], animationRatio) + _origX - rad/2,
                                              lerp([[fromZero objectAtIndex:1] floatValue], [[toZero objectAtIndex:1] floatValue], animationRatio) + _origY - rad/2,
                                              rad,
                                              rad);

                CGContextAddEllipseInRect(context, rectangle);
                CGContextStrokePath(context);
                CGContextFillEllipseInRect(context, rectangle);

                CGContextSetStrokeColorWithColor(context, colorBlue);
                CGRect rect = CGRectMake(lerp([current vertexX], [next vertexX], animationRatio) + _origX - rad/2,
                                         lerp([current vertexY], [next vertexY], animationRatio) + _origY - rad/2,
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
