//
//  LandmarkViewController.h
//  OpenAround
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GoogleLandmark.h"


@interface LandmarkViewController : UITableViewController {

	UIView *titleView_;
	UILabel *titleLabel_;
	UIView *actionsView_;
	UIButton *callButton_;
	UIButton *detailButton_;
	UIButton *mapButton_;

	GoogleLandmark *landmark;
	MKMapType mapType;

}

@property (nonatomic, retain) IBOutlet UIView *titleView_;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel_;
@property (nonatomic, retain) IBOutlet UIView *actionsView_;
@property (nonatomic, retain) IBOutlet UIButton *callButton_;
@property (nonatomic, retain) IBOutlet UIButton *detailButton_;
@property (nonatomic, retain) IBOutlet UIButton *mapButton_;
@property (nonatomic, retain) GoogleLandmark *landmark;
@property (nonatomic, assign) MKMapType mapType;

- (IBAction)call:(id)sender;
- (IBAction)detail:(id)sender;
- (IBAction)map:(id)sender;

@end
