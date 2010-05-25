//
//  TeamsViewController.m
//  ulticast
//
//  Created by Richard Chang on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TeamsViewController.h"
#import "ReferenceDataMgr.h"
#import "AddTeamViewController.h"
#import "Utils.h"

#define MY_TEAMS_SEGMENT 0
#define OPPONENTS_SEGMENT 1

#define TEAMS_SECTION 0

@interface TeamsViewController(private)
- (NSArray*) teamsList;
@end

@implementation TeamsViewController

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

	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	myTeams = [[[ReferenceDataMgr sharedInstance] myTeams] retain];
	opponentTeams = [[[ReferenceDataMgr sharedInstance] teams] retain];
	
	teamsTableView.allowsSelectionDuringEditing = YES;

}

- (void) doneAddTeam: (Team*) teamToAdd {
	NSLog(@"adding team : %@", teamToAdd);
	teamsSegmentedControl.selectedSegmentIndex = teamToAdd.myTeam ? 0 : 1;
	[myTeams release];
	[opponentTeams release];
	myTeams = [[[ReferenceDataMgr sharedInstance] myTeams] retain];
	opponentTeams = [[[ReferenceDataMgr sharedInstance] teams] retain];
	[teamsTableView reloadData];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	
	[teamsTableView beginUpdates];
	
	int teamCount = [[self teamsList] count];
    NSArray *teamInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:teamCount inSection:0]];
    
    if (editing) {
        [teamsTableView insertRowsAtIndexPaths:teamInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
	} else {
        [teamsTableView deleteRowsAtIndexPaths:teamInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [teamsTableView endUpdates];		
	[teamsTableView setEditing:editing animated:animated];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    if (indexPath.section == TEAMS_SECTION) {
        // If this is the last item, it's the insertion row.
        if (indexPath.row == [[self teamsList] count]) {
            style = UITableViewCellEditingStyleInsert;
        }
        else {
            style = UITableViewCellEditingStyleDelete;
        }
    }
    
    return style;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		Team *team = [[self teamsList] objectAtIndex: indexPath.row];
		NSError* didFail = nil;
		[[ReferenceDataMgr sharedInstance] deleteTeam: team: &didFail];
		if (didFail) {
			NSLog(@"Error saving");
			[Utils showTimeoutAlert:self :@"Error" :[didFail.userInfo objectForKey:@"errorString"] :nil :@"OK"];
			return;
		} else {
			[Utils showTimeoutAlert:self :@"Success" :@"Team deleted" :nil :@"OK"];
			NSArray* rowArray = [NSArray arrayWithObject:indexPath];
			myTeams = [[[ReferenceDataMgr sharedInstance] myTeams] retain];
			opponentTeams = [[[ReferenceDataMgr sharedInstance] teams] retain];
			[teamsTableView deleteRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationTop];
			[teamsTableView reloadData];
		}		
	}  
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

-(IBAction) selectedSegment:(id)sender {
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSLog(@"%d", [segmentedControl selectedSegmentIndex]);	
	[teamsTableView reloadData];	
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
	return self.editing ? [[self teamsList] count] + 1 : [[self teamsList] count] ;
}

- (NSArray*) teamsList {
    if ([teamsSegmentedControl selectedSegmentIndex] == 0) {
		return myTeams;
	} else {
		return opponentTeams;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 	UITableViewCell *cell = nil;
	
	if (indexPath.row < [[self teamsList] count]) {
		// Set up the cell...
		static NSString *CellIdentifier = @"Cell";
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}		
		cell.textLabel.text = [[[self teamsList] objectAtIndex:indexPath.row] description];
	} else {
		// If the row is outside the range, it's the row that was added to allow insertion (see tableView:numberOfRowsInSection:) so give it an appropriate label.
		static NSString *AddTeamCellIdentifier = @"AddTeamCell";
		
		cell = [tableView dequeueReusableCellWithIdentifier:AddTeamCellIdentifier];
		if (cell == nil) {
			// Create a cell to display "Add Team".
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddTeamCellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		cell.textLabel.text = @"Add Team";
	}		
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	AddTeamViewController *addTeamViewController = [[AddTeamViewController alloc] initWithNibName:@"AddTeamViewController" bundle:nil];
	
	if (indexPath.row >= [[self teamsList] count]) {
		[addTeamViewController setEditing:YES animated:YES];
		[addTeamViewController prep:@selector(doneAddTeam:) : self];
	} else {
		Team *team = [[self teamsList] objectAtIndex:indexPath.row];
		addTeamViewController.team = team;
	}

	[self.navigationController pushViewController:addTeamViewController animated:YES];
	[addTeamViewController release];                
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
	[opponentTeams release];
	[myTeams release];
    [super dealloc];
}


@end

