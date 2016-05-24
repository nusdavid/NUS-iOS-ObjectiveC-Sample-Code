//
//  UIImage+Compress.m
// Sample Code
//
//  Created by NUS Technology on 11/4/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)

- (NSData *)compressAuto:(UIImage *)original
{
    CGFloat scale = 1.0f;
    CGFloat maxScale = original.size.width;
    if (maxScale < original.size.height) {
        maxScale = original.size.height;
    }
    while (maxScale > 300) {
        scale = scale - 0.1f;
        maxScale = maxScale * scale;
    }
    return UIImageJPEGRepresentation(original, scale);
}

- (UIImage *)compressForUpload:(UIImage *)original scale:(CGFloat)scale
{
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

@end
