//
//  NSString+CCCryptUtil.m
//  Goal
//
//  Created by NUS Technology on 9/18/14.
//
//

#import "NSString+CCCryptUtil.h"
#import "NSData+CCCryptUtil.h"
#import "NSString+MD5.h"

@implementation NSString (CCCryptUtil)

// md5

+ (NSData*)AES256Encrypt:(NSString*)strSource withKey:(NSString*)key {
    NSData *dataSource = [strSource dataUsingEncoding:NSUTF8StringEncoding];
    return [dataSource AES256EncryptWithKey:[key MD5]];
}

+ (NSString*)AES256Decrypt:(NSData*)dataSource withKey:(NSString*)key {
    NSData *decryptData = [dataSource AES256DecryptWithKey:[key MD5]];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}

@end
