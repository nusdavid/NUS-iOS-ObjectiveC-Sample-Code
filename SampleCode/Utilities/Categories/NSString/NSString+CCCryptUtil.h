//
//  NSString+CCCryptUtil.h
//  Goal
//
//  Created by NUS Technology on 9/18/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (CCCryptUtil)


+ (NSData*)AES256Encrypt:(NSString*)strSource withKey:(NSString*)key;

+ (NSString*)AES256Decrypt:(NSData*)dataSource withKey:(NSString*)key;

@end
