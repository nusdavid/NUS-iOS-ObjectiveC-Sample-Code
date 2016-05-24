//
//  YDAsyncRequest.m
//  GCDDownloader
//
//  Created by Dev on 03/09/2013.
//  Copyright (c) 2013 Dev. All rights reserved.
//

#import "YDAsyncRequest.h"
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
@interface YDAsyncRequest()

{
    NSInteger fileSize;
    NSInteger bytesDownloaded;
    NSMutableData *data_;
   
}

@property(nonatomic,strong)NSURL* reqURL;
@property (nonatomic, retain, readwrite) NSOutputStream* fileStream;
@property (nonatomic, assign, readonly)  BOOL isReceiving;
@property (nonatomic, retain, readwrite) NSURLConnection* connection;

 

@end

@implementation YDAsyncRequest

@synthesize requestDidFinishSelector;
@synthesize requestDidFailSelector;
 

#pragma mark constructors
-(id)initWithRequestWithURL:(NSURL *)url
{
    
    if ((self = [super init]))
    {
        self.reqURL = url;
    }
	return self;
}
-(void)startRequest
{
    //create filestream
    
    self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.DownloadDestinationPath append:NO];
    //open the stream
    [self.fileStream open];
    // create the request
    NSURLRequest * request = [NSURLRequest requestWithURL:self.reqURL];
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error)
     {
         if ([data length] >0 && error == nil)
         {
             NSInteger       dataLength;
             const uint8_t * dataBytes;
             NSInteger       bytesWritten;
             NSInteger       bytesWrittenSoFar;
             dataLength = [data length];
             dataBytes  = [data bytes];
             bytesWrittenSoFar = 0;
             
             do {
                 bytesWritten = [self.fileStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
                 if (bytesWritten == -1) {
                     [self requestFailed];
                     break;
                 } else {
                     bytesWrittenSoFar += bytesWritten;
                 }
                 bytesDownloaded+=bytesWritten;
             } while (bytesWrittenSoFar != dataLength);
             
                [self requestFinished];
         }
         else if ([data length] == 0 && error == nil)
         {
              [self requestFinished];
         }
         else if (error != nil){
              [self requestFailed];
         }
         
     }];
  
}

- (void)shutDownConnectionAndStream
// Shuts down the connection and stream
{
    if (self.connection != nil) {
        [self.connection cancel];
        self.connection = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
  
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse * httpResponse;
    httpResponse = (NSHTTPURLResponse *) response;
    //read the content length from the header field
    fileSize = [[[httpResponse allHeaderFields] valueForKey:@"Content-Length"] integerValue];
    bytesDownloaded=0;
    //check the status code
    if (httpResponse.statusCode !=200) {
      [self requestFailed];
    }  
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
// delegate called by the NSURLConnection as data arrives.
// just write the data to the file.
{   //you need some variable to keep track on where you are writing bytes coming in over the data stream
    NSInteger       dataLength;
    const uint8_t * dataBytes;
    NSInteger       bytesWritten;
    NSInteger       bytesWrittenSoFar;
    dataLength = [data length];
    dataBytes  = [data bytes];
    bytesWrittenSoFar = 0;
    
    do {
        bytesWritten = [self.fileStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
        if (bytesWritten == -1) {
            [self requestFailed];
            break;
        } else {
            bytesWrittenSoFar += bytesWritten;
        }
            bytesDownloaded+=bytesWritten;
    } while (bytesWrittenSoFar != dataLength);
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
   [self requestFailed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    [self requestFinished];
}

//private methods
- (void)requestFinished
{
    [self shutDownConnectionAndStream];
	if ([self requestDidFinishSelector]) {
           SuppressPerformSelectorLeakWarning([[self delegate] performSelector:[self requestDidFinishSelector] withObject:self]);
       
	}
    
    //call delegate
    if([self.delegate respondsToSelector:@selector(requestDidFinish)])
        [self.delegate requestDidFinish];
    
}

- (void)requestFailed
{
    [self shutDownConnectionAndStream];   
	if ([self requestDidFailSelector]) {
           
            SuppressPerformSelectorLeakWarning([[self delegate] performSelector:[self requestDidFailSelector] withObject:self]);
        
	}
    //call delegate
    if([self.delegate respondsToSelector:@selector(requestDidFail)])
        [self.delegate requestDidFail];
}


@end
