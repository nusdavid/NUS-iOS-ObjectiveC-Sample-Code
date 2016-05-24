//
//  User+Helper.m
//  Sample Code
//
//  Created by NUS Technology on 1/13/15.
//  Copyright (c) 2015 Dev. All rights reserved.
//

#import "User+Helper.h"

@implementation User (Helper)

-(id)init{
    
    self = [[CoreDataManager sharedInstance] intitializeAnEntityObjectByEntityName:User.entityName withClass:[User class] withIsForSaving:false];
    
    if (self) {
        
    }
    
    return self;
}

-(void)copyDataFromObject:(User*)source {
    
    self.email = source.email;
    self.password = source.password;
}

+ (NSString*)entityName{
    
    return @"User";
}

#pragma mark - local data
+ (User*)fetchUser:(NSString*)recordId{
    
    NSManagedObjectContext *context = [[CoreDataManager sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:[User managedObjectEntityName]
                                   inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"userId = %@", recordId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    User *returnedItem = nil;
    if(fetchedObjects){
        for (NSManagedObject *obj in fetchedObjects){
            
            //strong typecast
            NSError *convertingError = nil;
            returnedItem = [MTLManagedObjectAdapter modelOfClass:[User class] fromManagedObject:obj error:&convertingError];
        }
    }
    
    return returnedItem;
}

+ (BOOL) synchUsers:(NSArray *)users{
    
    NSManagedObjectContext *context = [[CoreDataManager sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:[User managedObjectEntityName]
                                   inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // get userid list
    NSMutableArray *userIds = [NSMutableArray new];
    for (User *user in users) {
        [userIds addObject:user.identifier];
    }
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"NOT (userId IN %@)", userIds]];
    
    // Make sure the results are sorted as well.
    [fetchRequest setSortDescriptors:
     @[[[NSSortDescriptor alloc] initWithKey: @"userId" ascending:YES]]];
    
    // Execute the fetch.
    NSError *error;
    NSArray *deletedUsers = [context executeFetchRequest:fetchRequest error:&error];
    
    for (id item in deletedUsers) {
        [context deleteObject:item];
    }
    
    error = nil;
    if (![context  save:&error]){
        
    }
    
    return true;
}

+ (NSArray*) parseUsers:(NSArray*)users{
    
    NSManagedObjectContext *context = [[CoreDataManager sharedInstance] managedObjectContext];
    NSMutableArray *usersList =[NSMutableArray arrayWithCapacity:0];
    
    for ( User *userRecord in users ){
        
        NSError * insertingError = nil;
        NSManagedObject *user = [MTLManagedObjectAdapter managedObjectFromModel:userRecord insertingIntoContext:context error:&insertingError];
        
        NSError * convertingError = nil;
        User *modelUser = [MTLManagedObjectAdapter modelOfClass:[User class] fromManagedObject:user error:&convertingError];
        
        if (!convertingError) {
            [usersList addObject:modelUser];
        }
    }
    
    NSError *error = nil;
    if (![context  save:&error]){
        
    }
    
    return usersList;
}

+(NSArray *)saveLocalItems:(NSArray *)items{
    
    [User synchUsers:items];
    
    return [User parseUsers:items];
}

+ (NSArray*) deleteUsers:(NSArray*)users{
    NSMutableArray * usersList =[NSMutableArray arrayWithCapacity:0];
    NSManagedObjectContext *context = [[CoreDataManager sharedInstance] managedObjectContext];
    
    for ( User * userRecord in users ){
        
        NSError * insertingError = nil;
        NSManagedObject *user = [MTLManagedObjectAdapter managedObjectFromModel:userRecord insertingIntoContext:context error:&insertingError];
        
        if (user) {
            
            [context deleteObject:user];
            
            NSError * convertingError = nil;
            User *modelUser = [MTLManagedObjectAdapter modelOfClass:[User class] fromManagedObject:user error:&convertingError];
            
            if (!convertingError) {
                [usersList addObject:modelUser];
            }
        }
    }
    
    NSError *error = nil;
    if (![context  save:&error]){
        
    }
    
    return usersList;
}
@end
