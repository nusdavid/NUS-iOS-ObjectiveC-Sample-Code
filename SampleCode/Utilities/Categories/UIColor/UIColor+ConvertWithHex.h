//
//  UIColor+ConvertWithHex.h
//
//  Created by NUS Technology on 10/21/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ConvertWithHex)
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (NSString *)hexStringFromUIColor:(UIColor *)color;
@end
