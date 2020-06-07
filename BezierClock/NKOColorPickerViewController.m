//
//  NKOColorPickerViewController.m
//  BezierClock
//
//  Created by Philip Schneider on 12/22/19.
//  Copyright © 2019-2020 Code From Above, LLC. All rights reserved.
//

#import "NKOColorPickerViewController.h"
#import "DisplayOptionsViewController.h"

@interface NKOColorPickerViewController ()

@end

@implementation NKOColorPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self editMode] == kLineColorEditMode) {
        UIColor *lineColor = [[self bcView] lineColor];
        [self.colorPicker setColor:lineColor];
        [self.colorPicker setDidChangeColorBlock:^(UIColor *color)
        {
            [self.displayOptionsViewController setLineSwatchColor:color];
            [[self bcView] setLineColor:color];
        }];
    }
    else {
        UIColor *backgroundColor = [[self bcView] backgroundColor];
        [self.colorPicker setColor:backgroundColor];
        [self.colorPicker setDidChangeColorBlock:^(UIColor *color)
        {
            [self.displayOptionsViewController setBackgroundSwatchColor:color];
            [[self bcView] setBgColor:color];
        }];
    }
}

@end
