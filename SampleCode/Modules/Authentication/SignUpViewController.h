//
//  SignUpViewController.h
//
//  Created by NUS Technology on 10/20/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SignUpViewController : BaseViewController <UITextFieldDelegate>

@property id <LoginViewControllerDelegate> delegate;
@end