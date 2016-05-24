//
//  FileManager.h
//  Sample Code
//
//  Created by NUS Technology on 9/11/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject
+ (void)saveImage:(UIImage*)imageToSave toFile:(NSString *)filePath;
+ (void)removeImage:(NSString *)fileName;
+ (NSString*) generateImagePath;
+ (NSString*) getImagePathForFileName:(NSString *)fileName;
@end
