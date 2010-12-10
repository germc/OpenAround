//
//  RootViewController.m
//  OpenAround
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import "RootViewController.h"
#import "Reachability.h"
#import "OpenAroundAppDelegate.h"
#import "MapViewController.h"
#import "InfoViewController.h"
#import "Keyword.h"


@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowOrAccessoryButtonAtIndexPath:(NSIndexPath *)indexPath;
- (void)addNewKeyword;
- (void)showInfo;
@end


@implementation RootViewController

@synthesize reorderRows_;
@synthesize fetchedResultsController = fetchedResultsController_;
@synthesize managedObjectContext = managedObjectContext_;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"OpenAround";
	
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Info", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(showInfo)] autorelease];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:(BOOL)editing animated:(BOOL)animated];
	
	self.navigationItem.leftBarButtonItem.enabled = !editing;

	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    NSInteger numberOfRows = [sectionInfo numberOfObjects];
	NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:numberOfRows inSection:0]];
	
	if (editing) {
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	} else {
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	}
}


#pragma mark -
#pragma mark Private method

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	if (self.editing) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
		if (indexPath.row == [sectionInfo numberOfObjects]) {
			cell.textLabel.text = NSLocalizedString(@"Add New Keyword", nil);
			cell.accessoryType = UITableViewCellAccessoryNone;
			return;
		}
	}
	
    Keyword *keyword = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = keyword.title;
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}

- (void)tableView:(UITableView *)tableView didSelectRowOrAccessoryButtonAtIndexPath:(NSIndexPath *)indexPath {

	if (self.editing) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
		if (indexPath.row == [sectionInfo numberOfObjects]) {
			[self addNewKeyword];
		}
		
		return;
	}	
	
	// Check network connection.
	Reachability *currentReachbility = [Reachability reachabilityForInternetConnection];
	NetworkStatus currentStatus = [currentReachbility currentReachabilityStatus];
	if (currentStatus == NotReachable) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Can't download information because it's not connected to the internet", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}	
	
	Keyword *keyword = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	MapViewController *viewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
	viewController.titleString = keyword.title;
	viewController.queryString = keyword.query;
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (void)addNewKeyword {
	NewKeywordViewController *viewController = [[NewKeywordViewController alloc] initWithNibName:@"NewKeywordViewController" bundle:nil];
	viewController.delegate = self;
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (void)showInfo {
	InfoViewController *viewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
	UINavigationController *modalNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	modalNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController presentModalViewController:modalNavigationController animated:YES];
	[viewController release];
	[modalNavigationController release];
}


#pragma mark -
#pragma mark NewKeywordViewController delegate

- (void)saveNewTitle:(NSString *)titleString query:(NSString *)queryString {
	
	NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
	NSArray *fetchedObjects = [self.fetchedResultsController fetchedObjects];
	NSInteger order = [fetchedObjects count];
	
	Keyword *newKeyword = [NSEntityDescription insertNewObjectForEntityForName:@"Keyword" inManagedObjectContext:context];
	newKeyword.title = titleString;
	newKeyword.query = queryString;
	newKeyword.order = [NSNumber numberWithInteger:order];
    
    NSError *error = nil;
    if (![context save:&error]) {
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSInteger numberOfRows = [sectionInfo numberOfObjects];
	
	if (self.editing) {
		numberOfRows ++;
	}

	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.editing) {
		// Ignore cell swipe.
		return UITableViewCellEditingStyleNone;
	}

	if (self.editing) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
		if (indexPath.row == [sectionInfo numberOfObjects]) {
			return UITableViewCellEditingStyleInsert;
		}
	}
	
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
		
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self addNewKeyword];
	}
	
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.editing) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
		if (indexPath.row == [sectionInfo numberOfObjects]) {
			return NO;
		}
	}
	
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	if (self.editing) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:proposedDestinationIndexPath.section];
		if (proposedDestinationIndexPath.row == [sectionInfo numberOfObjects]) {
			return sourceIndexPath;
		}
	}
	
	return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	self.reorderRows_ = YES;
	
    NSMutableArray * fetchedObjects = [NSMutableArray arrayWithArray:[self.fetchedResultsController fetchedObjects]]; 
	
	id item = [fetchedObjects objectAtIndex:fromIndexPath.row];
	[fetchedObjects removeObject:item];
	[fetchedObjects insertObject:item atIndex:toIndexPath.row];
	
	int i = 0;
	for (Keyword *keyword in fetchedObjects) {
		keyword.order = [NSNumber numberWithInt:i];
		i ++;
	}
	
	NSError *error = nil;
	if (![self.fetchedResultsController.managedObjectContext save:&error]) {
		DLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	[self tableView:tableView didSelectRowOrAccessoryButtonAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self tableView:tableView didSelectRowOrAccessoryButtonAtIndexPath:indexPath];
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Keyword" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return fetchedResultsController_;
}    


#pragma mark -
#pragma mark Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	if (reorderRows_) {
		return;
	}

    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

	if (reorderRows_) {
		return;
	}
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {

	if (reorderRows_) {
		return;
	}
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	if (reorderRows_) {
		self.reorderRows_ = NO;
		[self.tableView reloadData];
		return;
	}

    [self.tableView endUpdates];
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
    [fetchedResultsController_ release];
    [managedObjectContext_ release];
    [super dealloc];
}


@end
