//
//  NUS TechnologyLocalizations.m
//
//  Created by NUS Technology on 4/25/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import "Localizations.h"

static NSString * const saveLanguageDefaultKey = @"saveLanguageDefaultKey";

@interface Localizations()

@property NSDictionary * dicoLocalisation;
@property NSUserDefaults * defaults;

@end

@implementation Localizations

#pragma  mark - Singleton Method

+ (Localizations *)sharedInstance
{
    static Localizations *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Localizations alloc] init];
    });
    return _sharedInstance;
}


#pragma mark - Init Method

- (id)init
{
    self = [super init];
    if (self)
    {
        _defaults                       = [NSUserDefaults standardUserDefaults];
        _availableLanguagesArray        = @[DEFAULT, ENGLISH];
        _dicoLocalisation               = nil;
        
        _currentLanguage                = DEFAULT;
        
        NSString * languageSaved = [_defaults objectForKey:saveLanguageDefaultKey];
        
        if (languageSaved != nil && ![languageSaved isEqualToString:DEFAULT])
        {
            [self loadDictionaryForLanguage:languageSaved];
        }
    }
    return self;
}


#pragma mark - Get Current Language

- (NSString *)getCurrentLanguage
{
    return _currentLanguage;
}


#pragma mark - saveInIUserDefaults custom accesser/setter

- (BOOL)saveInUserDefaults
{
    return ([self.defaults objectForKey:saveLanguageDefaultKey] != nil);
}

- (void)setSaveInUserDefaults:(BOOL)saveInUserDefaults
{
    if (saveInUserDefaults)
    {
        [self.defaults setObject:_currentLanguage forKey:saveLanguageDefaultKey];
    }
    else
    {
        [self.defaults removeObjectForKey:saveLanguageDefaultKey];
    }
    [self.defaults synchronize];
}


#pragma mark - Private  Instance methods

- (BOOL)loadDictionaryForLanguage:(NSString *)newLanguage
{
    NSURL * urlPath = [[NSBundle bundleForClass:[self class]] URLForResource:@"Localizable" withExtension:@"strings" subdirectory:nil localization:newLanguage];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:urlPath.path])
    {
        self.currentLanguage = [newLanguage copy];
        self.dicoLocalisation = [[NSDictionary dictionaryWithContentsOfFile:urlPath.path] copy];
        
        return YES;
    }
    return NO;
}


#pragma mark - Public Instance methods

- (NSString *)localizedStringForKey:(NSString*)key
{
    if (self.dicoLocalisation == nil)
    {
        return NSLocalizedString(key, key);
    }
    else
    {
        NSString * localizedString = self.dicoLocalisation[key];
        if (localizedString == nil)
            localizedString = key;
        return localizedString;
    }
}


- (BOOL)setLanguage:(NSString *)newLanguage
{
    if (newLanguage == nil || [newLanguage isEqualToString:self.currentLanguage] || ![self.availableLanguagesArray containsObject:newLanguage])
        return NO;
    
    if ([newLanguage isEqualToString:DEFAULT])
    {
        self.currentLanguage = [newLanguage copy];
        self.dicoLocalisation = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationLanguageChanged
                                                            object:nil];
        return YES;
    }
    else
    {
        BOOL isLoadingOk = [self loadDictionaryForLanguage:newLanguage];
        
        if (isLoadingOk)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationLanguageChanged
                                                                object:nil];
            if ([self saveInUserDefaults])
            {
                [self.defaults setObject:_currentLanguage forKey:saveLanguageDefaultKey];
                [self.defaults synchronize];
            }
        }
        return isLoadingOk;
    }
}

@end
