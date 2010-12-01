//
//  GoogleSearchClient.h
//  Google Search
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GoogleSearchCondition.h"

extern NSString *const GoogleSearchClientErrorDomain;

enum GoogleSearchClientErrorCode {
    GoogleSearchClientResponseError = 100,
	GoogleSearchClientNoResultError = 404,
};


@protocol GoogleSearchClientDelegate;

@interface GoogleSearchClient : NSObject {

	NSURLConnection *connection_;
	NSMutableData *data_;

	id<GoogleSearchClientDelegate> delegate;

}

@property (nonatomic, retain) NSURLConnection *connection_;
@property (nonatomic, retain) NSMutableData *data_;
@property (nonatomic, assign) id<GoogleSearchClientDelegate> delegate;

- (id)initWithDelegate:(id<GoogleSearchClientDelegate>)theDelegate;
- (void)searchWithCondition:(GoogleSearchCondition *)condition;
- (void)cancel;

@end


@protocol GoogleSearchClientDelegate

- (void)searchDidFinishWithLandmarks:(NSArray *)landmarks;
- (void)searchDidFailWithError:(NSError *)error;

@end
