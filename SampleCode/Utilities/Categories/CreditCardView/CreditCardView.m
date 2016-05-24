//
//  CreditCardView.m
//  SampleCode
//
//  Created by Thach Bui-Khac on 1/27/15.
//  Copyright (c) 2015 MyID. All rights reserved.
//

#import "CreditCardView.h"

@implementation CreditCardView{

    // MARK - private variables
    UIView *vBorderView;
    BOOL _isValidState;
    NSString *originMonth;
}

-(void)awakeFromNib{

    [super awakeFromNib];
    
    [self setupControls];
}

-(void)setup{
    
    _isValidState = false;
}

-(void)setupControls{
    
    [self setup];
    
//    [self.cardNumberField setup];
//    [self.cardExpiryMonthField setup];
//    [self.cardExpiryYearField setup];
//    [self.cardCVCField setup];
    
    // set no border for first & last text field
    [self.cardNumberField setNoBorder];
    [self.cardCVCField setNoBorder];
    
    [self.cardExpiryMonthField setNoBorder];
    [self.cardExpiryYearField setNoBorder];
    
    // initialize border view
    if (!vBorderView) {
        
        vBorderView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.cardExpiryMonthField.frame), CGRectGetMinY(self.cardExpiryMonthField.frame), CGRectGetWidth(self.cardNumberField.frame), CGRectGetHeight(self.cardExpiryMonthField.frame))];
        
        [self insertSubview:vBorderView aboveSubview:0];
        
        // set border
        vBorderView.layer.borderColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.8].CGColor;
        vBorderView.layer.borderWidth = 0.5;
        
    }else {
        
        vBorderView.frame = CGRectMake(CGRectGetMinX(self.cardExpiryMonthField.frame), CGRectGetMinY(self.cardExpiryMonthField.frame), CGRectGetWidth(self.cardNumberField.frame), CGRectGetHeight(self.cardExpiryMonthField.frame));
    }
}

-(void)setTitleTextWithColor:(UIColor*)color{
    
    // set title for text field
    [self.cardNumberField addTitleForLeftView:LOCALIZATION(@"cardNumber") andTextColor:color];
    [self.cardExpiryMonthField addTitleForLeftView:LOCALIZATION(@"expirationDate") andTextColor:color];
    [self.cardCVCField addTitleForLeftView:LOCALIZATION(@"cvc") andTextColor:color];
}

// MARK - Accessors
- (PTKCardNumber *)cardNumber
{
    return [PTKCardNumber cardNumberWithString:self.cardNumberField.text];
}

- (PTKCardExpiry *)cardExpiry
{
    NSString *text = [self getDateFromMonth:self.cardExpiryMonthField.text andYear:self.cardExpiryYearField.text];
    return [PTKCardExpiry cardExpiryWithString:text];
}

- (PTKCardCVC *)cardCVC
{
    return [PTKCardCVC cardCVCWithString:self.cardCVCField.text];
}

- (PTKCard *)card
{
    PTKCard *card = [[PTKCard alloc] init];
    card.number = [self.cardNumber string];
    card.cvc = [self.cardCVC string];
    card.expMonth = [self.cardExpiry month];
    card.expYear = [self.cardExpiry year];
    card.brand = [self getCardTypeInString];
    
    return card;
}

