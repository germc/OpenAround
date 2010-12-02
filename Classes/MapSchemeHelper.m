//
//  MapSchemeHelper.m
//  OpenAround
//
//  Created by Watanabe Toshinori on 10/12/02.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import "MapSchemeHelper.h"
#import "NSString+EncodeURIComponent.h"


@interface MapSchemeHelper()
- (NSString *)mapUrlString;
- (NSString *)mapTypeForQuery;
@end


@implementation MapSchemeHelper

@synthesize zoomLevel;
@synthesize mapType;


#pragma mark -
#pragma mark Initialize

- (id)init {
	if (self = [super init]) {
		zoomLevel = 0;
		mapType = MKMapTypeStandard;
	}
	
	return self;
}


#pragma mark -
#pragma mark Public method

- (NSString *)urlStringWithQueryString:(NSString *)queryString {
	NSString *urlString = [self mapUrlString];
	
	if (queryString && [queryString length] > 0) {
		urlString = [urlString stringByAppendingFormat:@"&q=%@", [NSString stringEncodeURIComponent:queryString]];
	}
	
	return urlString;
}

- (NSString *)urlStringWithSourceCoordinate:(CLLocationCoordinate2D)srcCoordinate destinationCoordinate:(CLLocationCoordinate2D)destCoordinate {
	NSString *urlString = [self mapUrlString];

	if (CLLocationCoordinate2DIsValid(srcCoordinate)) {
		urlString = [urlString stringByAppendingFormat:@"&saddr=%f,%f", srcCoordinate.latitude, srcCoordinate.longitude];
	}
	if (CLLocationCoordinate2DIsValid(destCoordinate)) {
		urlString = [urlString stringByAppendingFormat:@"&daddr=%f,%f", destCoordinate.latitude, destCoordinate.longitude];
	}
	
	return urlString;
}


#pragma mark -
#pragma mark Private method

- (NSString *)mapUrlString {
	NSString *mapURL = [NSString stringWithFormat:@"http://maps.google.com/maps?t=%@", [self mapTypeForQuery]];
	
	if (zoomLevel > 0) {
		mapURL = [mapURL stringByAppendingFormat:@"&z=%d", zoomLevel];
	}
	
	return mapURL;
}

- (NSString *)mapTypeForQuery {
	switch (mapType) {
		case MKMapTypeSatellite:
			return @"k";
		case MKMapTypeHybrid:
			return @"h";
	}
	
	return @"m";
}

@end
