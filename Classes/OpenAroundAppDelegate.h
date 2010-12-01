//
//  OpenAroundAppDelegate.h
//  OpenAround
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface OpenAroundAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;

	CLLocation *currentLocation;
	NSDate *locationManagerStartDate_;

@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;

	CLLocationManager *locationManager_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSDate *locationManagerStartDate_;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) CLLocationManager *locationManager;

- (void)saveContext;
- (CLLocation *)currentLocation;

- (NSURL *)applicationDocumentsDirectory;
- (NSString *)applicationDocumentsDirectoryPath;

@end

