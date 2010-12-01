//
//  LandmarkViewController.m
//  OpenAround
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import "LandmarkViewController.h"
#import "NSString+EncodeURIComponent.h"
#import "OpenAroundAppDelegate.h"
#import "MenuTableViewCell.h"


@interface LandmarkViewController ()
- (void)resizeTitleView;
- (void)openURLString:(NSString *)urlString;
- (NSString *)mapTypeForQuery;
@end


@implementation LandmarkViewController

@synthesize titleView_;
@synthesize titleLabel_;
@synthesize actionsView_;
@synthesize callButton_;
@synthesize detailButton_;
@synthesize mapButton_;
@synthesize landmark;
@synthesize mapType;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Info", nil);

	// Setup table header and footer.
	titleLabel_.text = [landmark title];
	[self resizeTitleView];
	self.tableView.tableHeaderView = titleView_;
	self.tableView.tableFooterView = actionsView_;
	
	// Setup action buttons.
	NSString *phoneNumber = [landmark phoneNumber];
	if (!phoneNumber || [phoneNumber isEqualToString:@""]) {
		callButton_.enabled = NO;
	}
	
	NSString *detail = landmark.url;
	if (!detail || [detail isEqualToString:@""]) {
		detailButton_.enabled = NO;
	}
}


#pragma mark -
#pragma mark Public method

- (IBAction)call:(id)sender {
	NSString *urlString = [NSString stringWithFormat:@"tel:%@", [landmark phoneNumber]];
	[self openURLString:urlString];
}

- (IBAction)detail:(id)sender {
	NSString *urlString = landmark.url;
	[self openURLString:urlString];
}

- (IBAction)map:(id)sender {
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@&z=%d&t=%@", [NSString stringEncodeURIComponent:[landmark title]], 12, [self mapTypeForQuery]];
	[self openURLString:urlString];
}


#pragma mark -
#pragma mark Private method

- (void)resizeTitleView {
	CGSize size = [titleLabel_.text sizeWithFont:titleLabel_.font
							   constrainedToSize:CGSizeMake(280, 320)
								   lineBreakMode: UILineBreakModeCharacterWrap];
	
	titleLabel_.frame = CGRectMake(20, 20, size.width, size.height);
	titleView_.frame = CGRectMake(0, 0, 320, titleLabel_.frame.origin.y + titleLabel_.frame.size.height + 20);
}

- (void)openURLString:(NSString *)urlString {

	UIApplication *application = [UIApplication sharedApplication];
	NSURL *url = [NSURL URLWithString:urlString];
	
	if ([application canOpenURL:url]) {
		[application openURL:url];
	} else {
		NSString *message = [NSString stringWithFormat:@"%@\r\n%@", NSLocalizedString(@"Your device can't open this URL", nil), urlString];
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 2) {
		return 2;
	}
	return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {   
	if (indexPath.section == 0 || indexPath.section == 1 ) {
		UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];

		CGSize bounds = CGSizeMake(self.tableView.frame.size.width - 150, self.tableView.frame.size.height);
		CGSize size = [cell.detailTextLabel.text sizeWithFont: cell.detailTextLabel.font 
											constrainedToSize: bounds 
												lineBreakMode: UILineBreakModeCharacterWrap];
		
		return size.height > 24 ? size.height + 20 : 44;
	}
	
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0 || indexPath.section == 1) {
	
		static NSString *CellIdentifier = @"InformationCell";
		
		MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.detailTextLabel.numberOfLines = 0;
		cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];

		switch (indexPath.section) {
			case 0:{
				cell.textLabel.text = NSLocalizedString(@"phone", nil);
				cell.detailTextLabel.text = [landmark phoneNumber];
				break;
			}
			case 1:{
				cell.textLabel.text = NSLocalizedString(@"address", nil);
				cell.detailTextLabel.text = [landmark address];
				break;
			}
		}
		
		return cell;
		
	} else {
		static NSString *CellIdentifier = @"ActionCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor colorWithHue:0.609 saturation:0.449 brightness:0.497 alpha:1.000];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
		
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = NSLocalizedString(@"Directions to Here", nil);
				break;
			case 1:
				cell.textLabel.text = NSLocalizedString(@"Directions from Here", nil);
		}
		
		return cell;
	}
	
	return nil;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.section == 2) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
		UIApplication *application = [UIApplication sharedApplication];
		NSString *urlString = nil;

		CLLocationCoordinate2D srcCoordinate = ((CLLocation *)((OpenAroundAppDelegate *)application.delegate).currentLocation).coordinate;
		CLLocationCoordinate2D distCoordinate = [landmark coordinate];

		switch (indexPath.row) {
			case 0:
				urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&z=%d&t=%@", srcCoordinate.latitude, srcCoordinate.longitude, distCoordinate.latitude, distCoordinate.longitude, 14, [self mapTypeForQuery]];
				break;
			case 1:
				urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&z=%d&t=%@", distCoordinate.latitude, distCoordinate.longitude, 14, [self mapTypeForQuery]];
				break;
		}
		
		if (urlString) {
			[self openURLString:urlString];
		}
	}
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
	self.landmark = nil;

	self.titleView_ = nil;
	self.titleLabel_ = nil;
	self.actionsView_ = nil;
	self.callButton_ = nil;
	self.detailButton_ = nil;
	self.mapButton_ = nil;
	[super dealloc];
}


@end