// MARK - Delegates
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if ([textField isEqual:self.cardNumberField]) {
        return [self cardNumberFieldShouldChangeCharactersInRange:range replacementString:string];
    }
    
    // Month expiry field
    if ([textField isEqual:self.cardExpiryMonthField]) {
        
        return [self cardExpiryMonthShouldChangeCharactersInRange:range replacementString:string];
    }
    
    // Year expiry field
    if ([textField isEqual:self.cardExpiryYearField]) {
        
        return [self cardExpiryYearShouldChangeCharactersInRange:range replacementString:string];
    }
    
    if ([textField isEqual:self.cardCVCField]) {
        return [self cardCVCShouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

- (BOOL)cardNumberFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultString = [self.cardNumberField.text stringByReplacingCharactersInRange:range withString:string];
    resultString = [PTKTextField textByRemovingUselessSpacesFromString:resultString];
    PTKCardNumber *cardNumber = [PTKCardNumber cardNumberWithString:resultString];
    
    if (![cardNumber isPartiallyValid])
        return NO;
    
    if (string.length > 0) {
        self.cardNumberField.text = [cardNumber formattedStringWithTrail];
    } else {
        self.cardNumberField.text = [cardNumber formattedString];
    }
    
    if ([cardNumber isValid]) {
        [self textFieldIsValid:self.cardNumberField];
        [self stateCardExpiredMonth];
        
    } else if ([cardNumber isValidLength] && ![cardNumber isValidLuhn]) {
        [self textFieldIsInvalid:self.cardNumberField withErrors:YES];
        
    } else if (![cardNumber isValidLength]) {
        [self textFieldIsInvalid:self.cardNumberField withErrors:NO];
    }
    
    return NO;
}

-(BOOL)cardExpiryMonthShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    
    NSString *resultString = [self.cardExpiryMonthField.text stringByReplacingCharactersInRange:range withString:string];
    resultString = [self getDateFromMonth:resultString andYear:self.cardExpiryYearField.text];
    
    resultString = [PTKTextField textByRemovingUselessSpacesFromString:resultString];
    PTKCardExpiry *cardExpiry = [PTKCardExpiry cardExpiryWithString:resultString];
    
    if (![cardExpiry isPartiallyValid]){
        
        return false;
    }
    
    if (cardExpiry.formattedString.length > 7) {
        
        return false;
    }
    
    if  (string.length > 0) {
        
        self.cardExpiryMonthField.text = [self getMonthFromDateString:cardExpiry.formattedStringWithTrail];
    }else{
        
        self.cardExpiryMonthField.text = [self getMonthFromDateString:cardExpiry.formattedString];
    }
    
    if ([cardExpiry isValid]){
        
        [self textFieldIsValid:self.cardExpiryMonthField];
    }else if ([cardExpiry isValidLength] && ![cardExpiry isValidDate]){
        
        [self textFieldIsInvalid:self.cardExpiryMonthField withErrors:true];
    }else if (![cardExpiry isValidLength]) {
        
        [self textFieldIsInvalid:self.cardExpiryMonthField withErrors:false];
    }
    
    if (self.cardExpiryMonthField.text.length == 2) {
        
        [self stateCardExpiredYear];
    }
    
    return false;
}

-(BOOL)cardExpiryYearShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    
    NSRange newRange = NSMakeRange(range.location + 3, range.length);
    
    NSString *resultString = [[self getMonthYearForYearField] stringByReplacingCharactersInRange:newRange withString: string];
    
    resultString = [PTKTextField textByRemovingUselessSpacesFromString:resultString];
    PTKCardExpiry *cardExpiry = [PTKCardExpiry cardExpiryWithString:resultString];
    
    if (![cardExpiry isPartiallyValid]){
        
        return false;
    }
    
    if (cardExpiry.formattedString.length > 7) {
        return false;
    }
    
    if  (string.length > 0) {
        
        self.cardExpiryYearField.text = [self getYearFromDateString:cardExpiry.formattedStringWithTrail];
    }else{
        
        self.cardExpiryYearField.text = [self getYearFromDateString:cardExpiry.formattedString];
    }
    
    if (cardExpiry.isValid){
        
        [self textFieldIsValid:self.cardExpiryYearField];
    }else if (cardExpiry.isValidLength && !cardExpiry.isValidDate) {
        
        [self textFieldIsInvalid:self.cardExpiryYearField withErrors: true];
    }else if (!cardExpiry.isValidLength) {
        
        [self textFieldIsInvalid:self.cardExpiryYearField withErrors: false];
    }
    
    if (self.cardExpiryYearField.text.length == 4){
        
        [self stateCardCVC];
    }
    
    return false;
}

