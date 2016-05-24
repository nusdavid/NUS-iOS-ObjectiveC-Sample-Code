//
//  YDAsyncQueue.m
//  GCDDownloader
//
//  Created by Dev on 03/09/2013.
//  Copyright (c) 2013 Dev. All rights reserved.
//

#import "YDAsyncQueue.h"
#import "YDAsyncRequest.h"
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
@interface YDAsyncQueue()<YDAsyncRequestDelegate>

{
    NSMutableArray* queuedRequests;
    NSUInteger _requestsInQueue;
}

@property(nonatomic,strong)dispatch_queue_t currentQueue;

@end

@implementation YDAsyncQueue

@synthesize requestsInQueue = _requestsInQueue;
@synthesize requestDidFinishSelector;
@synthesize requestDidFailSelector;
@synthesize queueDidFinishSelector;
@synthesize queueDidFailSelector;

#pragma mark constructors
-(id)initWithDispatchQueue:(dispatch_queue_t)aSyncQueue
{
  
    if ((self = [super init]))
    {
		  self.currentQueue = aSyncQueue;
          [self initializeQueue];
    }
	return self;
}
-(id)initWithQueuePriority:(dispatch_queue_priority_t)priority
{
    if ((self = [super init]))
    {
        dispatch_queue_t aSyncQueue = dispatch_get_global_queue(priority, 0);
        self.currentQueue = aSyncQueue;
        [self initializeQueue];
    }
	return self;
}
-(void)initializeQueue
{
    queuedRequests = [[NSMutableArray alloc]init];
    
}


//private methods
- (void)requestFinished:(YDAsyncRequest *)request
{
   [queuedRequests removeObject:request];
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        
    if ([self requestDidFinishSelector]) {
            SuppressPerformSelectorLeakWarning([[self delegate] performSelector:[self requestDidFinishSelector] withObject:self]);
        
	}
      });   
}

- (void)requestFailed:(YDAsyncRequest *)request
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        
	if ([self requestDidFailSelector]) {
        SuppressPerformSelectorLeakWarning([[self delegate] performSelector:[self requestDidFailSelector] withObject:self]);
        
	}
      });

}

- (void)queueFinished
{
    if ([self queueDidFinishSelector]) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            
            SuppressPerformSelectorLeakWarning([[self delegate] performSelector:[self queueDidFinishSelector] withObject:self]);
         });
	}
}

- (void)queueFailed
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        
    if ([self queueDidFailSelector]) {
            
            SuppressPerformSelectorLeakWarning([[self delegate] performSelector:[self queueDidFailSelector] withObject:self]);
        
	}
         });
}

#pragma mark public methods
//public methods

//adds a YDAsyncRequest to the queue
-(void)addRequest:(YDAsyncRequest *)request
{
    //need a queue to store it

    [queuedRequests addObject:request];
    _requestsInQueue = [queuedRequests count];
}
 
-(void)startQueue
{
    dispatch_async(self.currentQueue, ^{
        for (int i=0;i<[queuedRequests count];i++) {
            //execute the request
            YDAsyncRequest* currentRequest = [queuedRequests objectAtIndex:i];
            currentRequest.delegate=self;
            [currentRequest setRequestDidFinishSelector:@selector(requestFinished:)];
            [currentRequest setRequestDidFailSelector:@selector(requestFailed:)];
            [currentRequest startRequest];
        }
       });
}
 
#pragma mark selectors
 
#pragma mark request delegates
-(void)requestDidFinish
{
    if ([queuedRequests count]== 0)
    {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
               [self queueFinished];
             });
    }
}
-(void)requestDidFail
{
    if ([queuedRequests count]== 0)
    {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            [self queueFinished];
        });
    }
}
@end
