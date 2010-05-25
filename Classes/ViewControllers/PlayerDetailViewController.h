//
//  PlayerDetailViewController.h
//  ulticast
//
//  Created by Richard Chang on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface PlayerDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	Player *player;
	SEL updateSuccessCallBack;
	id parentDelegate;

	IBOutlet UITableViewCell *firstNameCell;
	IBOutlet UITableViewCell *lastNameCell;
	IBOutlet UITableViewCell *nicknameCell;
	IBOutlet UITableViewCell *numberCell;
	
	IBOutlet UITextField *firstNameTextField;
	IBOutlet UITextField *lastNameTextField;
	IBOutlet UITextField *nicknameTextField;
	IBOutlet UITextField *numberTextField;
	
	IBOutlet UITableView *tableView;
}

- (void) prep: (SEL) updatedSuccess: (id) parDelegate;

@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) UITableView *tableView;

@end
