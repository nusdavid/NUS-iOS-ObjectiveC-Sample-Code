//
//  KNBaseTableViewController.h
//
//  Created by NUS Technology on 8/18/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AppearanceManager.h"

@interface BaseTableViewController : UITableViewController
@property(nonatomic, strong) AppDelegate *appDelegate;
@property(nonatomic, strong) UIView *originTitleView;
@end
