//
//  GoogleSearchQuery.h
//  Google Search
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface GoogleSearchCondition : NSObject {

	NSString *query;
	CLLocation *location;
	
}

@property (nonatomic, copy) NSString *query;
@property (nonatomic, retain) CLLocation *location;

- (NSString *)urlParameterString;

@end
