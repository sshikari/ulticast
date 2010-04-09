//
//  CallViewController.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameLogMgr.h"
#import "CallEvent.h"

@interface CallViewController : UITableViewController {
	GameLogMgr* gameLogMgr;
	CallEvent* callEvent;
	
	SEL updateSuccessCallBack;
	id parentDelegate;
	
	IBOutlet UILabel *notesLabel;
	IBOutlet UITextField *notesTextField;
	IBOutlet UITableViewCell *notesCell;	
	
	IBOutlet UILabel *contestedLabel;
	IBOutlet UISwitch *contestedSwitch;
	IBOutlet UITableViewCell *contestedCell;	
	
}

- (void) prep: (GameLogMgr*) gMgr: (SEL) updatedSuccess: (id) parDelegate;
- (IBAction) textFieldDoneEditing: (id) sender;
- (IBAction) contestedValueChanged: (id) sender;
	 

@property (retain, nonatomic) GameLogMgr* gameLogMgr;
@property (retain, nonatomic) CallEvent* callEvent;
@end
