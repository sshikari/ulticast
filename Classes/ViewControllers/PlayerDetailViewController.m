//
//  PlayerDetailViewController.m
//  ulticast
//
//  Created by Richard Chang on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "Utils.h"

static NSArray* PLAYER_PROPS = nil;


@implementation PlayerDetailViewController
@synthesize player, tableView;

+ (void) initialize {
    PLAYER_PROPS = [[NSArray arrayWithObjects:@"First Name", @"Last Name", @"Nickname", @"Jersey Number", nil] retain];	
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	firstNameTextField.enabled = self.editing;
	lastNameTextField.enabled = self.editing;
	nicknameTextField.enabled = self.editing;
	numberTextField.enabled = self.editing;

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {    
    [super setEditing:editing animated:animated];
	
	firstNameTextField.enabled = self.editing;
	lastNameTextField.enabled = self.editing;
	nicknameTextField.enabled = self.editing;
	numberTextField.enabled = self.editing;
	
	[self.navigationItem setHidesBackButton:editing animated:YES];
	
	if (!editing) {
		[self doneSave];
	}		
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) doneSave {
	// set text fields here b/c when you edit then directly click save instead of done, the fields don't get saved.
	[player setFirstName: firstNameTextField.text];
	[player setLastName: lastNameTextField.text];
	[player setNickname: nicknameTextField.text];
	[player setNumber: [numberTextField.text intValue]];

//	NSError* didFail = nil;
//	[[ReferenceDataMgr sharedInstance] addTeam: team : &didFail];
//	if (didFail) {
//		NSLog(@"Error saving");
//		[Utils showTimeoutAlert:self :@"Error" :[didFail.userInfo objectForKey:@"errorString"] :nil :@"OK"];
//	} 
//	//else {
//	//[team setUid:newId];
	[parentDelegate performSelector: updateSuccessCallBack
						 withObject: player];
	[self.navigationController popViewControllerAnimated:YES];	
	//}
	
	
	
}

- (void) prep: (SEL) updatedSuccess: (id) parDelegate {
	updateSuccessCallBack = updatedSuccess;
	parentDelegate = parDelegate;	
}

- (IBAction) textFieldDoneEditing:(id) sender {
	NSLog(@"did end editing text");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [PLAYER_PROPS count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
//    }
	
	if (indexPath.row == 0) {
		firstNameTextField.text = [Utils valueOrDefault:[player firstName]: @""];
		return firstNameCell;
	} else if (indexPath.row == 1) {
		lastNameTextField.text = [Utils valueOrDefault:[player lastName]: @""];
		return lastNameCell;
	} else if (indexPath.row == 2) {
		nicknameTextField.text = [Utils valueOrDefault:[player nickname]: @""];
		return nicknameCell;		
	} else {
		numberTextField.text = [NSString stringWithFormat:@"%d", [player number]];
		return numberCell;
	} 
	 
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	PlayerDetailViewController *playerDetailViewController = [[PlayerDetailViewController alloc] initWithNibName:@"PlayerDetailViewController" bundle:nil];
//	
//	if (indexPath.row >= [[team players] count]) {
//		[playerDetailViewController setEditing:YES animated:YES];
//		[playerDetailViewController prep:@selector(doneAddPlayer:) : self];
//	} else {
//		Player *player = [[team players] objectAtIndex:indexPath.row];
//		playerDetailViewController.player = player;
//	}
//	
//	[self.navigationController pushViewController:playerDetailViewController animated:YES];
//	[playerDetailViewController release];                
}


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


- (void)dealloc {
    [super dealloc];
}


@end
