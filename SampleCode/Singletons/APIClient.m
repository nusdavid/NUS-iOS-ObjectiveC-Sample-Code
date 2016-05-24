//
//  IDBandAPIClient.m
// Sample Code
//
//  Created by NUS Technology.
//  Copyright (c) 2013 Sample Code, LLC. All rights reserved.
//

@implementation APIClient

#pragma mark - Client Creation

+ (APIClient *)sharedInstance
{
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc]initWithBaseURL:
                         [NSURL URLWithString:[AppConfig forKey:@"apiBaseURL"]]
                                                       clientID:[AppConfig forKey:@"clientID"]
                                                         secret:[AppConfig forKey:@"clientSecret"]];
        AFOAuthCredential *savedCredential=[AFOAuthCredential retrieveCredentialWithIdentifier:_sharedClient.serviceProviderIdentifier];
        
        if (savedCredential.accessToken)
        {
            [_sharedClient setAuthorizationHeaderWithCredential:savedCredential];
        }
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
             clientID:(NSString *)clientID
               secret:(NSString *)secret
{
    self = [super initWithBaseURL:url clientID:clientID secret:secret];
    if (!self) {
        return nil;
    }
    //Accept Header
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return self;
}

#pragma mark - Signup
- (void)signUpWithParameters:(NSDictionary *)criteriaDictionary
                     success:(void (^)(BOOL success))success
                     failure:(void (^)(NSError *error))failure
{

        NSString *oauthPath = [NSString stringWithFormat:@"%@%@", [AppConfig forKey:@"apiBaseURL"], @"/signup"];
    
        [self POST:oauthPath parameters:criteriaDictionary success:^(AFHTTPRequestOperation *operation, id JSON) {
            BOOL successString = [[JSON valueForKeyPath:@"success"] boolValue];
            if (successString)
            {
                id userObject = [JSON objectForKey:@"user"];
                AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:[userObject valueForKey:@"authentication_token"] tokenType:[userObject valueForKey:@"token_type"] response:userObject];
                [AFOAuthCredential storeCredential:credential withIdentifier:self.serviceProviderIdentifier];
                
                // Authenticated set the authorization
                [self setAuthorizationHeaderWithCredential:credential];
                
                success(true);
            }
            else {//unsuccessful sign up
                NSError *error=[NSError errorWithDomain:@"IDBandAPI" code:400 userInfo:@{NSLocalizedDescriptionKey:[self errorStringFromAPIJSON:JSON]}];
                failure(error);
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //unsuccessful API post
            failure(error);
        }];
}

#pragma mark - Login

