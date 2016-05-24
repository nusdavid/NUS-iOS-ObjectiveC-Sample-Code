//
//  KNStoryboardManager.m
//  NUS Technology
//
//  Created by NUS Technology on 6/26/14.
//
//

#import "StoryboardManager.h"
#import "UserManager.h"
//#import "KNAppControlManager.h"
#import "Constants.h"

@implementation StoryboardManager


+(NSString*) getMainStoryboardName
{
    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
        return kMainStoryboardName_iPad;
    else
        return kMainStoryboardName_iPhone;
}

+ (UIViewController*)getViewControllerWithIdentifier:(NSString*)viewControllerIdentifier fromStoryboard:(NSString *)storyboardName{
    
    // Getting the storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    // get certain ViewController
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
    
    return vc;
}

+ (UIViewController*)getViewControllerInitial:(NSString *)storyboardName{

    // Getting the storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    // get instantiate initial view controller
    UIViewController *vc = storyboard.instantiateInitialViewController;
    
    return vc;
}

@end
