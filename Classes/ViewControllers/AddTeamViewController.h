//
//  AddTeamViewController.h
//  ulticast
//
//  Created by Richard Chang on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface AddTeamViewController : UIViewController {
	IBOutlet UITableView *tableView;
	IBOutlet UITableViewCell *nameCell;
	IBOutlet UITextField *nameTextField;
	IBOutlet UISwitch *myTeamSwitch;
	IBOutlet UITableViewCell *myTeamCell;
	
	
	SEL updateSuccessCallBack;
	id parentDelegate;
	Team* team;
}

@property (nonatomic, retain) Team* team;
@property (nonatomic, retain) UITableView *tableView;

- (IBAction) textFieldDoneEditing:(id) sender;

- (void) prep: (SEL) updatedSuccess: (id) parDelegate;
@end
