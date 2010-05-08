//
//  QuickGameViewController.h
//  ulticast
//
//  Created by Richard Chang on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickGameInfo.h"

@interface QuickGameViewController : UITableViewController {
	QuickGameInfo *quickGameInfo;
	IBOutlet UILabel *isHomeLabel;
	IBOutlet UISwitch *isHomeSwitch;
	IBOutlet UITableViewCell *isHomeCell;
	
}

- (IBAction) homeValueChanged: (id) sender;
@end
