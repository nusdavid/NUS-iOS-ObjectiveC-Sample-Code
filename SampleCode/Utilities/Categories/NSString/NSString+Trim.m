//
//  NSString(Trim).m
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//

#import "NSString+Trim.h"

@implementation NSString (Trim)

- (NSString*) trimPhoneNumber
{
    NSString * retPhoneNumber = self;
    
    NSArray *components = [retPhoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    
    retPhoneNumber = [components componentsJoinedByString:@""];
    retPhoneNumber=[retPhoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    retPhoneNumber=[retPhoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    retPhoneNumber=[retPhoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    retPhoneNumber=[retPhoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    return retPhoneNumber;
}

@end
