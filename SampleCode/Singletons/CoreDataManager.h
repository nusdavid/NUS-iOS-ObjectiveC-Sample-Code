//
//  CoreDataManager.h
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//
// Manager for core data ( local database )
#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Mantle/Mantle.h"

@interface CoreDataManager : NSObject

// Context for CoreData
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// Object model for CoreData
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

// Persistent store coordinator for CoreData
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Save context
- (void)saveContext;

// Get singleton instance
+ (CoreDataManager*)sharedInstance;

- (id)intitializeAnEntityObjectByEntityName:(NSString *)name withClass:(Class)class withIsForSaving:(BOOL)forSaving;

@end
