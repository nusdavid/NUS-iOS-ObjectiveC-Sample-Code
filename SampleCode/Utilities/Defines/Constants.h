//
//  Constants.h
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//

#import <Foundation/Foundation.h>

//#define isIphone6Plus      = ([UIDevice currentDevice].userInterfaceIdiom == userInterfaceIdiomPhone && ScreenHeight >= 736.0)

// Stripe
#define kStripePUBLISHABLE_KEY      @"pk_test_xgWvwr32sARsarrqcrnmOa7k"
#define kstripeSECRET_Key           @"sk_test_rA3YDeTRKQv4fbJSm7eMx2XD"

#define kFirstLineColor             [UIColor colorWithRed:196.0f/255.0f green:196.0f/255.0f blue:196.0f/255.0f alpha:1.0f]
#define kThirdLineColor             [UIColor colorWithRed:149.0f/255.0f green:149.0f/255.0f blue:149.0f/255.0f alpha:1.0f]
#define kSecondLineColor            [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]
#define kGradientColor0             [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0f]
#define kGradientColor1             [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f]

#define kLineBorderColor            [UIColor colorWithRed:0/255.0 green:142/255.0 blue:207/255.0 alpha:1.0]
#define kTabbarBackgroundColor      [UIColor colorWithHexString:@"#323232"]
#define kEvenListBackgroundColor    [UIColor colorWithRed:234.0f/255.0f green:233.0f/255.0f blue:239.0f/255.0f alpha:1.0f]
#define kOddListBackgroundColor     [UIColor colorWithRed:226.0f/255.0f green:226.0f/255.0f blue:231.0f/255.0f alpha:1.0f]
#define kTextFieldFontColor         [UIColor colorWithRed:243.0f/255.0f green:245.0f/255.0f blue:244.0f/255.0f alpha:1.0f]
#define kUnselectFeildColor         [UIColor colorWithRed:131.0f/255.0f green:131.0f/255.0f blue:131.0f/255.0f alpha:1.0f]

#define kPasscodeBackgroundColor    [UIColor colorWithHexString:@"#178FCC"]

#define kDefaultBorderWidth     0.5f
#define kThinBorderHeight       1.0f
#define kThickBorderHeight      1.0f

#define kViewBackgroundColor    [UIColor colorWithRed:234.0f/255 green:234.0f/255 blue:234.0f/255 alpha:1.0]
#define kControlBackgroundColor [UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0]

#define kButtonBackgroundColor  [UIColor colorWithRed:16.0f/255 green:133.0f/255 blue:186.0f/255 alpha:1.0]
#define kButtonForegroundColor  [UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0]
#define kButtonFontName         @"HelveticaNeue-Light"
#define kButtonFontSize         20.0f

#define kCommonForegroundColor  [UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0]
#define kRegularFontName            @"HelveticaNeue"
#define kLightFontName              @"HelveticaNeue-Light"
#define kMediumFontName             @"HelveticaNeue-Medium"
#define kBoldFontName               @"HelveticaNeue-Bold"
#define kCondensedBoldFontName      @"HelveticaNeue-CondensedBold"

#define kBigFontSize                19.0f
#define kDefaultFontSize            17.0f
#define kMediumFontSize             14.0f
#define kSmallFontSize              12.0f

#define kPageSize                   25

#define kPasscodeSetting            @"MyIDPasscodeSetting"
#define kTouchIDSetting             @"MyIDTouchIDSetting"

#define kHealthKitSetting           @"MyIDHealthKitSetting"
#define kHealthKitProfile           @"MyIDHealthKitProfile"

#define kNavigationBarItemColor [UIColor colorWithRed:51.0f/255 green:51.0f/255 blue:51.0f/255 alpha:1.0]

#define kNetworkError               @"Network connection error"
#define kDefaultProfileImageName    @"default_avatar_rect"

// Key chain
#define kKeychainAccessToken        @"AppName_AccessToken"
#define kKeyChainPassword           @"AppName_Password"
#define kKeychainUserName           @"AppName_UserName"
#define kKeyChainUserId             @"AppName_UserId"

#define kDidUpdatedProfieNotificationName   @"didUpdatedProfileNotificationName"

// Constants for API
#define kOAuthPath                  @"/auth/sign_in"
#define kAPIRegisterMobile          @"/user/mobile"
#define kAPILogin                   @"/user/login"
#define kAPILogout                  @"/user/logout"
#define kAPIRegister                @"/user/registration"
#define kAPIGetOauthToken           @"/oauth/token"
#define kAPIGetProfile              @"/user"
#define kAPIUpdateProfile           @"/user/profile"
#define kAPIChangePassword          @"/user/resetPassword"
#define kAPIForgotPassword          @"/user/forgotPassword"
#define kAPIResetPassword           @"/reset/password"

// Constants for string format
#define kInputDateFormat            @"MM-dd-yyyy HH:mm"
#define kInputBookDateFormat        @"MM-dd-yyyy h:mm a"
#define kOutputDateFormat           @"MMMM dd h:mma"
#define kOutputBookDateFormat       @"MMMM dd, yyyy"

// Constants for json keys in response message returned by Invoking API
#define kResultKey                  @"result"
#define kMessageCodeKey             @"message_code"
#define kSuccessResult              @"success"
#define kAccessToken                @"authentication_token"
#define kRefreshAccessToken         @"refresh_token"

// Constants for oauth api
#define kClientId                   @"9e6ffb04-91ab-4d3f-92b2-c31d8e6aebd4"
#define kClientSecret               @"57cc7420-4709-478b-85b2-f9221464c614"
#define kGrantType                  @"password"

#define kSqliteName                 @"iOSAppName.sqlite"

// Splash constants
#define kDefaultTimeToLiveSplash    3.0f    // unit: seconds
#define kTimerIntervalSplash        0.5f    // unit: seconds

// Notifications
#define kLoginSuccessed             @"Login Successed"
#define kLoginFailed                @"Login Failed"
#define kApplicationLoadFinished    @"Application load finished"

// Refresh token interval
#define kRefreshTokenInterval       10*60
#define kRefreshDataInterval        60

// Storyboard file name
#define kMainStoryboardName_iPad    @""
#define kMainStoryboardName_iPhone  @""

// Security storyboard
#define kSecurityStoreyboard        @"Security"
#define kSignInViewControllerId     @"LogInViewController"

#define kMainStoreyboard            @"Main"
#define kHomeViewControllerId     @"HomeViewController"
