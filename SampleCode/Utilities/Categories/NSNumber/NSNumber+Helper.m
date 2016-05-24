//
//  NSNumber+Helper.m
//
//  Created by NUS Technology on 8/6/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import "NSNumber+Helper.h"

@implementation NSNumber (Helper)
-(NSString *)getString{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    formatter.minimumFractionDigits = 2;
    formatter.maximumFractionDigits = 2;
    formatter.usesSignificantDigits = NO;
    formatter.usesGroupingSeparator = YES;
    formatter.groupingSeparator = @",";
    formatter.decimalSeparator = @".";
    
    return [formatter stringFromNumber:self];
}

-(NSString *)getStringValueWithMaxDecimalLength:(NSInteger)decimalLenght{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = decimalLenght;
    formatter.usesSignificantDigits = NO;
    formatter.usesGroupingSeparator = YES;
    formatter.groupingSeparator = @",";
    formatter.decimalSeparator = @".";
    
    return [formatter stringFromNumber:self];
}
@end
