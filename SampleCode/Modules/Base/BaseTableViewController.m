//
//  KNBaseTableViewController.m
//
//  Created by NUS Technology on 8/18/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Constants.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set font and style for navigation item title
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary
      dictionaryWithObjectsAndKeys:
      [AppearanceManager navigationBarItemTint], NSForegroundColorAttributeName,
      [UIFont fontWithName:kCondensedBoldFontName size:kBigFontSize], NSFontAttributeName, nil]];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     [NSDictionary
      dictionaryWithObjectsAndKeys:
      [AppearanceManager navigationBarItemTint], NSForegroundColorAttributeName,
      [UIFont fontWithName:kLightFontName size:kDefaultFontSize], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    // Set disabled status
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     [NSDictionary
      dictionaryWithObjectsAndKeys:
      [UIColor grayColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:kLightFontName size:kDefaultFontSize], NSFontAttributeName, nil] forState:UIControlStateDisabled];
    
    [[UIBarButtonItem appearance] setTintColor:[AppearanceManager navigationBarItemTint]];
    
    self.navigationController.navigationBar.tintColor = [AppearanceManager navigationBarItemTint];
    
    // Set title of Back button to empty
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    
    [self.navigationController.navigationBar setBarTintColor:[AppearanceManager navigationBarTint]];

    
    // Set background color for view
    self.view.backgroundColor = [AppearanceManager backgroundColor];
    
    // Set Title View
    self.originTitleView = self.navigationItem.titleView;
    self.navigationItem.titleView = [AppearanceManager navigationTitleImageView];
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    [self connectionStatusChanged:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self connectionStatusChanged:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

#pragma mark - offline view
-(void)connectionStatusChanged:(NSNotification *)note{
    APIClient *myClient = [APIClient sharedInstance];
    
    if (myClient.isConnected) {
        
        [AppearanceManager removeNoInternetConnectionView];
    }else{
        
        [AppearanceManager addNoInternetConnectionViewInView:self.view];
    }
}

@end
