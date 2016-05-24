//
//  YDAsyncQueue.h
//  GCDDownloader
//
//  Created by Dev on 03/09/2013.
//  Copyright (c) 2013 Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

//This is theAsyncQueue
@class YDAsyncRequest;

@protocol YDAsyncQueueDelegate <NSObject>

 

@end

@interface YDAsyncQueue : NSObject

{
    // Will be called when a request completes with the request as the argument
    SEL requestDidFinishSelector;
    SEL requestDidFailSelector;
    
    SEL queueDidFinishSelector;
    SEL queueDidFailSelector;
}
//public properties
@property (nonatomic, assign) id<YDAsyncQueueDelegate> delegate;

@property (assign) SEL requestDidFinishSelector;
@property (assign) SEL requestDidFailSelector;

@property (assign) SEL queueDidFinishSelector;
@property (assign) SEL queueDidFailSelector;

@property(nonatomic,readonly) NSUInteger requestsInQueue;
//selectors




//pconstructor
-(id)initWithDispatchQueue:(dispatch_queue_t)aSyncQueue;
-(id)initWithQueuePriority:(dispatch_queue_priority_t)priority;
//public methods
-(void)addRequest:(YDAsyncRequest *)request;


-(void)startQueue;

@end
