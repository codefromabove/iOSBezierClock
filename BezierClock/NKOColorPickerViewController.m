//
//  NKOColorPickerViewController.m
//  BezierClock
//
//  Created by Philip Schneider on 12/22/19.
//  Copyright © 2019-2026 Code From Above, LLC. All rights reserved.
//

#import "NKOColorPickerViewController.h"
#import "DisplayOptionsViewController.h"

@interface NKOColorPickerViewController ()

@end

@implementation NKOColorPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // The color picker retains its block, so capture self weakly to avoid a retain cycle.
    __weak typeof(self) weakSelf = self;

    if ([self editMode] == kLineColorEditMode) {
        UIColor *lineColor = [[self bcView] lineColor];
        [self.colorPicker setColor:lineColor];
        [self.colorPicker setDidChangeColorBlock:^(UIColor *color)
        {
            [weakSelf.displayOptionsViewController setLineSwatchColor:color];
            [[weakSelf bcView] setLineColor:color];
        }];
    }
    else {
        UIColor *backgroundColor = [[self bcView] bgColor];
        [self.colorPicker setColor:backgroundColor];
        [self.colorPicker setDidChangeColorBlock:^(UIColor *color)
        {
            [weakSelf.displayOptionsViewController setBackgroundSwatchColor:color];
            [[weakSelf bcView] setBgColor:color];
        }];
    }
}

@end
