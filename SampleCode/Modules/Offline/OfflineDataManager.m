//
//  OfflineDataManager.m
//
//  Created by NUS Technology on 9/9/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import "OfflineDataManager.h"
#import "AFNetworkReachabilityManager.h"
#import "APIClient.h"
#import "User+Helper.h"

@implementation OfflineDataManager{
    
    AFNetworkReachabilityManager *connectionManager;
}

-(id)init{
    
    self = [super init];
    if (self) {
        
        self.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
    
    return self;
}

#pragma mark - synchonize data
// Methods
-(void)startInternetNotifier{
    //[internetReachability startNotifier];
}
-(void)stopInternetNotifier{
    //[internetReachability stopNotifier];
}

// Called by Reachability whenever status changes.
- (void) reachabilityChanged:(NSNotification *)note
{

    APIClient *myClient = [APIClient sharedInstance];
    
    if (myClient.isConnected) {
        [self synchronizeData];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeConnectionStatus:)]) {
            [self.delegate didChangeConnectionStatus:YES];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeConnectionStatus:)]) {
                            [self.delegate didChangeConnectionStatus:NO];
                        }
    }
}

-(void)synchronizeData{
    
    
}

-(void)getLocalData{

    
}

#pragma mark - request error handler;
-(void)didFailWithErrorWhenRequestAPI:(NSError *)error{
    if (error.code == 1009) {
        
        [self showMessage:error.localizedDescription withTitle:@"Error"];
    }
}

#pragma mark - methods
-(void)showMessage:(NSString *)msg withTitle:(NSString *)title{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
@end
