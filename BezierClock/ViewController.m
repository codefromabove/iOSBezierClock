//
//  ViewController.m
//  BezierClock
//
//  Created by Philip Schneider on 12/31/14.
//  Copyright (c) 2014 Code From Above, LLC. All rights reserved.
//
#import "ViewController.h"
#import "BezierClockView.h"
#import "DisplayOptionsViewController.h"
#import "AnimationOptionsViewController.h"

@interface ViewController ()

@property (nonatomic, strong) BezierClockView *bcView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setBcView:[[BezierClockView alloc] initWithFrame:[[self view] bounds]]];
    [[self view] addSubview:_bcView];

    [[self bcView] setAutoresizesSubviews:YES];
    [[self bcView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //
    // Controllers are embedded in nav controllers
    // Hand them a ref to the BezierClockView
    //
    UINavigationController *nav  = (UINavigationController *)[segue destinationViewController];

    if ([[segue identifier] isEqualToString:@"DisplayOptionsSegue"])
    {
        DisplayOptionsViewController *doVC = (DisplayOptionsViewController *)[nav topViewController];
        [doVC setBcView:[self bcView]];
    }
    else if ([[segue identifier] isEqualToString:@"AnimationOptionsSegue"])
    {
        AnimationOptionsViewController *aoVC = (AnimationOptionsViewController *)[nav topViewController];
        [aoVC setBcView:[self bcView]];
    }
}

@end
