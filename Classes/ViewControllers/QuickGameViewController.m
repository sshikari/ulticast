//
//  QuickGameViewController.m
//  ulticast
//
//  Created by Richard Chang on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuickGameViewController.h"
#import "Utils.h"
#import "SelectionListViewController.h"
#import "ReferenceDataMgr.h"
#import "GameLogMgrPool.h"
#import "GameViewController.h"
#import "Utils.h"

#define MY_TEAM_PROPERTY ((void *)1000)
#define OPPONENT_TEAM_PROPERTY ((void *)900)
#define LOCATION_PROPERTY ((void *)800)
#define HOME_PROPERTY ((void *)700)
#define WEATHER_PROPERTY ((void *)600)
#define WIND_PROPERTY ((void *)500)

@interface QuickGameViewController (private)
- (void) createSelectListViewController: (NSArray*) dataSource: (id) curStatus:
										  (void*) propertyConst: (NSString*) controllerTitle;

- (void) startGame;
- (NSArray*) teams;
- (NSArray*) myTeams;
- (NSArray*) locations;
- (NSArray*) weatherOptions;
- (NSArray*) windOptions;
	
@end

@implementation QuickGameViewController


static NSArray *TABLE_ROW_LABELS;

+ (void) initialize {
	TABLE_ROW_LABELS = [NSArray arrayWithObjects: @"My Team", @"Opponent", @"Location", @"Home", @"Weather", @"Wind", nil];
	[TABLE_ROW_LABELS retain];
}


/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	quickGameInfo = [[QuickGameInfo alloc] init];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleDone 
																			 target:self action:@selector(startGame)];
}


