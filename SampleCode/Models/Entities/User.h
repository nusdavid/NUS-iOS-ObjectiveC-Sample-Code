//
//  User.h
// Sample Code
//
//  Created by NUS Technology on 10/23/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface User:MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic,strong) NSString *identifier;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *password;

@end
