//
//  KNPopUpSegue.m
//
//  Created by NUS Technology on 9/24/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import "PopUpSegue.h"

@implementation PopUpSegue

- (void)perform
{
    UIViewController *sourceController = self.sourceViewController;
    UIViewController *destinationController = self.destinationViewController;
    destinationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [sourceController presentViewController:destinationController animated:YES completion:^{
        
    }];
    
    [destinationController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    } completion:nil];
}

@end
