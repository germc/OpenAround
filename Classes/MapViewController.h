//
//  MapViewController.h
//  OpenAround
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import "GoogleSearchClient.h"


@interface MapViewController : UIViewController <GoogleSearchClientDelegate> {

	MKMapView *mapView_;
	MBProgressHUD *HUD_;

	NSString *titleString;
	NSString *queryString;
	CLLocation *currentLocation;
	NSArray *landmarks_;
	BOOL selectedNearestLandmark_;
	GoogleSearchClient *searchClient_;

}

@property (nonatomic, retain) IBOutlet MKMapView *mapView_;
@property (nonatomic, retain) MBProgressHUD *HUD_;
@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, retain) NSString *queryString;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSArray *landmarks_;
@property (nonatomic, assign) BOOL selectedNearestLandmark_;
@property (nonatomic, retain) GoogleSearchClient *searchClient_;

@end
