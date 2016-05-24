//
//  AppDelegate.h
//  Sample Code
//
//  Created by NUS Technology on 12/1/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

// LoginViewControllerDelegate
@protocol LoginViewControllerDelegate <NSObject>

- (void)didLogin;
- (void)didLogout;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, LoginViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

