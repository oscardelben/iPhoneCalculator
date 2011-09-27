//
//  AppDelegate.h
//  iPhoneCalculator
//
//  Created by Oscar Del Ben on 9/27/11.
//  Copyright (c) 2011 Fructivity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CalculatorViewController *viewController;

@end
