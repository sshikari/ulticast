//
//  GoalViewController.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameLogMgr.h"
#import "ScoreEvent.h"

@interface GoalViewController : UITableViewController <UITextFieldDelegate> {
	GameLogMgr* gameLogMgr;
	ScoreEvent* scoreEvent;
	BOOL scoreSaved;
	
	SEL updateSuccessCallBack;
	id parentDelegate;
	
	IBOutlet UILabel *notesLabel;
	IBOutlet UITextField *notesTextField;
	IBOutlet UITableViewCell *notesCell;	
	
}

- (void) prep: (GameLogMgr*) gMgr: (SEL) updatedSuccess: (id) parDelegate;
- (IBAction) textFieldDoneEditing: (id) sender;
	 

@property (retain, nonatomic) GameLogMgr* gameLogMgr;
@property (retain, nonatomic) ScoreEvent* scoreEvent;
@property BOOL scoreSaved;
@end
