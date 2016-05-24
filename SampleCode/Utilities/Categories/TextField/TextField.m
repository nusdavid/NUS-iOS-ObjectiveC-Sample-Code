//
//  TextField.m
//
//  Created by NUS Technology on 4/11/13.
//  Copyright (c) 2013 NUS Technology. All rights reserved.
//

#import "TextField.h"

#define kDefaultBorderWidth                     0.5f
#define kDefaultBorderWidthForIphone6Plus       1.0f
#define kDefaultBorderColor                     [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5]
#define kLeftMargin                             15.0f

@interface TextField()
{
    UITextField *_textField;
    BOOL _disabled;
    
    NSString *placeHolderTemp;
    UIColor *placeHolderColor;
    
    float defaultBorderWidth;
}

@property (nonatomic) BOOL keyboardIsShown;
@property (nonatomic) CGSize keyboardSize;
@property (nonatomic) BOOL isKeyboardHeightCalculated;

@property (nonatomic) BOOL hasScrollView;
@property (nonatomic) BOOL invalid;

@property (nonatomic, setter = setToolbarCommand:) BOOL isToolBarCommand;
@property (nonatomic, setter = setDoneCommand:) BOOL isDoneCommand;

@property (nonatomic , strong) UIBarButtonItem *previousBarButton;
@property (nonatomic , strong) UIBarButtonItem *nextBarButton;

@property (nonatomic, strong) NSMutableArray *textFields;

@end

@implementation TextField

@synthesize required;
@synthesize scrollView;
@synthesize toolbar;
@synthesize keyboardIsShown;
@synthesize keyboardSize;
@synthesize isKeyboardHeightCalculated;
@synthesize invalid;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
        
        [self setup];
    }
    
    return self;
}

- (void) awakeFromNib{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    defaultBorderWidth = kDefaultBorderWidth;
    if ([self isIphone6Plus] == true) {
        defaultBorderWidth = kDefaultBorderWidthForIphone6Plus;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.window.frame.size.width, 44);
    
    // set style
    [toolbar setBarStyle:UIBarStyleDefault];
    
    self.previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previousButtonIsClicked:)];
    
    
    self.nextBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonIsClicked:)];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonIsClicked:)];
    
    NSArray *barButtonItems = @[self.previousBarButton, self.nextBarButton, flexBarButton, doneBarButton];
    
    toolbar.items = barButtonItems;
    
    self.textFields = [[NSMutableArray alloc]init];
    
    [self markTextFieldsWithTagInView:self.superview];
    
//    self.rightViewMode = UITextFieldViewModeAlways;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kLeftMargin, CGRectGetHeight(self.frame))];
    self.leftView = paddingView;
//    self.rightView = paddingView;
    
    placeHolderTemp = @" ";
    placeHolderColor = [UIColor blackColor];
    
    placeHolderTemp = self.placeholder == nil ? @" " : self.placeholder;
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolderTemp attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
    
}

- (void)markTextFieldsWithTagInView:(UIView*)view
{
    int index = 0;
    if ([self.textFields count] == 0){
        for(UIView *subView in view.subviews){
            if ([subView isKindOfClass:[TextField class]]){
                TextField *textField = (TextField*)subView;
                textField.tag = index;
                [self.textFields addObject:textField];
                index++;
            }
        }
    }
}

- (void) doneButtonIsClicked:(id)sender
{
    [self setDoneCommand:YES];
    [self resignFirstResponder];
    [self setToolbarCommand:YES];
}

static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve)
{
    UIViewAnimationOptions opt = (UIViewAnimationOptions)curve;
    return opt << 16;
}

-(void) keyboardDidShow:(NSNotification *) notification
{
    if (_textField == nil) return;
    
    if (![_textField isKindOfClass:[TextField class]]) return;
    
    NSDictionary *notificationInfo = [notification userInfo];
    CGRect finalKeyboardFrame = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval keyboardAnimationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger keyboardAnimationCurveNumber = [[notificationInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    UIViewAnimationOptions animationOptions = animationOptionsWithCurve(keyboardAnimationCurveNumber);
    
    self.keyboardSize = finalKeyboardFrame.size;
    
    // resize frame for scroll view
    if ([self getKeyboardIsShown] == false) {
        
        if ([self.superview isKindOfClass:[UIScrollView class]]) {
            
            [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:animationOptions animations:^{
                
                [self calculateKeyboardHeightForScrollViewForStatus:true];
                [self scrollToField:false];
            } completion:nil];
            
        }
    }else{
        
        if ([self.superview isKindOfClass:[UIScrollView class]]) {
            
            [self scrollToField:true];
        }
    }
    
    [self setKeyboardStatusToHidden:true];
    self.keyboardIsShown = true;
}

-(void) keyboardWillHide:(NSNotification *) notification
{
 
    NSDictionary *info = [notification userInfo];
    NSTimeInterval duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        if (self.isDoneCommand || true) {
            
            if ([self.superview isKindOfClass:[UIScrollView class]]) {
                
                [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
            }
        }
    }];
    
    // resize frame for scroll view
    if ([self getKeyboardIsShown]) {
        
        if ([self.superview isKindOfClass:[UIScrollView class]]) {
            
            [self calculateKeyboardHeightForScrollViewForStatus:false];
        }
    }
    
    [self setKeyboardStatusToHidden:true];
    self.keyboardIsShown = false;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:self];
}

