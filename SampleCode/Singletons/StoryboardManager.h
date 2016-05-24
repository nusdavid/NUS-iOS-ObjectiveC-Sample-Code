//
//  KNStoryboardManager.h
//  NUS Technology
//
//  Created by NUS Technology on 6/26/14.
//
//
// Manager to control storyboard
#import <Foundation/Foundation.h>

@interface StoryboardManager : NSObject

// Get main storyboard name based on device
+(NSString*) getMainStoryboardName;

+(UIViewController*)getViewControllerWithIdentifier:(NSString*)viewControllerIdentifier fromStoryboard:(NSString *)storyboardName;

+(UIViewController*)getViewControllerInitial:(NSString *)storyboardName;
@end
