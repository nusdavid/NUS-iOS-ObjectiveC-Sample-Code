//
//  TSDRequest.m
//  TechStartUpDeveloper
//
//  Created by Dev on 14/04/2014.
//  Copyright (c) 2014 TechStartUpDeveloper. All rights reserved.

#import "YDRequest.h"

@interface YDRequest ()
{
    NSURLRequest *request;
    NSURLConnection *connection;
    NSMutableData *webData;
    NSInteger httpStatusCode;
    void (^completion)(YDRequest* request, NSData* data, BOOL success);
}
@end

@implementation YDRequest

- (id)initWithRequest:(NSURLRequest*)req
{
    self = [super init];
    if (self != nil)
        {
        request = req;
        }
    return self;
}

- (id) initWithURL:(NSURL*)url withJSONDict:(NSDictionary*) jsonDict{

    NSError * error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString * stringJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60];
    
    
    //import to the the Content-Type to application/json to receive JSON format response
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPMethod:@"POST"];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[stringJSON length]];
    [req addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody: [stringJSON dataUsingEncoding:NSUTF8StringEncoding]];
   
    return [self initWithRequest:req];
    
}

- (NSString *)urlencode:(NSString *)input {
    const char *input_c = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *result = [NSMutableString new];
    for (NSInteger i = 0, len = strlen(input_c); i < len; i++) {
        unsigned char c = input_c[i];
        if (
            (c >= '0' && c <= '9')
            || (c >= 'A' && c <= 'Z')
            || (c >= 'a' && c <= 'z')
            || c == '-' || c == '.' || c == '_' || c == '~'
            ) {
            [result appendFormat:@"%c", c];
        }
        else {
            [result appendFormat:@"%%%02X", c];
        }
    }
    return result;
}


- (id) initWithURLEncodedForSMS:(NSURL*)url withJSONDict:(NSDictionary*) jsonDict{
    
    NSMutableString *urlEncodedData = [NSMutableString new];
    if (jsonDict != nil && jsonDict.count > 0) {
        BOOL first = YES;
        for (NSString *key in jsonDict) {
            if (!first) {
                [urlEncodedData appendString:@"&"];
            }
            first = NO;
            
            [urlEncodedData appendString:[self urlencode:key]];
            [urlEncodedData appendString:@"="];
            [urlEncodedData appendString:[self urlencode:[jsonDict valueForKey:key]]];
        }
    }
    
    //NSURL *url = [NSURL URLWithString:url_str];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPMethod:@"POST"];
    //[req setHTTPShouldHandleCookies:NO];
    //[req setValue:@"Agent name goes here" forHTTPHeaderField:@"User-Agent"];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[urlEncodedData length]];
    [req addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:[urlEncodedData dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    return [self initWithRequest:req];
}

- (id) initWithURLForUploadImage:(NSURL*)url withJSONDict:(NSDictionary*) jsonDict withImageData:(NSData*)imageData{
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble:timeStamp];
    
    NSString *file = nil;
    
    file = [NSString stringWithFormat:@"PICT_%@.png", [timeStampObj stringValue]];
    
    //NSString *urlString=[NSString stringWithFormat:@"%@?%@",CSUploadFileApiURL,strHttpBody];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
	//[req setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	//[req setTimeoutInterval:CSSUserServiceApiTimeOutInterval];
    [req setHTTPMethod:@"POST"];
    [req addValue:@"mobile" forHTTPHeaderField:@"source"];
    //[request setHTTPBody:[strHttpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[req addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    //Append id data in body
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [jsonDict objectForKey:@"user_id"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Append image data in body
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; file=\"%@\"\r\n", @"file_data[0]",file] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [req setHTTPBody:body];
    
    return [self initWithRequest:req];
}

- (id) initWithURLForGetPlacesByGoogleApi:(NSURL*)url{
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                   timeoutInterval:60];
    
    
    //import to the the Content-Type to application/json to receive JSON format response
    //[req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPMethod:@"GET"];
    //NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[stringJSON length]];
    //[req addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    //[req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //[req setHTTPBody: [stringJSON dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [self initWithRequest:req];
    
}

- (void)startWithCompletion:(void (^)(YDRequest* request, NSData* data, BOOL success))compl
{
    completion = [compl copy];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
        {
#if ! __has_feature(objc_arc)
        webData = [[NSMutableData data] retain];
#else
        webData = [[NSMutableData alloc] init];
#endif
        
        }
    else
        {
        completion(self, nil, NO);
        }
}
#if ! __has_feature(objc_arc)
- (void)dealloc
{
    if (webData != nil)
        [webData release];
    if (connection != nil)
        [connection release];
    [super dealloc];
}
#endif


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    completion(self, webData, httpStatusCode == 200 || httpStatusCode == 201);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    httpStatusCode = [httpResponse statusCode];

    [webData setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

    completion(self, webData, NO);
}

@end
