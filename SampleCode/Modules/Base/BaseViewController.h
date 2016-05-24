//
//  KNBaseViewController.h
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//
// Interface of base view controller.
//
// Add cusomization for all of view controller,

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AppearanceManager.h"

@interface BaseViewController : UIViewController

@property(nonatomic, strong) AppDelegate *appDelegate;
@property(nonatomic, strong) UIView *originTitleView;

@end
