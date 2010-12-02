//
//  MapSchemeHelper.h
//  OpenAround
//
//  Created by Watanabe Toshinori on 10/12/02.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapSchemeHelper : NSObject {
	
	int zoomLevel;
	MKMapType mapType;
	
}

@property (nonatomic, assign) int zoomLevel;
@property (nonatomic, assign) MKMapType mapType;

- (NSString *)urlStringWithQueryString:(NSString *)queryString;
- (NSString *)urlStringWithSourceCoordinate:(CLLocationCoordinate2D)srcCoordinate destinationCoordinate:(CLLocationCoordinate2D)destCoordinate;

@end