-(BOOL)cardCVCShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    
    NSString *resultString = [self.cardCVCField.text stringByReplacingCharactersInRange:range withString:string];
    resultString = [PTKTextField textByRemovingUselessSpacesFromString:resultString];
    PTKCardCVC *cardCVC = [PTKCardCVC cardCVCWithString:resultString];
    PTKCardType cardType = [PTKCardNumber cardNumberWithString:self.cardNumberField.text].cardType;
    
    // Restrict length
    if (![cardCVC isPartiallyValidWithType:cardType]){
        
        return false;
    }
    
    // Strip non-digits
    self.cardCVCField.text = [cardCVC string];
    
    if ([cardCVC isValidWithType:cardType]) {
        
        [self textFieldIsValid:self.cardCVCField];
    }else{
        
        [self textFieldIsInvalid:self.cardCVCField withErrors:false];
    }
    
    return false;
}

#pragma mark - private methods
-(NSString*)getDateFromMonth:(NSString*)month andYear:(NSString*)year {
    
    NSString *text = month;
    
    if (text.length == 2) {
        text = [NSString stringWithFormat:@"%@/%@", text, year];
    }
    
    return text;
}

-(NSString*)getMonthYearForYearField {
    
    NSString *text = self.cardExpiryMonthField.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    [dateFormatter setDateFormat:@"MM"];
    NSDate *now = [NSDate date];
    
    if (text.length == 0) {
        
        text = [dateFormatter stringFromDate:now];
    }else if (text.length == 1) {
        
        text = [dateFormatter stringFromDate:now];
    }
    
    if (text.length == 2) {
        
        text = [NSString stringWithFormat:@"%@/%@", text, self.cardExpiryMonthField.text];
    }
    
    return text;
}

-(NSString*)getMonthFromDateString:(NSString*)date{
    
    if (date.length <= 2) {
        
        return date;
    }else{
        
        return  [date substringWithRange:NSMakeRange(0, 2)];
    }
}

-(NSString*)getYearFromDateString:(NSString*)date{
    
    if (date.length <= 3) {
        
        return @"";
    }else{
        
        return [date substringWithRange:NSMakeRange(3, date.length)];
    }
}

-(void)stateCardExpiredMonth {
    
    [self.cardExpiryMonthField becomeFirstResponder];
}

-(void)stateCardExpiredYear {
    
    [self.cardExpiryYearField becomeFirstResponder];
}

-(void)stateCardCVC {
    
    [self.cardCVCField becomeFirstResponder];
}

-(void)textFieldIsValid:(UITextField*)textField{
    
    [self checkValid];
}

-(void)textFieldIsInvalid:(UITextField*)textField withErrors:(BOOL)errors{
    
    [self checkValid];
}

-(void)checkValid{
    
    if ([self isValid]) {
        
        _isValidState = true;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(paymentView:withCard:isValid:)]) {
            
            [self.delegate paymentView:self withCard:[self card] isValid:true];
        }
    }else if (![self isValid] && _isValidState) {
        
        _isValidState = false;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(paymentView:withCard:isValid:)]) {
            
            [self.delegate paymentView:self withCard:[self card] isValid:false];
        }
    }
}

-(BOOL)isValid{
    
    return [self cardNumber].isValid && [self cardExpiry].isValid && [[self cardCVC] isValidWithType:[self cardNumber].cardType];
}

#pragma mark - public methods
-(NSString*)getCardTypeInString{
    
    PTKCardType cardType = [self cardNumber].cardType;
    NSString *cardTypeName = @"";
    
    switch (cardType) {
        case PTKCardTypeAmex:
            cardTypeName = @"AmEx";
            break;
            
        case PTKCardTypeDinersClub:
            cardTypeName = @"Diners";
            break;
            
        case PTKCardTypeDiscover:
            cardTypeName = @"Discover";
            break;
            
        case PTKCardTypeJCB:
            cardTypeName = @"JCB";
            break;
            
        case PTKCardTypeMasterCard:
            cardTypeName = @"MasterCard";
            break;
            
        case PTKCardTypeVisa:
            cardTypeName = @"VISA";
            break;
            
        default:
            cardTypeName = @"";
            break;
    }
    
    return cardTypeName;
}

@end

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
