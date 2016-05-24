//
//  AppConfig.h
// Sample Code
//
//  Created by NUS Technology
//  Copyright (c) 2013 Sample Code, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject

+ (id)forKey:(NSString *)key;
+ (id)sharedConfig;

@end
