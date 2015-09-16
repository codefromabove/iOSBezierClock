//
//  DisplayOptionsViewController.m
//  BezierClock
//
//  Created by Philip Schneider on 1/2/15.
//  Copyright (c) 2015 Code From Above, LLC. All rights reserved.
//
#import "DisplayOptionsViewController.h"
#import "BezierClockView.h"
#import "NKOColorPickerView.h"

@interface DisplayOptionsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *showLinesOutlet;
@property (weak, nonatomic) IBOutlet UISwitch *continuousAnimationOutlet;
@property (weak, nonatomic) IBOutlet UISwitch *continuousShadowsOutlet;
@property (weak, nonatomic) IBOutlet UIButton *backgroundColorSwatchOutlet;
@property (weak, nonatomic) IBOutlet UIButton *lineColorSwatchOutlet;
@property (weak, nonatomic) IBOutlet UISlider *lineSizeOutlet;

@end

@implementation DisplayOptionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //
    // Update UI to current values in the BezierCurveView
    //
    [[self showLinesOutlet]             setOn:[[self bcView] drawControlLines]];
    [[self continuousAnimationOutlet]   setOn:[[self bcView] continualAnimation]];
    [[self continuousShadowsOutlet]     setOn:[[self bcView] showContinualShadows]];

    [[self backgroundColorSwatchOutlet] setBackgroundColor:[[self bcView] bgColor]];
    [[self lineColorSwatchOutlet]       setBackgroundColor:[[self bcView] lineColor]];

    [[self lineSizeOutlet]              setMinimumValue:0.125];
    [[self lineSizeOutlet]              setMaximumValue:8.0];
    [[self lineSizeOutlet]              setValue:[[self bcView] lineSize]];

    //
    // Add a little border, so if the color is the same as the view's background,
    // it can be seen as an image swatch...
    //
    [[[self backgroundColorSwatchOutlet] layer] setBorderWidth:2.0];
    [[[self backgroundColorSwatchOutlet] layer] setBorderColor:[[UIColor colorWithRed:0.888
                                                                                green:0.888
                                                                                 blue:0.888
                                                                                alpha:1.0] CGColor]];
    [[[self lineColorSwatchOutlet] layer] setBorderWidth:2.0];
    [[[self lineColorSwatchOutlet] layer] setBorderColor:[[UIColor colorWithRed:0.888
                                                                          green:0.888
                                                                           blue:0.888
                                                                          alpha:1.0] CGColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *nav = (UINavigationController *)[segue destinationViewController];

    //
    // Update color picker to current BezierCurveView values, and assign block to
    // be called when color picker returns.
    //
    if ([[segue identifier] isEqualToString:@"BackgroundColorPickerSegue"])
    {
        NKOColorPickerView *cpView = (NKOColorPickerView *)[[nav topViewController] view];
        [cpView setColor:[[self bcView] backgroundColor]];
        [cpView setDidChangeColorBlock:^(UIColor *color)
        {
            [[self backgroundColorSwatchOutlet] setBackgroundColor:color];
            [[self bcView] setBgColor:color];
        }];
    }
    else if ([[segue identifier] isEqualToString:@"LineColorPickerSegue"])
    {
        NKOColorPickerView *cpView = (NKOColorPickerView *)[[nav topViewController] view];
        [cpView setColor:[[self bcView] lineColor]];
        [cpView setDidChangeColorBlock:^(UIColor *color)
        {
            [[self lineColorSwatchOutlet] setBackgroundColor:color];
            [[self bcView] setLineColor:color];
        }];
    }
}

- (IBAction)myUnwindAction:(UIStoryboardSegue*)unwindSegue
{
    
}

- (IBAction)showLinesAction:(id)sender
{
    [[self bcView] setDrawControlLines:[[self showLinesOutlet] isOn]];
}

- (IBAction)continuousAnimationAction:(id)sender
{
    [[self bcView] setContinualAnimation:[[self continuousAnimationOutlet] isOn]];
}

- (IBAction)continuousShadowsAction:(id)sender
{
    [[self bcView] setShowContinualShadows:[[self continuousShadowsOutlet] isOn]];
}

- (IBAction)lineSizeAction:(id)sender
{
    [[self bcView] setLineSize:[[self lineSizeOutlet] value]];
}

- (IBAction)doneAction:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
