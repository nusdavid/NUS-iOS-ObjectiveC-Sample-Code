//
//  AppearanceManager.m
// Sample Code
//
//  Created by NUS Technology
//  Copyright (c) 2013 Sample Code, LLC. All rights reserved.
//

#import "AppearanceManager.h"
#import "UIColor+ConvertWithHex.h"
#import "NoInternetConnectionView.h"
#import "Constants.h"

@implementation AppearanceManager{
    
}

NoInternetConnectionView *noInternetConnectionView;

+ (UIColor *)navigationBarTint
{
    return [UIColor colorWithRed:0/255.0 green:142/255.0 blue:207/255.0 alpha:1.0];
}

+ (UIColor *)navigationBarItemTint
{
    return [UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0];
}

+ (UIColor *)blueTextColor
{
    return [UIColor colorWithRed:0/255.0 green:172/255.0 blue:215/255.0 alpha:1.0];
}

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithRed:19.0/255.0 green:151.0/255.0 blue:198.0/255.0 alpha:1];
}

+ (UIColor *)tableCellBackgroundColor{
    return [UIColor colorWithRed:227/255.0 green:226/255.0 blue:232/255.0 alpha:1.0];
}

+ (UIColor *)borderColor
{
    return [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1.0];
}

+ (UIColor *)disableBackgroundColor{
    return [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
}

+ (UIImageView *)navigationTitleImageView
{
    return [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_icon"]];
}

+ (UIFont *)boldAppFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
}

+ (UIFont *)appFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
}

+ (UIFont *)lightAppFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
}

+ (UIColor *)footerColor
{
    return [UIColor colorWithHexString:@"#EBEAF1"];
}

+ (NSString *)bannerImageLocation
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"bannerImage.jpg"];
}

+ (UIColor *)selectedCellColor
{
    return [UIColor colorWithHexString:@"#d4d3d8"];
}

+ (void)setBasicAppearanceForViewController:(UIViewController *)vc{
    
    // set font and style for navigation item title
    [vc.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary
      dictionaryWithObjectsAndKeys:
      [AppearanceManager navigationBarItemTint], NSForegroundColorAttributeName,
      [UIFont fontWithName:kRegularFontName size:kBigFontSize], NSFontAttributeName, nil]];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     [NSDictionary
      dictionaryWithObjectsAndKeys:
      [AppearanceManager navigationBarItemTint], NSForegroundColorAttributeName,
      [UIFont fontWithName:kLightFontName size:kDefaultFontSize], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTintColor:[AppearanceManager navigationBarItemTint]];
    
    // Set disabled status
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     [NSDictionary
      dictionaryWithObjectsAndKeys:
      [UIColor grayColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:kLightFontName size:kDefaultFontSize], NSFontAttributeName, nil] forState:UIControlStateDisabled];
    
    vc.navigationController.navigationBar.tintColor = [AppearanceManager navigationBarItemTint];
    
    
    // Set title of Back button to empty
    vc.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    
    [vc.navigationController.navigationBar setBarTintColor:[AppearanceManager navigationBarTint]];
    
    // Set background color for view
    vc.view.backgroundColor = [AppearanceManager backgroundColor];
    
    // Set Title View
    //vc.originTitleView = vc.navigationItem.titleView;
    vc.navigationItem.titleView = [AppearanceManager navigationTitleImageView];
}

+ (UIView *)addNoInternetConnectionViewInView:(UIView *)view{
    
    if(!noInternetConnectionView){
    
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"NoInternetConnection" owner:nil options:nil];
        noInternetConnectionView = [nibArray objectAtIndex:0];
        
        noInternetConnectionView.frame = CGRectMake(0, 20, ScreenWidth, 24.0f);
        UILabel *noNetworkLabel = noInternetConnectionView.noInternetLabel;
        noInternetConnectionView.noInternetLabel.frame = CGRectMake((CGRectGetWidth(noInternetConnectionView.frame) - CGRectGetWidth(noNetworkLabel.frame))/2 - CGRectGetWidth(noInternetConnectionView.noInternetIcon.frame)/2,
                                                                    CGRectGetMinY(noNetworkLabel.frame),
                                                                    CGRectGetWidth(noNetworkLabel.frame),
                                                                    CGRectGetHeight(noNetworkLabel.frame));
        CGRect iconFrm = noInternetConnectionView.noInternetIcon.frame;
        iconFrm.origin.x = CGRectGetMaxX(noInternetConnectionView.noInternetLabel.frame) + 1;
        noInternetConnectionView.noInternetIcon.frame = iconFrm;
    }
    
    if ([noInternetConnectionView superview]) {
        
        [noInternetConnectionView removeFromSuperview];
    }
    
    [view addSubview:noInternetConnectionView];
    
    return noInternetConnectionView;
}

+ (void)removeNoInternetConnectionView{
    
    if (noInternetConnectionView) {
        [noInternetConnectionView removeFromSuperview];
    }
}
@end
