//
//  BezierDigit.m
//  BezierClock
//
//  Translated from original code source: Jack Frigaard, http://jackf.net/bezier-clock/
//  by Philip Schneider on 1/1/15.
//  Copyright (c) 2015-2023 Code From Above, LLC. All rights reserved.
//

#import "BezierDigit.h"

@interface BezierDigit ()

@property (nonatomic, strong) NSArray *controls;

@end

@implementation BezierDigit

- (instancetype)initWithDigit:(int)digit
{
    //
    // Initializes the Bezier control points for the digits 0..9.
    // Curve is defined as a starting control point plus a sequence of
    // groups of three control points.
    //
    self = [super init];
    if (self)
    {
        switch (digit)
        {
            case 0:
            {
                _vertexX = 254.0;
                _vertexY = 47.0;
                _controls = [NSArray arrayWithObjects: @[@159.0, @84.0,  @123.0, @158.0, @131.0, @258.0],
                                                       @[@139.0, @358.0, @167.0, @445.0, @256.0, @446.0],
                                                       @[@345.0, @447.0, @369.0, @349.0, @369.0, @275.0],
                                                       @[@369.0, @201.0, @365.0, @81.0,  @231.0, @75.0], nil];
                break;
            }
            case 1:
            {
                _vertexX = 138.0;
                _vertexY = 180.0;
                _controls = [NSArray arrayWithObjects: @[@226.0, @99.0,  @230.0, @58.0,  @243.0, @43.0],
                                                       @[@256.0, @28.0,  @252.0, @100.0, @253.0, @167.0],
                                                       @[@254.0, @234.0, @254.0, @194.0, @255.0, @303.0],
                                                       @[@256.0, @412.0, @254.0, @361.0, @255.0, @424.0], nil];
                break;
            }
            case 2:
            {
                _vertexX = 104.0;
                _vertexY = 111.0;
                _controls = [NSArray arrayWithObjects: @[@152.0, @55.0,  @208.0, @26.0,  @271.0, @50.0],
                                                       @[@334.0, @74.0,  @360.0, @159.0, @336.0, @241.0],
                                                       @[@312.0, @323.0, @136.0, @454.0, @120.0, @405.0],
                                                       @[@104.0, @356.0, @327.0, @393.0, @373.0, @414.0], nil];
                break;
            }
            case 3:
            {
                _vertexX = 96.0;
                _vertexY = 132.0;
                _controls = [NSArray arrayWithObjects: @[@113.0, @14.0,  @267.0, @17.0,  @311.0, @107.0],
                                                       @[@355.0, @197.0, @190.0, @285.0, @182.0, @250.0],
                                                       @[@174.0, @215.0, @396.0, @273.0, @338.0, @388.0],
                                                       @[@280.0, @503.0, @110.0, @445.0, @93.0,  @391.0], nil];
                break;
            }
            case 4:
            {
                _vertexX = 374.0;
                _vertexY = 244.0;
                _controls = [NSArray arrayWithObjects: @[@249.0, @230.0, @192.0, @234.0, @131.0, @239.0],
                                                       @[@70.0,  @244.0, @142.0, @138.0, @192.0, @84.0],
                                                       @[@242.0, @30.0,  @283.0, @-30.0, @260.0, @108.0],
                                                       @[@237.0, @246.0, @246.0, @435.0, @247.0, @438.0], nil];
                break;
            }
            case 5:
            {
                _vertexX = 340.0;
                _vertexY = 52.0;
                _controls = [NSArray arrayWithObjects: @[@226.0, @42.0,  @153.0, @44.0,  @144.0, @61.0],
                                                       @[@135.0, @78.0,  @145.0, @203.0, @152.0, @223.0],
                                                       @[@159.0, @243.0, @351.0, @165.0, @361.0, @302.0],
                                                       @[@371.0, @439.0, @262.0, @452.0, @147.0, @409.0], nil];
                break;
            }
            case 6:
            {
                _vertexX = 301.0;
                _vertexY = 26.0;
                _controls = [NSArray arrayWithObjects: @[@191.0, @104.0, @160.0, @224.0, @149.0, @296.0],
                                                       @[@138.0, @368.0, @163.0, @451.0, @242.0, @458.0],
                                                       @[@321.0, @465.0, @367.0, @402.0, @348.0, @321.0],
                                                       @[@329.0, @240.0, @220.0, @243.0, @168.0, @285.0], nil];
                break;
            }
            case 7:
            {
                _vertexX = 108.0;
                _vertexY = 52.0;
                _controls = [NSArray arrayWithObjects: @[@168.0, @34.0,  @245.0, @42.0,  @312.0, @38.0],
                                                       @[@379.0, @34.0,  @305.0, @145.0, @294.0, @166.0],
                                                       @[@283.0, @187.0, @243.0, @267.0, @231.0, @295.0],
                                                       @[@219.0, @323.0, @200.0, @388.0, @198.0, @452.0], nil];
                break;
            }
            case 8:
            {
                _vertexX = 243.0;
                _vertexY = 242.0;
                _controls = [NSArray arrayWithObjects: @[@336.0, @184.0, @353.0, @52.0,  @240.0, @43.0],
                                                       @[@127.0, @34.0,  @143.0, @215.0, @225.0, @247.0],
                                                       @[@307.0, @279.0, @403.0, @427.0, @248.0, @432.0],
                                                       @[@93.0,  @437.0, @124.0, @304.0, @217.0, @255.0], nil];
                break;
            }
            case 9:
            {
                _vertexX = 322.0;
                _vertexY = 105.0;
                _controls = [NSArray arrayWithObjects: @[@323.0, @6.0,   @171.0, @33.0,  @151.0, @85.0],
                                                       @[@131.0, @137.0, @161.0, @184.0, @219.0, @190.0],
                                                       @[@277.0, @196.0, @346.0, @149.0, @322.0, @122.0],
                                                       @[@298.0, @95.0,  @297.0, @365.0, @297.0, @448.0], nil];
                break;
            }
        }
    }

    return self;
}

//
// Return the list of three control points for the specified "segment"
// of the Bezier curve for this digit.
//
- (NSArray *)getControl:(int)index
{
    return [[self controls] objectAtIndex:index];
}

@end
