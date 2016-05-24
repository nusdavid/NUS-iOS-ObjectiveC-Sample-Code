//
//  User+Helper.h
//  Sample Code
//
//  Created by NUS Technology on 1/13/15.
//  Copyright (c) 2015 Sample Code. All rights reserved.
//

#import "User.h"

@interface User (Helper)
- (id)init;
- (void)copyDataFromObject:(User*)source;

+ (NSString*)entityName;

+ (User*)fetchUser:(NSString*)recordId;
+ (NSArray *)saveLocalItems:(NSArray *)items;
+ (NSArray*) deleteUsers:(NSArray*)users;
@end
