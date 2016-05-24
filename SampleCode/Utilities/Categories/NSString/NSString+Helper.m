//
//  NSString+Number.m
//
//  Created by NUS Technology on 8/6/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import "NSString+Helper.h"
#import "NSDate+Helper.h"
#import "Constants.h"

@implementation NSString (Helper)
-(NSNumber *)getNumberWithDecimalSeperator:(NSString*)decimalSeperator{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.decimalSeparator = decimalSeperator;
    
    return [formatter numberFromString:self];
}

-(NSDate *)getDatewithStringFormat:(NSString*)stringFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //  @"yyyy MM dd HH:mm"]
    [dateFormatter setDateFormat :stringFormat];
    
    NSDate *dateTime = [dateFormatter dateFromString:self];
    
    return dateTime;
}

-(BOOL)isEmptyString{
    
    NSString *rawString = [self copy];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        
        // Text was empty or only whitespace.
        return true;
    }
    
    return false;
}

-(NSString *)includeZeroPaddingInPrefix:(NSInteger)wholeNumberLenght{
    
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
    [numberFormatter setPaddingCharacter:@"0"];
    [numberFormatter setMinimumIntegerDigits:wholeNumberLenght];
    
    NSNumber * number = [NSNumber numberWithInt:[self intValue]];
    
    NSString * theString = [numberFormatter stringFromNumber:number];
    
    return theString;
}

-(NSString *) toLocalTime{
    
    // Convert parking time to Local date
    NSDate *processDate = [self getDatewithStringFormat:kInputDateFormat];
    
    NSDate *localDate = [processDate toLocalTime];
    
    return [localDate getStringWithStringFormat:kInputDateFormat];
}

-(NSString *) toGlobalTime{
    
    // Convert parking time to GMT + 0000
    NSDate *processDate = [self getDatewithStringFormat:kInputDateFormat];
    
    NSDate *globalDate = [processDate toGlobalTime];
    
    return [globalDate getStringWithStringFormat:kInputDateFormat];
}

+ (UIImage *)generateQRCode:(NSString *)qRCodeText {
    
    // Get the string
    NSString *stringToEncode = qRCodeText;
    
    // Generate the image
    CIImage *qrCode = [self createQRForString:stringToEncode];
    
    // Convert to an UIImage
    UIImage *qrCodeImg = [self createNonInterpolatedUIImageFromCIImage:qrCode withScale:2*[[UIScreen mainScreen] scale]];
    
    // Send the image back
    return qrCodeImg;
}

#pragma mark - private methods
+ (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"L" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}

+ (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return scaledImage;
}

+ (NSString *)getStringWithoutNull:(NSString *)input
{
    if (input == NULL || [input isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return input;
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isValidEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}


@end
