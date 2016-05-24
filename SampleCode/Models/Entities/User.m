//
//  User.m
// Sample Code
//
//  Created by NUS Technology on 10/23/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//

#import "User.h"
#import "NSString+CCCryptUtil.h"

@implementation User

#pragma mark - Mantle
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"identifier":@"id",
             @"email":@"email",
             @"password":NSNull.null
             };
}

#pragma mark - Managed object serialization
+ (NSString *)managedObjectEntityName {
    return User.entityName;
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    
    return @{
             @"identifier" : @"userId"
             };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"identifier"];
}

+ (NSValueTransformer *)passwordEntityAttributeTransformer {

    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str){
        return  [NSString AES256Encrypt:str withKey:@"SampleCode"];
    }reverseBlock:^(NSData *data){
        return [NSString AES256Decrypt:data withKey:@"SampleCode"];
    }];
}

@end
