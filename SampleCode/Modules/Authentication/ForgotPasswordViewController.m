//
//  ForgotPasswordViewController.m
// Sample Code
//
//  Created by NUS Technology on 10/24/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "NSString+Helper.h"

@interface ForgotPasswordViewController ()<UIAlertViewDelegate> {
    BOOL isHideInput;
    UIMotionEffectGroup *group;
}

@property (weak, nonatomic) IBOutlet TextField *tfEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // set border for textfield
    [self.tfEmail setBorder];
    self.tfEmail.toolbar.hidden = true;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sumitAction:(id)sender
{
    
    [self dismissKeyboards];
    
    if (![self validateInput]) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *userDictionary = [NSMutableDictionary dictionary];
    [userDictionary setObject:[self.tfEmail.text trim] forKey:@"email"];
    
    APIClient *theClient =[APIClient sharedInstance];
    [theClient forgotPasswordWithParameters:userDictionary success:^(BOOL successful) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (successful) {
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: LOCALIZATION(@"sentEmailSuccessTitle")
                                        message: LOCALIZATION(@"checkEmailInformForResetPassword")
                                       delegate: self
                              cancelButtonTitle: LOCALIZATION(@"OK")
                             otherButtonTitles: nil];
            alertView.tag = 1010;
            [alertView show];
        }
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *msgTitle = LOCALIZATION(@"forgotPasswordTitle");
        
        NSString *errorMessage = error.localizedDescription;
        
        //some part of the sign up failed
        [[[UIAlertView alloc] initWithTitle: msgTitle
                                    message: errorMessage
                                   delegate: nil
                          cancelButtonTitle: LOCALIZATION(@"OK")
                          otherButtonTitles: nil]
         show];
        
        [AnalyticsManager sendErrorWithTitle:nil message:error.localizedDescription andError:error];
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1010) {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self.tfEmail resignFirstResponder];
    
    return true;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    [self.tfEmail resignFirstResponder];
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
    
    return YES;
}

- (void)dismissKeyboards{

    [self.tfEmail resignFirstResponder];
}

@end
