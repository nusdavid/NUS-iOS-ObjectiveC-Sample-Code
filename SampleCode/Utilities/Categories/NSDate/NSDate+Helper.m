//
//  NSDate+Helper.m
//
//  Created by NUS Technology on 8/6/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)
-(NSString *)getStringWithStringFormat:(NSString*)stringFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    
    //  @"yyyy MM dd HH:mm"]
    [dateFormatter setDateFormat :stringFormat];
    [dateFormatter setAMSymbol:@"am"];
    [dateFormatter setPMSymbol:@"pm"];
    NSString *dateString = [dateFormatter stringFromDate:self];
    
    return dateString;
}

-(NSDate *) toLocalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

-(NSDate *) toGlobalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

+ (int)calculateAge:(NSDate *)birthDate
{
    if (!birthDate) {
        return 0;
    }
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthDate
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    
    return (int)age;
}
@end