- (void) nextButtonIsClicked:(id)sender
{
    NSInteger tagIndex = self.tag;
    TextField *textField =  [self.textFields objectAtIndex:++tagIndex];
    
    while (!textField.isEnabled && tagIndex < [self.textFields count])
        textField = [self.textFields objectAtIndex:++tagIndex];

    [self becomeActive:textField];
}

- (void) previousButtonIsClicked:(id)sender
{
    NSInteger tagIndex = self.tag;
    
    TextField *textField =  [self.textFields objectAtIndex:--tagIndex];
    
    while (!textField.isEnabled && tagIndex < [self.textFields count])
        textField = [self.textFields objectAtIndex:--tagIndex];
    
    [self becomeActive:textField];
}

- (void)becomeActive:(UITextField*)textField
{
    [self setToolbarCommand:YES];
    [self resignFirstResponder];
    [textField becomeFirstResponder];
}

- (void)setBarButtonNeedsDisplayAtTag:(int)tag
{
    BOOL previousBarButtonEnabled = NO;
    BOOL nexBarButtonEnabled = NO;
    
    for (int index = 0; index < [self.textFields count]; index++) {

        UITextField *textField = [self.textFields objectAtIndex:index];
    
        if (index < tag)
            previousBarButtonEnabled |= textField.isEnabled;
        else if (index > tag)
            nexBarButtonEnabled |= textField.isEnabled;
    }
    
    self.previousBarButton.enabled = previousBarButtonEnabled;
    self.nextBarButton.enabled = nexBarButtonEnabled;
}

- (void)selectInputView:(UITextField *)textField
{
    if (_isDateField){
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if (![textField.text isEqualToString:@""]){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/YY"];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [datePicker setDate:[dateFormatter dateFromString:textField.text]];
        }
        [textField setInputView:datePicker];
    }
}

- (void)datePickerValueChanged:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker*)sender;
    
    NSDate *selectedDate = datePicker.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [
     dateFormatter setDateFormat:@"MM/dd/YY"];
    
    [_textField setText:[dateFormatter stringFromDate:selectedDate]];
    
    [self validate];
}

- (void)scrollToField:(BOOL)animated
{
    
    if (_textField == nil) {
        
        return;
    }
    
    CGRect textFieldRect = _textField.frame;
    
    CGRect aRect = self.window.bounds;
    
    aRect.origin.y = -scrollView.contentOffset.y;
    
    CGFloat toolbarHeight = self.toolbar.frame.size.height;
    if  (self.toolbar.hidden) {
        
        toolbarHeight = 0;
    }
    
    aRect.size.height -= self.keyboardSize.height + toolbarHeight;
    
    CGPoint textRectBoundary = CGPointMake(textFieldRect.origin.x, textFieldRect.origin.y + textFieldRect.size.height + 20);
   
    if (!CGRectContainsPoint(aRect, textRectBoundary) || scrollView.contentOffset.y >= 0) {
        
        CGPoint scrollPoint = CGPointMake(0.0, self.superview.frame.origin.y + _textField.frame.origin.y + 20 - aRect.size.height);
        
        if (scrollPoint.y < 0) scrollPoint.y = 0;
        
        [scrollView setContentOffset:scrollPoint animated:animated];
    }
}

- (BOOL)validate
{
    //self.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.5];
    
    if (required && [self.text isEqualToString:@""]){
        return NO;
    }
    else if (_isEmailField){
        NSString *emailRegEx =
        @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[a-"
        @"z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if (![emailTest evaluateWithObject:self.text]){
            return NO;
        }
    }

    //[self setBackgroundColor:[UIColor whiteColor]];
    
    return YES;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (!enabled)
        [self setBackgroundColor:[UIColor lightGrayColor]];
}

#pragma mark - UITextField notifications

