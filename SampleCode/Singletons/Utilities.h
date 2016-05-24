//
//  Utilities.h
//  Sample Code
//
//  Created by NUS Technology on 8/23/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+ (id)sharedInstance;
- (BOOL)isValidEmail:(NSString *)email;
- (void)showOKMessage:(NSString *)text withTitle:(NSString *)title;

@end
