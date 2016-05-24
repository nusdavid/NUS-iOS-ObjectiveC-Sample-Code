//
//  KNSplashTemplateViewController.m
//  NUS Technology
//
//  Created by NUS Technology on 6/26/14.
//
//

#import "SplashViewController.h"
#import "Constants.h"

@interface SplashViewController ()

@property(nonatomic,strong) NSTimer * timerSplashKill;

@end

@implementation SplashViewController
{
    CGFloat accumlateTime;
}
- (id) init
{
    self = [super init];
    if ( self ){
        self.timeToLive = kDefaultTimeToLiveSplash;        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.timeToLive = kDefaultTimeToLiveSplash;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        self.timeToLive = kDefaultTimeToLiveSplash;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShouldCloseSplash:) name:kApplicationLoadFinished object:nil];
    self.timerSplashKill = [NSTimer scheduledTimerWithTimeInterval:kTimerIntervalSplash target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    
    accumlateTime = 0;
    
    self.viewControllerIdForNext = kSignInViewControllerId;
    self.storyboardNameForNext = kSecurityStoreyboard;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kApplicationLoadFinished object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - timer
- (void) onTimer:(id)sender
{
    accumlateTime += kTimerIntervalSplash;
    if ( accumlateTime >=self.timeToLive ){ // Timer expired
        [self.timerSplashKill invalidate];
        self.timerSplashKill = nil;
        [self goNext:nil];
    }
}

#pragma mark - Notifications

- (void) onShouldCloseSplash:(NSNotification*) notification
{
    [self goNext:notification];
}

#pragma mark - Actions
- (void) goNext:(id)sender
{
    if ( self.timerSplashKill )
    {
        [self.timerSplashKill invalidate];
        self.timerSplashKill = nil;
    }
    
    //sign in automatically
    APIClient *myClient = [APIClient sharedInstance];
    if ([[UserManager sharedInstance] currentUser]) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [myClient authorizeWithKeychain:^(BOOL successful) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (successful) {
                
                // Go to home view
                self.storyboardNameForNext = kMainStoreyboard;
                self.viewControllerIdForNext = kHomeViewControllerId;
                
                // get next view controller
                self.viewControllerIdForNext = kSignInViewControllerId;
                self.storyboardNameForNext = kSecurityStoreyboard;
                [self goToNextView];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (!myClient.isConnected) {
                
                NSString *errorMessage = error.localizedDescription;
                NSString *msgTitle = LOCALIZATION(@"Error");
                [[[UIAlertView alloc] initWithTitle: msgTitle
                                            message: errorMessage
                                           delegate: nil
                                  cancelButtonTitle: LOCALIZATION(@"OK")
                                  otherButtonTitles: nil]
                 show];
            }
            
            // get next view controller
            self.viewControllerIdForNext = kSignInViewControllerId;
            self.storyboardNameForNext = kSecurityStoreyboard;
            
            [self goToNextView];
        }];
    }else{
    
        // get next view controller
        self.viewControllerIdForNext = kSignInViewControllerId;
        self.storyboardNameForNext = kSecurityStoreyboard;
        
        [self goToNextView];
    }
}

- (void) goToNextView{

    UIViewController *VC = [StoryboardManager getViewControllerWithIdentifier:self.viewControllerIdForNext fromStoryboard:self.storyboardNameForNext];
    
    [self.appDelegate.window setRootViewController:VC];
}
@end
