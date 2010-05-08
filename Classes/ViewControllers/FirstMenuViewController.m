//
//  FirstMenuViewController.m
//  ulticast
//
//  Created by Richard Chang on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FirstMenuViewController.h"
#import "QuickGameViewController.h"
#import "TeamsViewController.h"
#import "AuthenticationMgr.h"
#import "LoginViewController.h"
#import "GameViewController.h"
#import "GameLogMgrPool.h"

@implementation FirstMenuViewController



- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Main Menu";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain 
																			 target:self action:@selector(logoutButtonPushed)];
	self.navigationItem.hidesBackButton = YES;
    //gameInProgress = [[GameLogMgrPool sharedInstance] isGameInProgress];
}

- (void)viewWillAppear:(BOOL)animated {    // Called when the view is about to made visible. Default does nothing
	[tableView reloadData];
}


- (void) logoutButtonPushed {
	[[AuthenticationMgr sharedInstance] logout];
	LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	//[self.navigationController popToRootViewControllerAnimated:NO];
	[self.navigationController setViewControllers:[NSArray arrayWithObject:loginViewController] animated: YES];
	//[self.navigationController popToViewController:loginViewController animated:YES];
	[loginViewController release];
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [TABLE_ROW_LABELS count];
	return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    if (indexPath.row == 0) {
		cell.textLabel.text = [[GameLogMgrPool sharedInstance] isGameInProgress] ? @"Resume Game" : @"Quick Game" ;
		//cell.textLabel.text = gameInProgress ? @"Resume Game" : @"Quick Game" ;
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"Tournaments";			
	} else if (indexPath.row == 2) {
		cell.textLabel.text = @"Teams";		
	} 
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    
	if (indexPath.row == 0) {
		if ([[GameLogMgrPool sharedInstance] isGameInProgress]) {
			GameViewController *gameViewController = [[GameViewController alloc] initWithNibName:@"GameView" 
																			bundle:nil 
																			gameLogMgr: [[GameLogMgrPool sharedInstance] getGameInProgress]];
			
			[[self navigationController] pushViewController:gameViewController animated:YES];
			[gameViewController release];			
		} else {
			QuickGameViewController *quickGameViewController = [[QuickGameViewController alloc] initWithNibName:@"QuickGameViewController" bundle:nil];
			quickGameViewController.title = @"Quick Game";		
			[self.navigationController pushViewController:quickGameViewController animated:YES];
			[quickGameViewController release];
		}
	} else if (indexPath.row == 2) {
		TeamsViewController *teamsViewController = [[TeamsViewController alloc] initWithNibName:@"TeamsViewController" bundle:nil];
		teamsViewController.title = @"Teams";
		[self.navigationController pushViewController:teamsViewController animated:YES];
		[teamsViewController release];		
	}
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[tableView release];
    [super dealloc];
}


@end

