//
//  BezierDigit.h
//  BezierClock
//
//  Created by Philip Schneider on 1/1/15.
//  Copyright (c) 2015-2023 Code From Above, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BezierDigit : NSObject

@property (nonatomic, readonly) float vertexX;
@property (nonatomic, readonly) float vertexY;

- (instancetype)initWithDigit:(int)digit;
- (NSArray *)getControl:(int)index;

@end
