//
//  NewKeywordViewController.m
//  OpenAround
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import "NewKeywordViewController.h"


@interface NewKeywordViewController ()
- (void)save;
- (void)cancel;
@end


@implementation NewKeywordViewController

@synthesize titleCell_;
@synthesize titleField_;
@synthesize queryCell_;
@synthesize queryField_;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"New Keyword", nil);
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
	self.navigationItem.rightBarButtonItem.enabled = NO;
}


#pragma mark -
#pragma mark Private method

- (void)save {

	NSString *titleString = titleField_.text;
	NSString *queryString = queryField_.text;
	
	if ([(id)delegate respondsToSelector:@selector(saveNewTitle:query:)]) {
		[delegate saveNewTitle:titleString query:queryString];
	}

	[self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel {
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0:
			[titleField_ becomeFirstResponder];
			return titleCell_;
		case 1:
			return queryCell_;
	}
	
	return nil;
}


#pragma mark -
#pragma mark UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (textField == titleField_) {
		NSMutableString *text = [[titleField_.text mutableCopy] autorelease];
		[text replaceCharactersInRange:range withString:string];
		
		self.navigationItem.rightBarButtonItem.enabled = ([text length] > 0 && [queryField_.text length] > 0);
		
	} else {
		NSMutableString *text = [[queryField_.text mutableCopy] autorelease];
		[text replaceCharactersInRange:range withString:string];
		
		self.navigationItem.rightBarButtonItem.enabled = ([text length] > 0 && [titleField_.text length] > 0);
	}
	
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == titleField_) {
		[queryField_ becomeFirstResponder];
	} else {
		[self save];
	}
	
	return YES;
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

	self.titleCell_ = nil;
	self.titleField_ = nil;
	self.queryCell_ = nil;
	self.queryField_ = nil;
	
    [super dealloc];
}


@end

