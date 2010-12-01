//
//  GooglePlacemark.m
//  Google Search
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import "GoogleLandmark.h"


@implementation GoogleLandmark

@synthesize accuracy;
@synthesize addressLines;
@synthesize addressLookupResult;
@synthesize city;
@synthesize content;
@synthesize country;
@synthesize ddUrl;
@synthesize ddUrlFromHere;
@synthesize ddUrlToHere;
@synthesize lat;
@synthesize lng;
@synthesize listingType;
@synthesize phoneNumbers;
@synthesize staticMapUrl;
@synthesize streetAddress;
@synthesize titleValue;
@synthesize titleNoFormatting;
@synthesize url;
@synthesize coordinate_;


#pragma mark -
#pragma mark Initialize

- (id)init {
	if (self = [super init]) {
		
		self.coordinate_ = kCLLocationCoordinate2DInvalid;
	}
							  
	return self;
}

- (NSString *)phoneNumber {
	if (phoneNumbers && [phoneNumbers count] > 0) {
		NSString *phoneNumber = [[phoneNumbers objectAtIndex:0] objectForKey:@"number"];
		if (phoneNumber && ![phoneNumber isEqualToString:@""]) {
			return phoneNumber;
		}
	}
	
	return nil;
}

- (NSString *)address {
	NSString *address = @"";
	if (streetAddress && [streetAddress length] > 0) {
		address = [address stringByAppendingFormat:@"%@%@", [address length] == 0 ? @"" :@"\r\n", streetAddress];
	}
	if (city && [city length] > 0) {
		address = [address stringByAppendingFormat:@"%@%@", [address length] == 0 ? @"" :@"\r\n", city];
	}
	
	return address;
}


#pragma mark -
#pragma mark MKAnnotation protocol

- (NSString *)title {
	return (addressLookupResult && [addressLookupResult isEqualToString:@"/maps"]) ? [addressLines lastObject]: titleNoFormatting;
}

- (NSString *)subtitle {
	if (addressLines && [addressLines count] > 0) {
		if ([addressLines count] > 1) {
			return [addressLines objectAtIndex:1];
		}
		return [addressLines objectAtIndex:0];
	}
	
	return nil;
}

- (CLLocationCoordinate2D)coordinate {
	if (!CLLocationCoordinate2DIsValid(coordinate_)) {
		self.coordinate_ = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);	
	}
	
	return coordinate_;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    self.accuracy = nil;
    self.addressLines = nil;
    self.addressLookupResult = nil;
    self.city = nil;
    self.content = nil;
    self.country = nil;
    self.ddUrl = nil;
    self.ddUrlFromHere = nil;
    self.ddUrlToHere = nil;
    self.lat = nil;
    self.lng = nil;
    self.listingType = nil;
    self.phoneNumbers = nil;
    self.staticMapUrl = nil;
    self.streetAddress = nil;
    self.titleValue = nil;
    self.titleNoFormatting = nil;
    self.url = nil;
	
	[super dealloc];
}

@end