- (void)textFieldDidBeginEditing:(NSNotification *) notification
{
    UITextField *textField = (UITextField*)[notification object];
    
    _textField = textField;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setBarButtonNeedsDisplayAtTag:(int)textField.tag];
    
    if ([self.superview isKindOfClass:[UIScrollView class]] && self.scrollView == nil)
        self.scrollView = (UIScrollView*)self.superview;
    
    [self selectInputView:textField];
    [self setInputAccessoryView:toolbar];
    
    [self setDoneCommand:NO];
    [self setToolbarCommand:NO];
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" " attributes:@{NSForegroundColorAttributeName:[UIColor clearColor]}];
    
}

- (void)textFieldDidEndEditing:(NSNotification *) notification
{
    UITextField *textField = (UITextField*)[notification object];

    [self validate];
    
    _textField = nil;
    
    if (_isDateField && [textField.text isEqualToString:@""] && _isDoneCommand){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"MM/dd/YY"];
        
        [textField setText:[dateFormatter stringFromDate:[NSDate date]]];
    }
    
    self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeHolderTemp attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
}

-(BOOL)getKeyboardIsShown{
    
    for (int i = 0; i < self.textFields.count; ++i) {
        
        TextField *tf = [self.textFields objectAtIndex:i];
        if (tf.keyboardIsShown) {
            
            return true;
        }
    }
    
    return false;
}

-(void)calculateKeyboardHeightForScrollViewForStatus:(BOOL)isShown{

    if (isShown) {
        
        CGSize bkgndSize = self.scrollView.contentSize;
        bkgndSize.height += self.keyboardSize.height;
        self.scrollView.contentSize = bkgndSize;
        self.isKeyboardHeightCalculated = true;
    }else{
    
        for (int i = 0; i < self.textFields.count; ++i) {
            
            TextField *tf = [self.textFields objectAtIndex:i];
            if (tf.isKeyboardHeightCalculated) {
                
                CGSize bkgndSize = self.scrollView.contentSize;
                bkgndSize.height -= tf.keyboardSize.height;
                self.scrollView.contentSize = bkgndSize;
                tf.isKeyboardHeightCalculated = false;
            }
        }
    }
}

-(void)setKeyboardStatusToHidden:(BOOL)isHidden{

    for (int i = 0; i < self.textFields.count; ++i) {
        
        TextField *tf = [self.textFields objectAtIndex:i];
        tf.keyboardIsShown = !isHidden;
    }
}

-(BOOL)isIphone6Plus{
    
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && ScreenHeight >= 736.0);
}

-(void)rightButtonPressed:(id)sender{
    
    if (self.tfDelegate && [self.tfDelegate respondsToSelector:@selector(didTouchRightButton:)]) {
        
        [self.tfDelegate didTouchRightButton:self];
    }
}

-(void)leftButtonPressed:(id)sender{

    if (self.tfDelegate && [self.tfDelegate respondsToSelector:@selector(didTouchLeftButton:)]) {
        
        [self.tfDelegate didTouchLeftButton:self];
    }
}

-(CGFloat)getTextLengthInPixel:(NSString*)text withFont:(UIFont*)font{

    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.text = text;
    tempLabel.font = font;
    tempLabel.numberOfLines = 1;
    CGSize maximumLabelSize = CGSizeMake(200, 9999);
    
    CGSize expectedSize = [tempLabel sizeThatFits:maximumLabelSize];
    
    return expectedSize.width;
}

#pragma mark - public methods
-(void)setDefaultTextField{
    
    // Set font for text
    UIColor *textFontColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0];
    UIFont *textFont = [UIFont fontWithName:kRegularFontName size:kMediumFontSize];
    self.textColor = textFontColor;
    self.font = textFont;
    
    // Set font for placeholder
    UIColor *placeholderFontColor = [UIColor whiteColor];
    UIFont *placeholderFont = [UIFont fontWithName:kLightFontName size:kMediumFontSize];
    NSDictionary *placeholderFontDic = @{NSForegroundColorAttributeName:placeholderFontColor, NSFontAttributeName:placeholderFont};
    
    self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.placeholder == nil ? @"" : self.placeholder attributes:placeholderFontDic];
    
    // set color for cursor
    self.tintColor = [UIColor whiteColor];
    
    // clear back color
    self.backgroundColor = [UIColor clearColor];
    
    // set border
    self.layer.borderColor = kDefaultBorderColor.CGColor;
    self.layer.borderWidth = defaultBorderWidth;
    
    self.placeholder = placeHolderTemp == nil ? @" " : placeHolderTemp;
    placeHolderColor = placeholderFontColor;
    
    
}

