//
//  NKOColorPickerViewController.h
//  BezierClock
//
//  Created by Philip Schneider on 12/22/19.
//  Copyright © 2019-2023 Code From Above, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKOColorPickerView.h"
#import "BezierClockView.h"

@class DisplayOptionsViewController;

typedef NS_ENUM(NSInteger, ColorPickerEditMode) {
    kBackgroundColorEditMode,
    kLineColorEditMode
};

NS_ASSUME_NONNULL_BEGIN

@interface NKOColorPickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet NKOColorPickerView  *colorPicker;
@property (weak, nonatomic)          BezierClockView     *bcView;
@property (assign, nonatomic)        ColorPickerEditMode  editMode;

@property (weak, nonatomic)          DisplayOptionsViewController *displayOptionsViewController;

@end

NS_ASSUME_NONNULL_END
