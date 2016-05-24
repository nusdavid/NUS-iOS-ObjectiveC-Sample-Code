//
//  LogInViewController.m
//
//  Created by NUS Technology on 10/17/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()<UIAlertViewDelegate> {
    
}

@property (weak, nonatomic) IBOutlet TextField *tfEmail;
@property (weak, nonatomic) IBOutlet TextField *tfPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) UIAlertView *forgotPassword;


@end

@implementation LogInViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self.appDelegate;
    [self.tfEmail setPlaceholderText:@"Email"];
    [self.tfPassword setPlaceholderText:@"Password"];
    
    [self.tfEmail setDefaultTextField];
    [self.tfPassword setDefaultTextField];
    
    [self.tfEmail setBorder];
    [self.tfPassword setBorder];
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    
////    NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:LOCALIZATION(@"Password") attributes:@{ NSForegroundColorAttributeName : kTextFieldFontColor }];
////    NSAttributedString *emailPlaceholder = [[NSAttributedString alloc] initWithString:LOCALIZATION(@"Email") attributes:@{ NSForegroundColorAttributeName : kTextFieldFontColor }];
////    
////    self.tfPassword.attributedPlaceholder = passwordPlaceholder;
////    self.tfEmail.attributedPlaceholder = emailPlaceholder;
////    self.tfEmail.placeholder = @"abc";
//    
////    [self.tfEmail setPlaceholderText:@"Email1"];
//    
////    [self.tfPassword setPlaceholder:@"Password"];
//    
//    // set border for textfield
////    [self.tfEmail setBorder];
////    [self.tfPassword setBorder];
//}

- (void)viewDidUnload
{
    [self setTfEmail:nil];
    [self setTfPassword:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events

- (void)goToHome
{
    UIViewController *VC = [StoryboardManager getViewControllerWithIdentifier:kHomeViewControllerId fromStoryboard:kMainStoreyboard];
    
    [self presentViewController:VC animated:YES completion:nil];
}

- (IBAction)login:(UIButton *)sender
{
    // Hide keyboard
    [self.view endEditing:YES];
    
    if (![self validateInput]) {
        
        [[[UIAlertView alloc]initWithTitle:nil message:LOCALIZATION(@"lackInputParameter") delegate:nil cancelButtonTitle:LOCALIZATION(@"ok") otherButtonTitles:nil] show];
        
        
        return;
    }
    
    APIClient *myClient = [APIClient sharedInstance];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //authentication
    [myClient authorizeWithUsername:self.tfEmail.text password:self.tfPassword.text success:^(BOOL successful){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (successful) {
            
            [self.delegate didLogin];
            
            User *user = [User new];
            user.email = self.tfEmail.text;
            user.password = self.tfPassword.text;
            [user.class saveLocalItems:[NSArray arrayWithObject:user]];
        }
    } failure:^(NSError* error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *errorMessage = error.localizedDescription;//LOCALIZATION(@"incorrectUserNameOrPassword");

        [[[UIAlertView alloc]initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:LOCALIZATION(@"ok") otherButtonTitles:nil] show];
    }];
}

- (IBAction)forgotPassword:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"segueForgotPassword" sender:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.forgotPassword) {
        if (buttonIndex == 0) {
            [self performSegueWithIdentifier:@"segueForgotPassword" sender:self];
        }
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (IBAction)unwindToLogInViewController:(UIStoryboardSegue *)unwindSegue{
    
}

-(BOOL)validateInput{

    if (self.tfPassword.text.length > 0 && self.tfEmail.text.length > 0 ){
        
        return true;
    }
    
    return false;
}

@end
