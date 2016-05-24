//
//  IDBandAPIClient.h
// Sample Code
//
//  Created by NUS Technology
//  Copyright (c) 2013 Sample Code, LLC. All rights reserved.
//

#import "AFOAuth2Client.h"

@class Profile;
@class ProfileItem;
@class PersonProfile;

typedef void (^callSuccessBlock) (NSDictionary *data);
typedef void (^callFailedBlock) (NSError *error);
typedef void (^callFailedData) (NSDictionary *data, NSError *error);

@interface APIClient : AFOAuth2Client

+ (APIClient *)sharedInstance;

- (BOOL)isConnected;

- (void)authorizeWithKeychain:(void (^)(BOOL successful))success
                      failure:(void (^)(NSError *error))failure;

- (void)authorizeWithUsername:(NSString *)username password:(NSString *)password
                      success:(void (^)(BOOL successful))success
                      failure:(void (^)(NSError *error))failure;

- (void)forgotPasswordWithParameters:(NSDictionary *)criteriaDictionary
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSError *error))failure;

- (void)signUpWithParameters:(NSDictionary *)criteriaDictionary
                     success:(void (^)(BOOL success))success
                     failure:(void (^)(NSError *error))failure;
@end
