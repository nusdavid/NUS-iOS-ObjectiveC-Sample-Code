//
//  TextField.h
//
//  Created by NUS Technology on 4/11/13.
//  Copyright (c) 2013 NUS Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ViewTypeLeft = 0,
    ViewTypeRight,
    ViewTypeBoth
}ViewType;

@protocol TextFieldDelegate <NSObject>
    
@optional
-(void)didTouchRightButton:(id)sender;
-(void)didTouchLeftButton:(id)sender;
@end

@interface TextField : UITextField

@property (nonatomic) BOOL required;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, setter = setDateField:) BOOL isDateField;
@property (nonatomic, setter = setEmailField:) BOOL isEmailField;

@property (nonatomic)id<NSObject, TextFieldDelegate> tfDelegate;

-(void)setPlaceholderText:(NSString*)placeholderString;
-(void)setDefaultTextField;
-(void)setDefaultTextFieldWithPlaceHolder:(NSString*)placeholder;
-(void)setBorder;
-(void)setNoBorder;
-(void)addImageWithName:(NSString *)imageName forViewType:(ViewType)viewType;
-(void)addButtonWithTitle:(NSString*)title forViewType:(ViewType)viewType;
-(void)addButtonWithImageName:(NSString*)imageName forViewType:(ViewType)viewType;
-(void)addTitleForLeftView:(NSString*)title andTextColor:(UIColor*)color;
@end
