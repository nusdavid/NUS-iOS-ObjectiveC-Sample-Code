//
//  CreditCardView.h
//  SampleCode
//
//  Created by Thach Bui-Khac on 1/27/15.
//  Copyright (c) 2015 MyID. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PTKTextField.h"
#import "PTKCard.h"

#import "PTKCardNumber.h"
#import "PTKCardExpiry.h"
#import "PTKCardCVC.h"
#import "PTKCardType.h"

@class CreditCardView;
@protocol KNCreditCardViewDelegate<NSObject>

-(void)paymentView:(CreditCardView*)paymentView withCard:(PTKCard*)card isValid:(BOOL) valid;
@end

@interface CreditCardView : UIView <UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet TextField *cardNumberField;
@property(weak, nonatomic) IBOutlet TextField *cardExpiryMonthField;
@property(weak, nonatomic) IBOutlet TextField *cardExpiryYearField;
@property(weak, nonatomic) IBOutlet TextField *cardCVCField;

@property(nonatomic) id<NSObject,KNCreditCardViewDelegate> delegate;

@end
