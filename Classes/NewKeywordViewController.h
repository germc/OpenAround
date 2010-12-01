//
//  NewKeywordViewController.h
//  OpenAround
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NewKeywordViewControllerDelegate;


@interface NewKeywordViewController : UITableViewController {

	UITableViewCell *titleCell_;
	UITextField *titleField_;
	UITableViewCell *queryCell_;
	UITextField *queryField_;

	id<NewKeywordViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *titleCell_;
@property (nonatomic, retain) IBOutlet UITextField *titleField_;
@property (nonatomic, retain) IBOutlet UITableViewCell *queryCell_;
@property (nonatomic, retain) IBOutlet UITextField *queryField_;
@property (nonatomic, assign) id<NewKeywordViewControllerDelegate> delegate;

@end


@protocol NewKeywordViewControllerDelegate

- (void)saveNewTitle:(NSString *)titleString query:(NSString *)queryString;

@end

