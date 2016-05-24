//
//  SignUpViewController.m
//
//  Created by NUS Technology on 10/20/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppearanceManager.h"
#import "AnalyticsManager.h"
#import "APIClient.h"
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    TextTypeEmail = 0,
    TextTypePassword,
    TextTypePasswordConfirmation
}TextType;

@interface SignUpViewController () {
    BOOL isHideInput;
    UIMotionEffectGroup *group;
}
@property (weak, nonatomic) IBOutlet TextField *tfEmail;
@property (weak, nonatomic) IBOutlet TextField *tfPassword;
@property (weak, nonatomic) IBOutlet TextField *tfConfirmPassword;

@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation SignUpViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [AppearanceManager backgroundColor];
    
    self.delegate = self.appDelegate;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.submitButton setTitle:LOCALIZATION(@"submit") forState:UIControlStateNormal];
    [self.cancelButton setTitle:LOCALIZATION(@"cancel") forState:UIControlStateNormal];
    
    NSAttributedString *emailPlaceholder = [[NSAttributedString alloc] initWithString:LOCALIZATION(@"email") attributes:@{ NSForegroundColorAttributeName : kTextFieldFontColor }];
    NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:LOCALIZATION(@"password") attributes:@{ NSForegroundColorAttributeName : kTextFieldFontColor }];
    NSAttributedString *confirmPasswordPlaceholder = [[NSAttributedString alloc] initWithString:LOCALIZATION(@"confirmPassword") attributes:@{ NSForegroundColorAttributeName : kTextFieldFontColor }];
    
    self.tfEmail.attributedPlaceholder = emailPlaceholder;
    self.tfPassword.attributedPlaceholder = passwordPlaceholder;
    self.tfConfirmPassword.attributedPlaceholder = confirmPasswordPlaceholder;
    
    // set border for textfield
    [self.tfEmail setBorder];
    [self.tfPassword setBorder];
    [self.tfConfirmPassword setBorder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)signUp:(UIButton *)sender
{
    
    [self dismissKeyboards];
    
    if (![self validateInput]) {
        return;
    }
    
    NSMutableDictionary *userDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                          @"user": @{
                                                                                                  @"email": self.tfEmail.text,
                                                                                                  @"password": self.tfPassword.text,
                                                                                                  @"password_confirmation":self.tfConfirmPassword.text
                                                                                                  }
                                                                                          }];
    
    APIClient *theClient =[APIClient sharedInstance];
    [theClient signUpWithParameters:userDictionary success:^(BOOL successful) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (successful)
        {
            
            [self.delegate didLogin];
            
            User *user = [User new];
            user.email = self.tfEmail.text;
            user.password = self.tfPassword.text;
            [user.class saveLocalItems:[NSArray arrayWithObject:user]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *msgTitle = LOCALIZATION(@"signUpTitle");
        NSString *errorMessage = error.localizedDescription;
        
        //some part of the sign up failed
        [[[UIAlertView alloc] initWithTitle:msgTitle
                                    message:errorMessage
                                   delegate:nil
                          cancelButtonTitle: LOCALIZATION(@"ok")
                          otherButtonTitles: nil]
         show];
        [AnalyticsManager sendErrorWithTitle:nil message:error.localizedDescription andError:error];
    }];
    
}

// Go to Splash screen
- (IBAction)cancelSignup:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Validation
- (BOOL)validateInput
{
    if (self.tfEmail.text.length < 1) {
        [[Utilities sharedInstance] showOKMessage:LOCALIZATION(@"blankEmailMsg")
                                        withTitle:nil];
        return NO;
    }
    if ([[Utilities sharedInstance] isValidEmail:self.tfEmail.text] == NO) {
        [[Utilities sharedInstance] showOKMessage:LOCALIZATION(@"invalidEmailMsg")
                                        withTitle:nil];
        return NO;
    }
    if (self.tfPassword.text.length < 1) {
        [[Utilities sharedInstance] showOKMessage:LOCALIZATION(@"blankPasswordMsg")
                                        withTitle:nil];
        return NO;
    }
    if (self.tfPassword.text.length < 6) {
        [[Utilities sharedInstance] showOKMessage:LOCALIZATION(@"invalidMininumLengthPasswordMsg")
                                        withTitle:nil];
        return NO;
    }
    if (![self.tfPassword.text isEqualToString:self.tfConfirmPassword.text]) {
        [[Utilities sharedInstance] showOKMessage:LOCALIZATION(@"invalidConfirmMsg")
                                        withTitle:nil];
        return NO;
    }
    return YES;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - private methods
- (void)dismissKeyboards {

    [self.tfEmail resignFirstResponder];
    [self.tfPassword resignFirstResponder];
    [self.tfConfirmPassword resignFirstResponder];
}

- (void)goToHome
{
    UIViewController *VC = [StoryboardManager getViewControllerWithIdentifier:kHomeViewControllerId fromStoryboard:kMainStoreyboard];
    
    [self presentViewController:VC animated:YES completion:nil];
}

@end
