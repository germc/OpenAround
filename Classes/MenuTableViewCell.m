//
// MenuTableViewCell.h
//

#import "MenuTableViewCell.h"


@interface MenuTableViewCell ()
- (void)showMenu;
- (IBAction)copy:(id)sender;
@end


@implementation MenuTableViewCell


#pragma mark -
#pragma mark UITableViewCell method

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

	if (selected) {
		[self showMenu];

		[self setSelected:NO animated:YES];
	}
}


#pragma mark -
#pragma mark Private method

- (IBAction)copy:(id)sender {
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	pasteBoard.persistent = YES;
	[pasteBoard setValue:self.detailTextLabel.text forPasteboardType:@"public.utf8-plain-text"];
}

- (void)showMenu {
	CGRect frame = self.frame;
	
	UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
    [self becomeFirstResponder];
    [menu update];
    [menu setTargetRect:CGRectMake(0, 0, frame.size.width / 2, 0) inView:self];
    [menu setMenuVisible:YES animated:YES];
	
}


#pragma mark -
#pragma mark UIResponder method

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ([self.detailTextLabel.text length] > 0 && action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

@end
