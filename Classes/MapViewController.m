//
//  MapViewController.m
//  OpenAround
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import "MapViewController.h"
#import "OpenAroundAppDelegate.h"
#import "LandmarkViewController.h"
#import "GoogleSearchCondition.h"
#import "GoogleLandmark.h"


@interface MapViewController ()
- (void)searchLandmarks;
- (void)selectNearestLandmark;
@end


@implementation MapViewController

@synthesize mapView_;
@synthesize HUD_;
@synthesize titleString;
@synthesize queryString;
@synthesize currentLocation;
@synthesize landmarks_;
@synthesize selectedNearestLandmark_;
@synthesize searchClient_;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = titleString;
	
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];

	// Get current location
	UIApplication *application = [UIApplication sharedApplication];
	self.currentLocation = ((OpenAroundAppDelegate *)application.delegate).currentLocation;

	// Setup MapView
	mapView_.showsUserLocation = YES;
	
	MKCoordinateSpan span;
	span.latitudeDelta=0.025;
	span.longitudeDelta=0.025;
	
	MKCoordinateRegion parisRegion;
	parisRegion.span=span;
	parisRegion.center=currentLocation.coordinate;

	[mapView_ setRegion:parisRegion animated:NO];
	
	if (landmarks_) {
		[mapView_ addAnnotations:landmarks_];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (!landmarks_) {
		[self searchLandmarks];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}


#pragma mark -
#pragma mark Private method

- (void)searchLandmarks {

	GoogleSearchCondition *condition = [[GoogleSearchCondition alloc] init];
	condition.query = queryString;
	condition.location = currentLocation;
	self.searchClient_ = [[[GoogleSearchClient alloc] initWithDelegate:self] autorelease];
	[searchClient_ searchWithCondition:condition];
	[condition release];
	
	self.HUD_ = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD_];
	HUD_.labelText =NSLocalizedString(@"Loading", nil);
	[HUD_ show:YES];
}

- (void)selectNearestLandmark {
	if (landmarks_ && [landmarks_ count] > 0 && [[mapView_ selectedAnnotations] count] == 0) {
		GoogleLandmark *landmark = [landmarks_ objectAtIndex:0];
		[mapView_ selectAnnotation:landmark animated:YES];
		
		self.selectedNearestLandmark_ = YES;
	}
}


#pragma mark -
#pragma mark GoogleSearchClient delegate

- (void)searchDidFinishWithLandmarks:(NSArray *)landmarks {
	
	[HUD_ hide:YES];
	self.HUD_ = nil;
	
	self.landmarks_ = landmarks;

	[mapView_ addAnnotations:landmarks_];
}

- (void)searchDidFailWithError:(NSError *)error {

	[HUD_ hide:YES];
	self.HUD_ = nil;
	
	self.landmarks_ = [NSArray array];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
	
	if ([annotation isKindOfClass:[GoogleLandmark class]]) {
		NSString *reuseIdentifier = @"PinView";
		MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
		if (!annotationView) {
			annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier] autorelease];
		} else {
			annotationView.annotation = annotation;
		}
		annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		annotationView.canShowCallout = YES;
		annotationView.animatesDrop = YES;
		
		return annotationView;
	}
	
	return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	if (!selectedNearestLandmark_) {
		[self performSelector:@selector(selectNearestLandmark) withObject:nil afterDelay:1.0];
	}
}

- (void)mapView:(MKMapView*)mapView annotationView:(MKAnnotationView*)view calloutAccessoryControlTapped:(UIControl*)control {
	[mapView deselectAnnotation:view.annotation animated:NO];
	
	GoogleLandmark *landmark = (GoogleLandmark *)view.annotation;
	
	LandmarkViewController *viewController = [[LandmarkViewController alloc] initWithNibName:@"LandmarkViewController" bundle:nil];
	viewController.landmark = landmark;
	viewController.mapType = mapView_.mapType;
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

- (void)dealloc {
	self.searchClient_ = nil;
	
	self.titleString = nil;
	self.queryString = nil;
    self.currentLocation = nil;
    self.landmarks_ = nil;

	self.mapView_ = nil;
	self.HUD_ = nil;
    [super dealloc];
}


@end
