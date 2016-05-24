//
//  AppConfig.m
// Sample Code
//
//  Created by NUS Technology
//  Copyright (c) 2013 Sample Code, LLC. All rights reserved.
//

#import "AppConfig.h"

@interface AppConfig ()

@property (nonatomic, retain) NSDictionary *config;
@property (nonatomic, retain) NSString *env;

@end

@implementation AppConfig

+ (id)forKey:(NSString *)key
{
    return [[[self sharedConfig] config] objectForKey:key];
}

+ (id)sharedConfig
{
    static dispatch_once_t onceToken;
    static AppConfig *sharedConfig = nil;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[self alloc] init];
        [sharedConfig loadConfig];
    });
    return sharedConfig;
}

- (void)loadConfig
{
    self.env = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuration"];

    NSString *appConfigPath = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"];
    NSDictionary *appConfig = [NSDictionary dictionaryWithContentsOfFile:appConfigPath];

    NSMutableDictionary *envConfig = [[appConfig objectForKey:@"Default"] mutableCopy];
    [[appConfig objectForKey:self.env] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [envConfig setObject:obj forKey:key];
    }];

    self.config = [envConfig copy];
}

@end
