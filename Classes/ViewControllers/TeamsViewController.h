//
//  TeamsViewController.h
//  ulticast
//
//  Created by Richard Chang on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TeamsViewController : UIViewController {
    IBOutlet UITableView *teamsTableView;

	IBOutlet UISegmentedControl *teamsSegmentedControl;
	NSArray* myTeams;
	NSArray* opponentTeams;
}

-(IBAction) selectedSegment:(id)sender;
@end
