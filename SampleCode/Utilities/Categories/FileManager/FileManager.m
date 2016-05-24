//
//  FileManager.m
//  Sample Code
//
//  Created by NUS Technology on 9/11/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

#import "FileManager.h"
#import "NSString+GenerateRandomCode.h"

@implementation FileManager

+ (void)saveImage:(UIImage*)imageToSave toFile:(NSString *)filePath{
    
    NSData * binaryImageData = UIImagePNGRepresentation(imageToSave);
    
    [binaryImageData writeToFile:filePath atomically:YES];
}

+ (void)removeImage:(NSString *)fileName{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:fileName error:&error];
    if (success) {
        
    }
    else{
        
    }
}

#pragma mark - Generate Image name & path

+ (NSString*) generateImageName{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyy-HHmmss_SSS"];
    NSString *ret = [formatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@_%@", ret, [NSString generateRandomCode:3]];
}

+ (NSString*) generateImagePath{
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imageFileName = [FileManager generateImageName];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:imageFileName];
    
    return filePath;
}

+ (NSString*) getImagePathForFileName:(NSString *)fileName{
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}
@end
