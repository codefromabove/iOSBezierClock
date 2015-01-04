//
//  AnimationOptionsViewController.m
//  BezierClock
//
//  Created by Philip Schneider on 1/2/15.
//  Copyright (c) 2015 Code From Above, LLC. All rights reserved.
//
#import "AnimationOptionsViewController.h"
#import "BezierClockView.h"

@interface AnimationOptionsViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray *pickerData;
}

@property (weak, nonatomic) IBOutlet UILabel      *animationDurationValueOutlet;
@property (weak, nonatomic) IBOutlet UIStepper    *animationDurationControlOutlet;
@property (weak, nonatomic) IBOutlet UIPickerView *animationTypePickerOutlet;

@end

@implementation AnimationOptionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //
    // Animation type
    //
    pickerData = @[@"Linear", @"Quadratic", @"Cubic", @"Sinusoidal"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //
    // Animation type
    //
    [[self animationTypePickerOutlet] setDataSource:self];
    [[self animationTypePickerOutlet] setDelegate:self];
    [[self animationTypePickerOutlet] selectRow:[[self bcView] animationType] - 1
                                    inComponent:0
                                       animated:NO];

    //
    // Animation duration
    //
    [[self animationDurationValueOutlet]   setText:[NSString stringWithFormat:@"%1.2f", [[self bcView] animDurationUser]]];
    [[self animationDurationControlOutlet] setValue:[[self bcView] animDurationUser]];
    [[self animationDurationControlOutlet] setStepValue:0.05];
    [[self animationDurationControlOutlet] setMinimumValue:0.0];
    [[self animationDurationControlOutlet] setMaximumValue:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

/*

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneAction:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

#pragma mark - Animation Type

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[self bcView] setAnimationType:(int)row + 1];
}

#pragma mark - Animation Duration

- (IBAction)animationDurationControlAction:(id)sender
{
    [[self bcView] setAnimDurationUser:[[self animationDurationControlOutlet] value]];
    [[self animationDurationValueOutlet] setText:[NSString stringWithFormat:@"%1.2f", [[self bcView] animDurationUser]]];
}

@end