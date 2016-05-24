//
//  YDAsyncRequest.h
//  GCDDownloader
//
//  Created by Dev on 03/09/2013.
//  Copyright (c) 2013 Dev. All rights reserved.
//

 

#import <Foundation/Foundation.h>

@protocol YDAsyncRequestDelegate <NSObject>

-(void)requestDidFinish;
-(void)requestDidFail;
@end

@interface YDAsyncRequest : NSObject
{
    SEL requestDidFinishSelector;
    SEL requestDidFailSelector;
}
//constructor
-(id)initWithRequestWithURL:(NSURL *)url;


//public properties



@property (nonatomic, assign) id<YDAsyncRequestDelegate> delegate;
@property(nonatomic,strong)NSString* DownloadDestinationPath;

@property (assign) SEL requestDidFinishSelector;
@property (assign) SEL requestDidFailSelector;


//public methods
-(void)startRequest;
@end
