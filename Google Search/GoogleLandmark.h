//
//  GooglePlacemark.h
//  Google Search
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface GoogleLandmark : NSObject <MKAnnotation> {

	NSString *accuracy;
	NSArray *addressLines;
	NSString *addressLookupResult;
	NSString *city;
	NSString *content;
	NSString *country;
	NSString *ddUrl;
	NSString *ddUrlFromHere;
	NSString *ddUrlToHere;
	NSString *lat;
	NSString *lng;
	NSString *listingType;
	NSArray *phoneNumbers;
	NSString *staticMapUrl;
	NSString *streetAddress;
	NSString *titleValue;
	NSString *titleNoFormatting;
	NSString *url;

	CLLocationCoordinate2D coordinate_;

}

@property (nonatomic, retain) NSString *accuracy;
@property (nonatomic, retain) NSArray *addressLines;
@property (nonatomic, retain) NSString *addressLookupResult;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *ddUrl;
@property (nonatomic, retain) NSString *ddUrlFromHere;
@property (nonatomic, retain) NSString *ddUrlToHere;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *lng;
@property (nonatomic, retain) NSString *listingType;
@property (nonatomic, retain) NSArray *phoneNumbers;
@property (nonatomic, retain) NSString *staticMapUrl;
@property (nonatomic, retain) NSString *streetAddress;
@property (nonatomic, retain) NSString *titleValue;
@property (nonatomic, retain) NSString *titleNoFormatting;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate_;

- (NSString *)phoneNumber;
- (NSString *)address;

@end
