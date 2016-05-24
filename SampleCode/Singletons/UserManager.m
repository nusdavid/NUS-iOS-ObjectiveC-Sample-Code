//
//  UserManager.m
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//

@implementation UserManager

+ (UserManager*)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return (UserManager*)sharedInstance;
}

- (User *)currentUser{

    NSString *accessToken = [UICKeyChainStore stringForKey:kKeychainAccessToken];
    if (accessToken == nil || [accessToken isEqualToString:@""]) {
        return nil;
    }
    
    NSString *userId = [UICKeyChainStore stringForKey:kKeyChainUserId];
    
    User *u = [User fetchUser:userId];
    
    return u;
}
@end
