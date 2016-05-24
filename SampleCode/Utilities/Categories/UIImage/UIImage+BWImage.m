//
//  UIImage+BWImage.m
//  Created by NUS Technology on 03/09/2013.
//  Copyright (c) 2013 Sample Code. All rights reserved.

#import "UIImage+BWImage.h"

@implementation UIImage (BWImage)
-(UIImage *)bwImage
{
    UIImage *originalImage = self;
    
    CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, originalImage.size.width, originalImage.size.height, 8, originalImage.size.width, colorSapce, kCGImageAlphaNone & kCGImageAlphaPremultipliedFirst);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, originalImage.size.width, originalImage.size.height), [originalImage CGImage]);
    
    CGImageRef bwImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSapce);
    
    UIImage *resultImage = [UIImage imageWithCGImage:bwImage]; // This is result B/W image.
    CGImageRelease(bwImage);
    return  resultImage;
}
@end
