//
//  TurnViewController.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameLogMgr.h"
#import "TurnEvent.h"

@interface TurnViewController : UITableViewController {
	GameLogMgr* gameLogMgr;
	TurnEvent* turnEvent;
	
	SEL updateSuccessCallBack;
	id parentDelegate;
	
	IBOutlet UILabel *notesLabel;
	IBOutlet UITextField *notesTextField;
	IBOutlet UITableViewCell *notesCell;	
}

- (void) prep: (GameLogMgr*) gMgr: (SEL) updatedSuccess: (id) parDelegate;

- (IBAction) textFieldDoneEditing: (id) sender;

@property (retain, nonatomic) GameLogMgr* gameLogMgr;
@property (retain, nonatomic) TurnEvent* turnEvent;
@end
