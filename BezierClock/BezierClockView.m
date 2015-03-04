//
//  BezierClockView.m
//  BezierClock
//
//  Translated from original code source: Jack Frigaard, http://jackf.net/bezier-clock/
//  by Philip Schneider on 12/31/14.
//  Copyright (c) 2014 Code From Above, LLC. All rights reserved.
//

#import "BezierClockView.h"
#import "BezierDigit.h"
#import "BezierDigitAnimator.h"

@interface BezierClockView ()

@property (nonatomic, strong) CADisplayLink       *displayLink;
@property (nonatomic)         BOOL                 animationRunning;
@property (nonatomic)         CFTimeInterval       lastDrawTime;

@property (nonatomic, strong) BezierDigitAnimator *hoursTensDigit;
@property (nonatomic, strong) BezierDigitAnimator *hoursUnitsDigit;

@property (nonatomic, strong) BezierDigitAnimator *minutesTensDigit;
@property (nonatomic, strong) BezierDigitAnimator *minutesUnitsDigit;

@property (nonatomic, strong) BezierDigitAnimator *secondsTensDigit;
@property (nonatomic, strong) BezierDigitAnimator *secondsUnitsDigit;

@property (nonatomic, strong) NSArray             *digits;

@end

@implementation BezierClockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //
        // Set up default options, if necessary.
        //
        NSUserDefaults *userDefaults  = [NSUserDefaults standardUserDefaults];
        BOOL            isInitialized = [userDefaults boolForKey:@"initialized"];
        if (!isInitialized)
        {
            [userDefaults setBool:YES forKey:@"initialized"];

            // http://stackoverflow.com/questions/1275662/saving-uicolor-to-and-loading-from-nsuserdefaults
            NSData *lineColorData       = [NSKeyedArchiver archivedDataWithRootObject:[UIColor blackColor]];
            NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor grayColor]];

            [userDefaults setBool:NO                    forKey:@"drawControlLines"];
            [userDefaults setBool:NO                    forKey:@"continualAnimation"];
            [userDefaults setBool:NO                    forKey:@"showContinualShadows"];
            [userDefaults setInteger:4                  forKey:@"animationType"];
            [userDefaults setFloat:1.0                  forKey:@"animDurationUser"];
            [userDefaults setObject:lineColorData       forKey:@"lineColor"];
            [userDefaults setFloat:1.0                  forKey:@"lineSize"];
            [userDefaults setObject:backgroundColorData forKey:@"backgroundColor"];

            [userDefaults synchronize];
        }

        //
        // Initialize options from NSUserDefaults
        //
        NSData *lineColorData       = [[NSUserDefaults standardUserDefaults] objectForKey:@"lineColor"];
        NSData *backgroundColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"];

        _drawControlLines           = [userDefaults boolForKey:@"drawControlLines"];
        _continualAnimation         = [userDefaults boolForKey:@"continualAnimation"];
        _showContinualShadows       = [userDefaults boolForKey:@"showContinualShadows"];;
        // 1 for linear, 2 for quadratic, 3 for cubic, 4 for sinuisoidial
        _animationType              = [userDefaults integerForKey:@"animationType"];
        _animDurationUser           = [userDefaults floatForKey:@"animDurationUser"];
        _lineColor                  = [NSKeyedUnarchiver unarchiveObjectWithData:lineColorData];
        _lineSize                   = [userDefaults floatForKey:@"lineSize"];
        _bgColor                    = [NSKeyedUnarchiver unarchiveObjectWithData:backgroundColorData];

        [BezierDigitAnimator setDrawControlLines:_drawControlLines];
        [BezierDigitAnimator setContinualAnimation:_continualAnimation];
        [BezierDigitAnimator setShowContinualShadows:_showContinualShadows];
        [BezierDigitAnimator setAnimationType:_animationType];
        [BezierDigitAnimator setLineColor:_lineColor];
        [BezierDigitAnimator setLineSize:_lineSize];

        _digits = [[NSArray alloc] initWithObjects:[[BezierDigit alloc] initWithDigit:0],
                                                   [[BezierDigit alloc] initWithDigit:1],
                                                   [[BezierDigit alloc] initWithDigit:2],
                                                   [[BezierDigit alloc] initWithDigit:3],
                                                   [[BezierDigit alloc] initWithDigit:4],
                                                   [[BezierDigit alloc] initWithDigit:5],
                                                   [[BezierDigit alloc] initWithDigit:6],
                                                   [[BezierDigit alloc] initWithDigit:7],
                                                   [[BezierDigit alloc] initWithDigit:8],
                                                   [[BezierDigit alloc] initWithDigit:9],
                                                   nil];

        int dist = 0;
        // In each the following, the ratio at which the numbers start
        // animating is calculated as the ratio of the pause time to the animation time.
        // The fact that they add up to the correct amt of seconds is just to make it easier to tweak.
        int yOff = 50;

        _hoursTensDigit    = [[BezierDigitAnimator alloc] init:0             origY:yOff pauseDuration:35995.0 animDuration:5.0];
        _hoursUnitsDigit   = [[BezierDigitAnimator alloc] init:(dist += 300) origY:yOff pauseDuration:35995.0 animDuration:5.0];
        _minutesTensDigit  = [[BezierDigitAnimator alloc] init:(dist += 500) origY:yOff pauseDuration:595.0   animDuration:5.0];
        _minutesUnitsDigit = [[BezierDigitAnimator alloc] init:(dist += 300) origY:yOff pauseDuration:55.0    animDuration:5.0];
        _secondsTensDigit  = [[BezierDigitAnimator alloc] init:(dist += 500) origY:yOff pauseDuration:5.0     animDuration:5.0];
        _secondsUnitsDigit = [[BezierDigitAnimator alloc] init:(dist += 300) origY:yOff pauseDuration:0.0     animDuration:1.0];

        //
        // Animation
        //
        [self setDisplayLink:[CADisplayLink displayLinkWithTarget:self
                                                         selector:@selector(setNeedsDisplay)]];
    }

    return self;
}


