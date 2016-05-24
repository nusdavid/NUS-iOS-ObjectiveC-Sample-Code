//
//  AppearanceManager.h
// Sample Code
//
//  Created by NUS Technology
//  Copyright (c) 2013 Sample Code, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppearanceManager : NSObject

+ (UIColor *)navigationBarTint;
+ (UIColor *)navigationBarItemTint;
+ (UIColor *)blueTextColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)tableCellBackgroundColor;
+ (UIColor *)borderColor;
+ (UIColor *)disableBackgroundColor;
+ (UIImageView *)navigationTitleImageView;
+ (UIFont *)boldAppFontOfSize:(CGFloat)fontSize;
+ (UIFont *)appFontOfSize:(CGFloat)fontSize;
+ (NSString *)bannerImageLocation;
+ (UIColor *)footerColor;
+ (UIColor *)selectedCellColor;
+ (void)setBasicAppearanceForViewController:(UIViewController *)vc;
+ (UIView *)addNoInternetConnectionViewInView:(UIView *)view;
+ (void)removeNoInternetConnectionView;
+ (UIFont *)lightAppFontOfSize:(CGFloat)fontSize;

@end
