//
//  GoogleSearchQuery.m
//  Google Search
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import "GoogleSearchCondition.h"
#import "NSString+EncodeURIComponent.h"


@implementation GoogleSearchCondition

@synthesize query;
@synthesize location;


- (NSString *)urlParameterString {
	NSString *parameterString = @"?v=1.0&rsz=large";
	
	if (query) {
		NSString *queryString = [NSString stringEncodeURIComponent:query];
		parameterString = [parameterString stringByAppendingFormat:@"%@q=%@", [parameterString length] == 0 ? @"?" : @"&", queryString];
	}
	if (location) {
		parameterString = [parameterString stringByAppendingFormat:@"%@sll=%f,%f", [parameterString length] == 0 ? @"?" : @"&", location.coordinate.latitude, location.coordinate.longitude];
	}
	
	return parameterString;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    self.query = nil;
    self.location = nil;

	[super dealloc];
}

@end
