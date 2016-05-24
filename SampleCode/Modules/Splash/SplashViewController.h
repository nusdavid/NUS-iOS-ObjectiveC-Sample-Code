//
//  KNSplashTemplateViewController.h
//  NUS Technology
//
//  Created by NUS Technology on 6/26/14.
//
//
// Splash template
#import "BaseViewController.h"

@interface SplashViewController : BaseViewController


// next view controller Id.
@property(nonatomic, strong) NSString *viewControllerIdForNext;

// next Storyboard name.
@property(nonatomic, strong) NSString *storyboardNameForNext;


// Splash Time to live
@property(nonatomic, assign) CGFloat timeToLive;



@end
