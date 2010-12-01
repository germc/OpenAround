//
//  InfoViewController.m
//  OpenAround
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import "InfoViewController.h"
#import "NSString+InfoTokens.h"


@interface InfoViewController ()
- (void)close;
@end


@implementation InfoViewController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"Info", nil);
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
}


#pragma mark -
#pragma mark Private method

- (void)close {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
	headerView.backgroundColor = tableView.backgroundColor;

	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 44)];
	titleLabel.font = [UIFont boldSystemFontOfSize:20];
	titleLabel.textColor = [UIColor blackColor];
	titleLabel.shadowColor = [UIColor whiteColor];
	titleLabel.shadowOffset = CGSizeMake(0, 1);
	titleLabel.backgroundColor = tableView.backgroundColor;
	titleLabel.textAlignment = UITextAlignmentCenter;
	if (section == 0) {
		titleLabel.text = @"About";
	} else {
		titleLabel.text = @"Third Party Notice";
	}

	[headerView addSubview:titleLabel];
	[titleLabel release];
	
	
	return [headerView autorelease];
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (section == 0) {
		return [NSString stringWithFormat:@"OpenAround\r\n Version %@", [@"$CFBundleVersion" stringBySubstitutingInfoTokens]];
	}
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"ThirdPartyNotices" ofType:@"txt"];
	return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
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
    [super dealloc];
}


@end

