//
//  Utilities.m
//  Sample Code
//
//  Created by NUS Technology on 8/23/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

#pragma mark - Shared Instance
+ (id)sharedInstance
{
    static Utilities *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Utilities alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Validation
// Check email is valid
- (BOOL)isValidEmail:(NSString *)email
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// Show an alert message
- (void)showOKMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:LOCALIZATION(@"ok")
                      otherButtonTitles:nil] show];
}


@end
