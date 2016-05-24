//
//  NSString+Number.h
//
//  Created by NUS Technology on 8/6/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)
-(NSNumber *)getNumberWithDecimalSeperator:(NSString*)decimalSeperator;

-(NSDate *)getDatewithStringFormat:(NSString*)stringFormat;

-(BOOL)isEmptyString;

-(NSString *)includeZeroPaddingInPrefix:(NSInteger)wholeNumberLenght;

-(NSString *) toLocalTime;

-(NSString *) toGlobalTime;

+ (UIImage *)generateQRCode:(NSString *)qRCodeText;
+ (NSString *)getStringWithoutNull:(NSString *)input;
- (NSString *)trim;
- (BOOL)isValidEmail;
@end
