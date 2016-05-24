//
//  UserManager.h
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//
// Manager of current user info
#import <Foundation/Foundation.h>
#import "User+Helper.h"

@interface UserManager : NSObject

// Get singleton instance
+ (UserManager*)sharedInstance;

- (User *)currentUser;

@end
