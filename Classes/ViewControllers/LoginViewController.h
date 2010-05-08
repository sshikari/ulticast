//
//  LoginViewController.h
//  ulticast
//
//  Created by Richard Chang on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect/FBConnect.h"

@interface LoginViewController : UIViewController<FBSessionDelegate, FBRequestDelegate> {
	IBOutlet UITableView *loginTable;
	
	IBOutlet UILabel *usernameLabel;
	IBOutlet UITextField *usernameField;
	IBOutlet UITableViewCell *usernameCell;	

	IBOutlet UILabel *passwordLabel;
	IBOutlet UITextField *passwordField;
	IBOutlet UITableViewCell *passwordCell;	
	IBOutlet UIActivityIndicatorView *loginIndicator;	
	FBSession* fbSession;
	IBOutlet UIButton *fbButton;
}

- (IBAction) textFieldDoneEditing: (id) sender;
//- (IBAction) clearButtonClicked:(id) sender;
- (IBAction) loginButtonClicked:(id) sender;
- (IBAction) fbButtonClicked:(id) sender;
@end
