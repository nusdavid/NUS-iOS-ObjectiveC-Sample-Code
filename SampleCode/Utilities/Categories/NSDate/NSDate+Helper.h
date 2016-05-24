//
//  NSDate+Helper.h
//
//  Created by NUS Technology on 8/6/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)
-(NSString *)getStringWithStringFormat:(NSString*)stringFormat;

-(NSDate *) toLocalTime;

-(NSDate *) toGlobalTime;

+ (int)calculateAge:(NSDate *)birthDate;
@end
