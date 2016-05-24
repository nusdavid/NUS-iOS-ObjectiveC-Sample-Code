//
//  OfflineDataManager.h
//
//  Created by NUS Technology on 9/9/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OfflineDataManagerDelegate <NSObject>

@optional

-(void)didChangeConnectionStatus:(BOOL)isConnected;

-(void)didFailWithErrorWhenRequestAPI:(NSError *)error;
@end

@interface OfflineDataManager : NSObject <OfflineDataManagerDelegate>

@property(nonatomic) id<NSObject, OfflineDataManagerDelegate> delegate;

// Methods
-(void)startInternetNotifier;
-(void)stopInternetNotifier;
-(void)synchronizeData;
-(void)getLocalData;
@end
