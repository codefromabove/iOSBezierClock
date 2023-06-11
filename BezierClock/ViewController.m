//
//  ViewController.m
//  BezierClock
//
//  Created by Philip Schneider on 12/31/14.
//  Copyright (c) 2014-2023 Code From Above, LLC. All rights reserved.
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

    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithDefaultBackground];
        UINavigationBar.appearance.standardAppearance = appearance;
        UINavigationBar.appearance.compactAppearance = appearance;
        UINavigationBar.appearance.scrollEdgeAppearance = appearance;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
    UINavigationController *nav = (UINavigationController *)[segue destinationViewController];

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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [[self bcView] setTransitioning:YES];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        // do whatever
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        [[self bcView] setTransitioning:NO];
    }];

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


@end
