//
//  NUS TechnologyLocalizations.h
//
//  Created by NUS Technology on 4/25/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOCALIZATION(text) [[Localizations sharedInstance] localizedStringForKey:(text)]
#define CURRENT_LANGUAGE   [[Localizations sharedInstance] getCurrentLanguage]
#define ENGLISH         @"en"
#define DEFAULT         @"Default"

static NSString * const notificationLanguageChanged = @"notificationLanguageChanged";


@interface Localizations : NSObject

@property (nonatomic, readonly) NSArray* availableLanguagesArray;
@property (nonatomic, assign) BOOL saveInUserDefaults;
@property NSString * currentLanguage;

+ (Localizations *) sharedInstance;
- (NSString *)getCurrentLanguage;
- (NSString *)localizedStringForKey:(NSString*)key;
- (BOOL)setLanguage:(NSString*)newLanguage;

@end
