//
//  UIAlertView+Block.h
//
//  Created by NUS Technology on 9/9/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Block)

- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;

@end
