//
//  UIImage+Compress.h
//
//  Created by NUS Technology on 11/4/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)

- (NSData *)compressAuto:(UIImage *)original;
- (UIImage *)compressForUpload:(UIImage *)original scale:(CGFloat)scale;

@end
