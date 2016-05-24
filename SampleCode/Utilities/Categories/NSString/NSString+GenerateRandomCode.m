//
//  NSString+GenerateRandomCode.m
//
//  Created by NUS Technology on 8/4/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import "NSString+GenerateRandomCode.h"

@implementation NSString (GenerateRandomCode)
+ (NSString*) generateRandomCode:(NSInteger)length{
    NSMutableString *returnString = [NSMutableString stringWithCapacity:length];
    
    NSString *numbers = @"0123456789";
    
    // First number cannot be 0
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
    
    for (int i = 1; i < length; i++)
    {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
    
    return returnString;
}
@end