- (void)setDrawControlLines:(BOOL)on
{
    _drawControlLines = on;
    [BezierDigitAnimator setDrawControlLines:on];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:on forKey:@"drawControlLines"];
}

- (void)setContinualAnimation:(BOOL)on
{
    _continualAnimation = on;
    [BezierDigitAnimator setContinualAnimation:on];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:on forKey:@"setContinualAnimation"];
}

- (void)setShowContinualShadows:(BOOL)on
{
    _showContinualShadows = on;
    [BezierDigitAnimator setShowContinualShadows:on]
    ;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:on forKey:@"setShowContinualShadows"];
}

- (void)setAnimationType:(NSInteger)type
{
    _animationType = type;
    [BezierDigitAnimator setAnimationType:type];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:type forKey:@"animationType"];
}

- (void)setAnimDurationUser:(float)animDurationUser
{
    _animDurationUser = animDurationUser;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:animDurationUser forKey:@"animDurationUser"];
}

- (void)setLineColor:(UIColor *)color
{
    _lineColor = color;
    [BezierDigitAnimator setLineColor:color];

    NSUserDefaults *userDefaults  = [NSUserDefaults standardUserDefaults];
    NSData         *lineColorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [userDefaults setObject:lineColorData forKey:@"lineColor"];
}

- (void)setLineSize:(float)size
{
    _lineSize = size;
    [BezierDigitAnimator setLineSize:size];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:size forKey:@"lineSize"];
}

- (void)setBgColor:(UIColor *)backgroundColor
{
    _bgColor = backgroundColor;

    NSUserDefaults *userDefaults        = [NSUserDefaults standardUserDefaults];
    NSData         *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundColor];
    [userDefaults setObject:backgroundColorData forKey:@"backgroundColor"];
}

- (float)getAnimStartRatio:(float)totalDuration
{
    if ([self animDurationUser] > totalDuration)
    {
        return 0;
    }
    else
    {
        return 1.0 - ([self animDurationUser] / totalDuration);
    }
}

- (int)getNextInt:(int)current max:(int)max
{
    if (current >= max)
    {
        return 0;
    }
    else
    {
        return current + 1;
    }
}