// Login with username & password
- (void)authorizeWithUsername:(NSString *)username password:(NSString *)password
                                   success:(void (^)(BOOL successful))success
                                   failure:(void (^)(NSError *error))failure
{
    NSString *oauthPath = [NSString stringWithFormat:@"%@%@", [AppConfig forKey:@"apiBaseURL"], kOAuthPath];
    
    DLog(@"%@", oauthPath);
    
    [self authenticateUsingOAuthWithURLString:oauthPath username:username password:password scope:nil success:^(AFOAuthCredential *credential) {
        
        id JSON = credential.authorizationResponse;
        BOOL successString = [[JSON valueForKeyPath:@"success"] boolValue];
        if (successString) {
        
            //store the credential for retrieval
            [AFOAuthCredential storeCredential:credential withIdentifier:self.serviceProviderIdentifier];
            
            // Authenticated set the authorization
            [self setAuthorizationHeaderWithCredential:credential];
            
            success(true);
        }else{
        
            NSError *error=[NSError errorWithDomain:@"IDBandAPI" code:400 userInfo:@{NSLocalizedDescriptionKey:[self errorStringFromAPIJSON:JSON]}];
            failure(error);
        }

    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Forgot Password

- (void)forgotPasswordWithParameters:(NSDictionary *)criteriaDictionary
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSError *error))failure
{
    NSString *oauthPath = [NSString stringWithFormat:@"%@%@", [AppConfig forKey:@"apiBaseURL"], @"/forgotpassword"];
    
    [self POST:oauthPath parameters:criteriaDictionary success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        BOOL successString = [[JSON valueForKeyPath:@"success"] boolValue];
        
        if (successString) {
            success(true);
        }
        else {
            
            //unsuccessful sign up
            NSError *error=[NSError errorWithDomain:@"IDBandAPI" code:400 userInfo:@{NSLocalizedDescriptionKey:[self errorStringFromAPIJSON:JSON]}];
            failure(error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //unsuccessful API post
        failure(error);
    }];

}

//Check keychain store
- (BOOL)checkKeyChainStore
{
    if ([UICKeyChainStore stringForKey:kKeychainUserName] && [UICKeyChainStore stringForKey:kKeyChainPassword]) {
        return YES;
    }
    return NO;
}

- (void)removeKeyChainStore
{
    [UICKeyChainStore removeItemForKey:kKeychainUserName];
    [UICKeyChainStore removeItemForKey:kKeyChainPassword];
}


// Relogin with exists account in keychain
- (void)authorizeWithKeychain:(void (^)(BOOL successful))success
                      failure:(void (^)(NSError *error))failure
{
    NSString *oauthPath = [NSString stringWithFormat:@"%@%@", [AppConfig forKey:@"apiBaseURL"], kOAuthPath];
    NSLog(@"%@", oauthPath);
    [self authenticateUsingOAuthWithURLString:oauthPath
                                     username:[UICKeyChainStore stringForKey:kKeychainUserName]
                                     password:[UICKeyChainStore stringForKey:kKeyChainPassword]
                                        scope:nil
                                      success:^(AFOAuthCredential *credential) {
        //store the credential for retrieval
        [AFOAuthCredential storeCredential:credential withIdentifier:self.serviceProviderIdentifier];
        
        // Authenticated set the authorization
        [self setAuthorizationHeaderWithCredential:credential];
                                          
        success(true);
                                          
    } failure:^(NSError *error) {
        failure(error);
    }];
}


#pragma mark - Check network connection
- (BOOL)isConnected
{
    AFNetworkReachabilityStatus currentStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (currentStatus == AFNetworkReachabilityStatusReachableViaWiFi || currentStatus == AFNetworkReachabilityStatusReachableViaWWAN)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - private methods

- (void)setAuthorizationHeaderWithCredential:(AFOAuthCredential *)theCredential
{
    //set the default authorization header
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%@",theCredential.accessToken]
                  forHTTPHeaderField:@"auth_token"];
    
    // Set email of user
    NSString *email = [UICKeyChainStore stringForKey:kKeychainUserName];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%@",email]
                  forHTTPHeaderField:@"email"];
}

- (NSString *)errorStringFromAPIJSON:(id)apiJSON
{
    NSString *errorCode = [apiJSON valueForKeyPath:@"error_code"];
    NSString *errorString;
    if ([@"0001" isEqualToString:errorCode]){
        errorString = @"Parameters missing or blank";
    }else if ([@"0002" isEqualToString:errorCode]){
        errorString = @"Validations error";
    }else if ([@"0003" isEqualToString:errorCode]){
        errorString = @"URL not found";
    }else if ([@"0004" isEqualToString:errorCode]){
        errorString = @"Record not found";
    }else if ([@"0005" isEqualToString:errorCode]){
        errorString = @"Access denied";
    }else if ([@"0006" isEqualToString:errorCode]){
        errorString = @"Positions are invalid(blank or null)";
    }else if ([@"0007" isEqualToString:errorCode]){
        errorString = @"Phone number is invalid";
    }else if ([@"9999" isEqualToString:errorCode]){
        errorString = @"Unknown";
    }else if ([@"0101" isEqualToString:errorCode]){
        errorString = @"Authentication token or email is wrong";
    }else if ([@"0102" isEqualToString:errorCode]){
        errorString = @"Email has already been taken";
    }else if ([@"0103" isEqualToString:errorCode]){
        errorString = @"Login with email or password is wrong";
    }else if ([@"0104" isEqualToString:errorCode]){
        errorString = @"Sign out unsuccessfully";
    }else if ([@"0105" isEqualToString:errorCode]){
        errorString = @"Email not found";
    }else if ([@"0106" isEqualToString:errorCode]){
        errorString = @"Current password is wrong";
    }else if ([@"6001" isEqualToString:errorCode]){
        errorString = @"Promotion code is invalid";
    }else if ([@"6002" isEqualToString:errorCode]){
        errorString = @"Stripe token is invalid";
    }else if ([@"6003" isEqualToString:errorCode]){
        errorString = @"Card not found";
    }else if ([@"1001" isEqualToString:errorCode]){
        errorString = @"Band product Id is invalid";
    }else{
        errorString = @"Unknown error";
    }
    
    return errorString;
}

@end
