//
//  AddTeamViewController.m
//  ulticast
//
//  Created by Richard Chang on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddTeamViewController.h"
#import "Utils.h"
#import "ReferenceDataMgr.h"
#import "PlayerDetailViewController.h"


#define PLAYERS_SECTION 1

#define CONTACT_PROPERTY ((void *)1000)
//#define CALLER_PROPERTY ((void *)900)
//#define FOULER_PROPERTY ((void *)800)
//#define NOTES_PROPERTY ((void *)700)


static NSArray* TEAM_PROPS = nil;

@implementation AddTeamViewController
@synthesize team, tableView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
+ (void) initialize {
    TEAM_PROPS = [[NSArray arrayWithObjects:@"Name", @"Is My Team", nil] retain];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
//	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain
//																			 target:self action:@selector(doneSave)];	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	nameTextField.enabled = self.editing;
	myTeamSwitch.enabled = self.editing;

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];

	nameTextField.enabled = editing;
	myTeamSwitch.enabled = editing;
	
	[self.navigationItem setHidesBackButton:editing animated:YES];
		
	[self.tableView beginUpdates];
	
	int playerCount = [[team players] count];	
    NSArray *playerInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:playerCount inSection:PLAYERS_SECTION]];
    
    if (editing) {
        [self.tableView insertRowsAtIndexPaths:playerInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
	} else {
        [self.tableView deleteRowsAtIndexPaths:playerInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self.tableView endUpdates];	
	/*
	 If editing is finished, save the managed object context.
	 */
	if (!editing) {
		[self doneSave];
	}		
}


- (IBAction) textFieldDoneEditing:(id) sender {
	NSLog(@"did end editing name");
	team.name = nameTextField.text;
}


- (void) prep: (SEL) updatedSuccess: (id) parDelegate {
	updateSuccessCallBack = updatedSuccess;
	parentDelegate = parDelegate;	
	self.team = [[Team alloc] init];
}


- (void) doneSave {
	// set text fields here b/c when you edit then directly click save instead of done, the fields don't get saved.
	[team setName: nameTextField.text];
	[team setMyTeam: myTeamSwitch.on];
	
	NSError* didFail = nil;
	[[ReferenceDataMgr sharedInstance] addTeam: team : &didFail];	
	if (didFail) {
		NSLog(@"Error saving");
		[Utils showTimeoutAlert:self :@"Error" :[didFail.userInfo objectForKey:@"errorString"] :nil :@"OK"];
	} 
	//else {
		//[team setUid:newId];
		[parentDelegate performSelector: updateSuccessCallBack
							 withObject: team];
		//[self.navigationController popViewControllerAnimated:YES];	
	//}

	
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
		
}

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return [TEAM_PROPS count];    // team properties
	} else {
		return self.editing ? [[self.team players] count] + 1 : [[self.team players] count] ;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Team";    // team properties
	} else {
		return @"Players";
	}	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			nameTextField.text = [Utils valueOrDefault:[team name]: @""];
			return nameCell;
//			cell.textLabel.text = [TEAM_PROPS objectAtIndex: indexPath.row];
//			cell.detailTextLabel.text = [Utils valueOrDefault:[team name]: @""];
		} else if (indexPath.row == 1) {
			myTeamSwitch.on = team.myTeam;
			return myTeamCell;
		}
	} else if (indexPath.section == PLAYERS_SECTION) {
		int playersCount = [[team players] count];
		if (indexPath.row < playersCount) {
			static NSString *PlayersCellIdentifier = @"PlayersCell";
			
			cell = [tableView dequeueReusableCellWithIdentifier:PlayersCellIdentifier];
			
			if (cell == nil) {
				// Create a cell to display an ingredient.
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PlayersCellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
            Player *player = [[team players] objectAtIndex:indexPath.row];
            cell.textLabel.text = player.nickname;
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", player.number];
			
		} else {
            // If the row is outside the range, it's the row that was added to allow insertion (see tableView:numberOfRowsInSection:) so give it an appropriate label.
			static NSString *AddPlayerCellIdentifier = @"AddPlayerCell";
			
			cell = [tableView dequeueReusableCellWithIdentifier:AddPlayerCellIdentifier];
			if (cell == nil) {
				// Create a cell to display "Add Player".
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddPlayerCellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
            cell.textLabel.text = @"Add Player";
        }
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PlayerDetailViewController *playerDetailViewController = [[PlayerDetailViewController alloc] initWithNibName:@"PlayerDetailViewController" bundle:nil];
	if (indexPath.section == PLAYERS_SECTION) {
		if (indexPath.row >= [[team players] count]) {  // add player
			[playerDetailViewController setEditing:YES];
			[playerDetailViewController prep:@selector(doneAddPlayer:) : self];
			playerDetailViewController.player = [[Player alloc] init];
		} else {
			[playerDetailViewController setEditing:self.editing];
			[playerDetailViewController prep:@selector(doneModPlayer:) : self];
			Player *player = [[team players] objectAtIndex:indexPath.row];
			playerDetailViewController.player = player;
		}
		[self.navigationController pushViewController:playerDetailViewController animated:YES];
		[playerDetailViewController release];
	}
}

-(void) doneAddPlayer: (Player*) player {
	NSMutableArray* newPlayers = [NSMutableArray arrayWithArray:[team players]];	
	[newPlayers addObject:player];
	team.players = newPlayers;	

	[tableView reloadData];
}

-(void) doneModPlayer: (Player*) player {
	//team.dirty = YES;
	NSLog(@"done mod");
	// edited a player, may not be in edit mode on team level
	
	if (!self.editing) 
		[self setEditing:YES];		
	
	[tableView reloadData];
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