//
// Drawing code
//
- (void)drawRect:(CGRect)rect
{
    //
    // Animation control
    //
    if (![self animationRunning])
    {
        [[self displayLink] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [self setAnimationRunning:YES];
        return;
    }

    if ([self lastDrawTime] == 0)
    {
        [self setLastDrawTime:[[self displayLink] timestamp]];
        return;
    }

    //
    // Always set bg color...
    //
    [self setBackgroundColor:[self bgColor]];

    //
    // Time display is about 2400x300. Scale so it fits...
    //
    CGContextRef ctx       = UIGraphicsGetCurrentContext();
    CGRect       bounds    = [self bounds];
    const float  scale     = bounds.size.width / 2400;
    const float  translate = (bounds.size.height / 2.0) / scale - 300;

    CGContextScaleCTM(ctx, scale, scale);
    CGContextTranslateCTM(ctx, 0, translate);

    //
    // Date
    //
    NSDate           *date       = [NSDate date];
    NSCalendar       *calendar   = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitNanosecond)
                                               fromDate:date];
    //
    // Seconds
    //
    int   millis           = (int)[components nanosecond] / 1000000;
    int   secondTotal      = (int)[components second];
    int   secondsUnit      = secondTotal % 10;
    int   secondsTen       = (secondTotal % 100 - secondTotal % 10) / 10;
    float secondsUnitRatio = millis / 1000.0;
    float secondsTenRatio  = (secondsUnit * 1000 + millis) / 10000.0;

    [[self secondsUnitsDigit] setAnimationStartRatio:[self getAnimStartRatio:1.0]];
    [[self secondsUnitsDigit] update:[[self digits] objectAtIndex:secondsUnit]
                                next:[[self digits] objectAtIndex:[self getNextInt:secondsUnit max:9]]
                               ratio:secondsUnitRatio];

    [[self secondsTensDigit] setAnimationStartRatio:[self getAnimStartRatio:10.0]];
    [[self secondsTensDigit] update:[[self digits] objectAtIndex:secondsTen]
                               next:[[self digits] objectAtIndex:[self getNextInt:secondsTen max:5]]
                              ratio:secondsTenRatio];

    //
    // Minutes
    //
    int   minuteTotal      = (int)[components minute];
    int   minutesUnit      = minuteTotal % 10;
    int   minutesTen       = (minuteTotal % 100 - minuteTotal % 10) / 10;
    float minutesUnitRatio = (secondTotal * 1000 + millis) / 60000.0;
    float mintuesTenRatio  = (minutesUnit * 60000 + secondTotal * 1000 + millis) / 600000.0;

    [[self minutesTensDigit] setAnimationStartRatio:[self getAnimStartRatio:600]];
    [[self minutesTensDigit] update:[[self digits] objectAtIndex:minutesTen]
                                next:[[self digits] objectAtIndex:[self getNextInt:minutesUnit max:5]]
                              ratio:mintuesTenRatio];

    [[self minutesUnitsDigit] setAnimationStartRatio:[self getAnimStartRatio:60]];
    [[self minutesUnitsDigit] update:[[self digits] objectAtIndex:minutesUnit]
                                next:[[self digits] objectAtIndex:[self getNextInt:minutesUnit max:9]]
                               ratio:minutesUnitRatio];
    //
    // Hours
    //
    int   hoursTotal     = (int)[components hour];
    int   hoursUnit      = hoursTotal % 10;
    int   hoursTen       = (hoursTotal % 100 - hoursTotal % 10) / 10;
    float hoursUnitRatio = (minuteTotal * 60000 + secondTotal * 1000 + millis) / 3600000.0;
    float hoursTenRatio;
    int   hoursUnitNext;

    if (hoursTen == 2 && hoursUnit == 3) {
        hoursUnitNext = 0;
        hoursTenRatio = (hoursUnit * 3600000 + minuteTotal * 60000 + secondTotal * 1000 + millis) / ( 4 * 3600000.0); // because only 20, 21, 22, 23 and not up to 29
        [[self hoursTensDigit] setAnimationStartRatio:[self getAnimStartRatio:3600 * 4]];

    } else {
        hoursUnitNext = [self getNextInt:hoursUnit max:9];
        hoursTenRatio = (hoursUnit * 3600000 + minuteTotal * 60000 + secondTotal * 1000 + millis) / 36000000.0;
        [[self hoursTensDigit] setAnimationStartRatio:[self getAnimStartRatio:3600 * 10]];

    }

    [[self hoursTensDigit] update:[[self digits] objectAtIndex:hoursTen]
                             next:[[self digits] objectAtIndex:[self getNextInt:hoursTen max:2]]
                            ratio:hoursTenRatio];

    [[self hoursUnitsDigit] setAnimationStartRatio:[self getAnimStartRatio:3600]];
    [[self hoursUnitsDigit] update:[[self digits] objectAtIndex:hoursUnit]
                              next:[[self digits] objectAtIndex:hoursUnitNext]
                             ratio:hoursUnitRatio];
}

@end