- (void) startGame {
  	NSLog(@"start game");	
	
	if ([quickGameInfo myTeam] == nil || [quickGameInfo opponentTeam] == nil) {
		[Utils showTimeoutAlert:self :@"Error" :@"Teams must be selected" :nil : @"OK"]; 
		return;
	}

	GameViewController *gameViewController = [[GameViewController alloc] initWithNibName:@"GameView" bundle:nil
														gameLogMgr: [[GameLogMgrPool sharedInstance] startNewGame: quickGameInfo]];
		
	[[self navigationController] pushViewController:gameViewController animated:YES];
	[gameViewController release];
	//[gameLogMgr release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
//	NSString* timeoutTeam1 = [NSString stringWithFormat:@"Timeout - %@", [gameLogMgr team1Name]];
//	NSString* timeoutTeam2 = [NSString stringWithFormat:@"Timeout - %@", [gameLogMgr team2Name]];	
//	
//	// RESUME time
//	NSString* title = [alertView title];
//	
//	if ([title isEqualToString:timeoutTeam1]) {		
//		[gameLogMgr timeoutTeam1End];	
//	} else if ([title isEqualToString:timeoutTeam2]){
//		[gameLogMgr timeoutTeam2End];			
//	} 
	return;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    return [TABLE_ROW_LABELS count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2  reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = [TABLE_ROW_LABELS objectAtIndex: indexPath.row];

	if (indexPath.row == 0) {
		cell.detailTextLabel.text = [Utils valueOrDefault:[[quickGameInfo myTeam] name]: @""];
	} else if (indexPath.row == 1) {
		cell.detailTextLabel.text = [Utils valueOrDefault:[[quickGameInfo opponentTeam] name]: @""];
	} else if (indexPath.row == 2) {
		cell.detailTextLabel.text = [Utils valueOrDefault:[[quickGameInfo location] description]: @""];
	} else if (indexPath.row == 3) {
		return isHomeCell;
	} else if (indexPath.row == 4) {
		cell.detailTextLabel.text = [Utils valueOrDefault:[quickGameInfo weatherDescription]: @""];
	} else if (indexPath.row == 5) {
		cell.detailTextLabel.text = [Utils valueOrDefault:[quickGameInfo wind]: @""];
	} else {
		//return notesCell;	
	}
	
    return cell;
}

- (IBAction) homeValueChanged: (id) sender {
	[quickGameInfo setIsHomeGame: [isHomeSwitch isOn]];
}


- (void)selectionTableViewController:(SelectionListViewController *)selctionController 
	  completedSelectionsWithContext:(void *)selContext 
					 selectedObjects:(NSArray *)selectedObjects 
						 haveChanges:(BOOL)isChanged {
    if (!isChanged) {
        [selctionController clean];
        return;
    }
	
	NSLog(@"selected : %@", [selectedObjects objectAtIndex:0]);
	if (selContext == MY_TEAM_PROPERTY) {
		[quickGameInfo setMyTeam:[selectedObjects objectAtIndex:0]];
	} else  if (selContext == OPPONENT_TEAM_PROPERTY) {
		[quickGameInfo setOpponentTeam:[selectedObjects objectAtIndex:0]];
	} else  if (selContext == LOCATION_PROPERTY) {
		[quickGameInfo setLocation:[selectedObjects objectAtIndex:0]];
	} 
//	else  if (selContext == HOME_PROPERTY) {
//		[quickGameInfo setIsHomeGame:[isHomeSwitch isOn]];
//	} 
	else  if (selContext == WEATHER_PROPERTY) {
		[quickGameInfo setWeatherDescription:[selectedObjects objectAtIndex:0]];
	} else  if (selContext == WIND_PROPERTY) {
		[quickGameInfo setWind:[selectedObjects objectAtIndex:0]];
	}
	
	[[self tableView] reloadData];
    [selctionController clean];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* controllerTitle = [TABLE_ROW_LABELS objectAtIndex: indexPath.row];
	if (indexPath.row == 0) {
		NSArray *dataSource = [self myTeams];
		Team *curStatus = [quickGameInfo myTeam];
		[self createSelectListViewController: dataSource: curStatus: MY_TEAM_PROPERTY: controllerTitle];
	} else if (indexPath.row == 1) {
		NSArray *dataSource = [self teams];
		Team *curStatus = [quickGameInfo opponentTeam];
		[self createSelectListViewController: dataSource: curStatus: OPPONENT_TEAM_PROPERTY: controllerTitle];
	} else if (indexPath.row == 2) {
		NSArray *dataSource = [self locations];
		GameLocation *curStatus = [quickGameInfo location];
		[self createSelectListViewController: dataSource: curStatus: LOCATION_PROPERTY: controllerTitle];
	} 
//	else if (indexPath.row == 3) {
		// cell with switch
		//NSArray *dataSource = [self ];
		//Team *curStatus = [quickGameInfo opponentTeam];
		//[self createSelectListViewController: dataSource: curStatus: OPPONENT_TEAM_PROPERTY: controllerTitle];
//	}
	else if (indexPath.row == 4) {
		NSArray *dataSource = [self weatherOptions];
		NSString *curStatus = [quickGameInfo weatherDescription];
		[self createSelectListViewController: dataSource: curStatus: WEATHER_PROPERTY: controllerTitle];
	}
	else if (indexPath.row == 5) {
		NSArray *dataSource = [self windOptions];
		NSString *curStatus = [quickGameInfo wind];
		[self createSelectListViewController: dataSource: curStatus: WIND_PROPERTY: controllerTitle];
	}
	//	else if (indexPath.row == 3) {
//		if([[callEvent callType] length] != 0) {
//			NSArray *dataSource = [self foulerOptionsForCallType];
//			Player *curStatus = [callEvent fouler];
//			[self createSelectListViewController: dataSource: curStatus: FOULER_PROPERTY: @"Fouler"];
//		}
//	} 	
	
	[controllerTitle release];
}


- (NSArray*) myTeams {
	return [[ReferenceDataMgr sharedInstance] myTeams];
}

- (NSArray*) teams {
	return [[ReferenceDataMgr sharedInstance] teams];
}

- (NSArray*) locations {
	return [[ReferenceDataMgr sharedInstance] locations];
}

- (NSArray*) weatherOptions {
	return [[ReferenceDataMgr sharedInstance] weatherOptions];
}

- (NSArray*) windOptions {
	return [[ReferenceDataMgr sharedInstance] windOptions];
}

- (void) createSelectListViewController: (NSArray*) dataSource: (id) curStatus: (void*) propertyConst: (NSString*) controllerTitle {
	
	SelectionListViewController *selectionTableViewController = [[SelectionListViewController alloc] initWithNibName:@"SelectionListViewController" bundle:nil];
	//    NSArray *selObject = (curStatus == nil ? [NSArray arrayWithObject:[dataSource objectAtIndex:0]] : [NSArray arrayWithObject:curStatus]);
    NSArray *selObject = (curStatus == nil ? [NSArray array] : [NSArray arrayWithObject:curStatus]);
	
    [selectionTableViewController populateDataSource:dataSource
									   havingContext: propertyConst
									 selectedObjects:selObject
									   selectionType:kRadio
										 andDelegate:self];
	
    selectionTableViewController.title = controllerTitle;
	
    [self.navigationController pushViewController:selectionTableViewController animated:YES];
    [selectionTableViewController release];
	
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
	[quickGameInfo release];
    [super dealloc];
}


@end