-(void)setPlaceholderText:(NSString*)placeholderString{
    
    placeHolderTemp = [placeholderString isEqualToString:@""] ? @" " : placeholderString;
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolderTemp attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
}

//MARK initializers to setup
-(void) setDefaultTextFieldWithPlaceHolder:(NSString*)placeholder{
    
    [self setPlaceholderText:placeholder];
    [self setDefaultTextField];
}

-(void)setBorder{
    
    // set border
    self.layer.borderColor = kDefaultBorderColor.CGColor;
    self.layer.borderWidth = defaultBorderWidth; //0.5
}

-(void)setNoBorder{
    
    self.layer.borderWidth = 0.0;
}

-(void)addImageWithName:(NSString *)imageName forViewType:(ViewType)viewType{
    
    if (imageName != nil && ![imageName isEqualToString:@""]) {
        
        CGSize scaleSize = CGSizeMake(self.frame.size.height, self.frame.size.height);
        UIImage *image = [UIImage imageNamed:imageName];
        UIGraphicsBeginImageContextWithOptions(scaleSize, false, 0.0);
        [image drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIView *addedView = [[UIView alloc] init];
        addedView.frame = CGRectMake(0, 0, scaleSize.width, scaleSize.height);
        UIImageView *imagev = [[UIImageView alloc] initWithImage:resizedImage];
        
        [addedView addSubview:imagev];
        
        if (viewType == ViewTypeLeft || viewType == ViewTypeBoth) {
            
            self.leftViewMode = UITextFieldViewModeAlways;
            self.leftView = addedView;
        }
        
        if (viewType == ViewTypeRight || viewType == ViewTypeBoth){
        
            self.rightViewMode = UITextFieldViewModeAlways;
            self.rightView = addedView;
        }
    }
}

-(void)addButtonWithTitle:(NSString*)title forViewType:(ViewType)viewType{

    if (title && ![title isEqualToString:@""]) {
        
        CGSize scaleSize = CGSizeMake(self.frame.size.height, self.frame.size.height);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, scaleSize.width, scaleSize.height);
        
        [button setTitle:title forState:UIControlStateNormal];
        
        if (viewType == ViewTypeLeft || viewType == ViewTypeBoth) {
            
            self.leftViewMode = UITextFieldViewModeAlways;
            [button addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            self.leftView = button;
        }
        
        if (viewType == ViewTypeRight || viewType == ViewTypeBoth){
            
            self.rightViewMode = UITextFieldViewModeAlways;
            [button addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            self.rightView = button;
        }
    }
}

-(void)addButtonWithImageName:(NSString*)imageName forViewType:(ViewType)viewType{

    if (imageName && ![imageName isEqualToString:@""]) {
    
        CGSize scaleSize = CGSizeMake(self.frame.size.height, self.frame.size.height);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, scaleSize.width, scaleSize.height);
        
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIGraphicsBeginImageContextWithOptions(scaleSize, false, 0.0);
        [image drawInRect:(CGRectMake(0, 0, scaleSize.width, scaleSize.height))];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [button setImage:resizedImage forState:UIControlStateNormal];
        
        if (viewType == ViewTypeLeft || viewType == ViewTypeBoth) {
            
            self.leftViewMode = UITextFieldViewModeAlways;
            [button addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            self.leftView = button;
        }
        
        if (viewType == ViewTypeRight || viewType == ViewTypeBoth){
            
            self.rightViewMode = UITextFieldViewModeAlways;
            [button addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            self.rightView = button;
        }
    }
}

// MARK - add text for right view
-(void)addTitleForLeftView:(NSString*)title andTextColor:(UIColor*)color{

    if (title && [title isEqualToString:@""]) {
        
        self.leftViewMode = UITextFieldViewModeAlways;
        
        // get title length in pixel
        UIFont *titleFont = [UIFont fontWithName:kRegularFontName size:kMediumFontSize];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = titleFont;
        
        if (!color) {
            
            titleLabel.textColor = kTextFieldFontColor;
        }else{
        
            titleLabel.textColor = color;
        }
        
        titleLabel.text = title;
        
        // get frame for label
        CGFloat fAlignText = kLeftMargin;
        CGFloat fWidth = [self getTextLengthInPixel:title withFont:titleFont];
        CGRect frame = CGRectMake(fAlignText, 0, fWidth + fAlignText, CGRectGetHeight(self.frame));
        titleLabel.frame = frame;
        
        UIView *vContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fWidth + 2 * fAlignText,  CGRectGetHeight(self.frame))];
        [vContainerView addSubview:titleLabel];
        
        self.leftView = vContainerView;
    }
}

@end
