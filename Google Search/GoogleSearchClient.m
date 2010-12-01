//
//  GoogleSearchClient.m
//  Google Search
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import "GoogleSearchClient.h"
#import "GoogleLandmark.h"
#import "NSString+SBJSON.h"


NSString *const GoogleSearchClientErrorDomain = @"GoogleSearchClientErrorDomain";


@implementation GoogleSearchClient

@synthesize connection_;
@synthesize data_;
@synthesize delegate;


#pragma mark -
#pragma mark Initialization

- (id)initWithDelegate:(id<GoogleSearchClientDelegate>)theDelegate {
	if (self = [super init]) {
		self.delegate = theDelegate;
	}
	
	return self;
}


#pragma mark -
#pragma mark Search

- (void)searchWithCondition:(GoogleSearchCondition *)condition {
	
	if (!condition) {
		return;
	}
	
	NSString *urlString = [@"http://ajax.googleapis.com/ajax/services/search/local" stringByAppendingString:[condition urlParameterString]];
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	self.connection_ = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)cancel {
	if (connection_) {
		[connection_ cancel];
	}
	
	self.connection_ = nil;
}


#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.data_ = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[data_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

	NSString *string = [[NSString alloc] initWithData:data_ encoding:NSUTF8StringEncoding];
	NSDictionary *json = [string JSONValue];
	[string release];
	
	DLog(@"%@", [json description]);

	self.data_ = nil;
	self.connection_ = nil;
	
	NSNumber *responseStatus = (NSNumber *)[json objectForKey:@"responseStatus"];
	if ([responseStatus intValue] != 200) {

		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Server response error." forKey:NSLocalizedDescriptionKey];
		NSError *error = [NSError errorWithDomain:GoogleSearchClientErrorDomain code:GoogleSearchClientResponseError userInfo:userInfo];
		
		if ([(id)delegate respondsToSelector:@selector(searchDidFailWithError:)]) {
			[delegate searchDidFailWithError:error];
		}

		return;
	}
	
	NSMutableArray *landmarks = [NSMutableArray array];
	
	NSDictionary *responseData = [json objectForKey:@"responseData"];
	NSArray *results = [responseData objectForKey:@"results"];
	
	for (NSDictionary *result in results) {
		GoogleLandmark *landmark = [[GoogleLandmark alloc] init];
		
		landmark.accuracy = [result objectForKey:@"accuracy"];
		landmark.addressLines = [result objectForKey:@"addressLines"];
		landmark.addressLookupResult = [result objectForKey:@"addressLookupResult"];
		landmark.city = [result objectForKey:@"city"];
		landmark.content = [result objectForKey:@"content"];
		landmark.country = [result objectForKey:@"country"];
		landmark.ddUrl = [result objectForKey:@"ddUrl"];
		landmark.ddUrlFromHere = [result objectForKey:@"ddUrlFromHere"];
		landmark.ddUrlToHere = [result objectForKey:@"ddUrlToHere"];
		landmark.lat = [result objectForKey:@"lat"];
		landmark.lng = [result objectForKey:@"lng"];
		landmark.listingType = [result objectForKey:@"listingType"];
		landmark.phoneNumbers = [result objectForKey:@"phoneNumbers"];
		landmark.staticMapUrl = [result objectForKey:@"staticMapUrl"];
		landmark.streetAddress = [result objectForKey:@"streetAddress"];
		landmark.titleValue = [result objectForKey:@"title"];
		landmark.titleNoFormatting = [result objectForKey:@"titleNoFormatting"];
		landmark.url = [result objectForKey:@"url"];
		
		[landmarks addObject:landmark];
		
		[landmark release];
	}
	
	if ([(id)delegate respondsToSelector:@selector(searchDidFinishWithLandmarks:)]) {
		[delegate searchDidFinishWithLandmarks:landmarks];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

	self.data_ = nil;
	self.connection_ = nil;

	if ([(id)delegate respondsToSelector:@selector(searchDidFailWithError:)]) {
		[delegate searchDidFailWithError:error];
	}	
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	if (connection_) {
		[connection_ cancel];
	}
    self.connection_ = nil;
    self.data_ = nil;
	
	[super dealloc];
}

@end
