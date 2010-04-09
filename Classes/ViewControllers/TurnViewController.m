//
//  TurnViewController.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TurnViewController.h"
#import "SelectionListViewController.h"
#import "Utils.h"

#define TYPE_PROPERTY ((void *)1000)
#define PLAYER_PROPERTY ((void *)900)



@interface TurnViewController (private)
- (void) createSelectListViewController: (NSArray*) dataSource: (id) curStatus:
										 (void*) propertyConst: (NSString*) controllerTitle;
@end


@implementation TurnViewController

@synthesize gameLogMgr;
@synthesize turnEvent;

static NSArray* LABEL_LIST;

+ (void) initialize {
	LABEL_LIST = [NSArray arrayWithObjects: @"Turn Type", @"Player", @"Notes:", nil];
	[LABEL_LIST retain];
}

- (void) prep: (GameLogMgr*) gMgr: (SEL) updatedSuccess: (id) parDelegate {
	[self setGameLogMgr:gMgr];
	turnEvent = [[TurnEvent alloc] init];
	[turnEvent setTeam:[gameLogMgr offensiveTeam]];
	
	updateSuccessCallBack = updatedSuccess;
	parentDelegate = parDelegate;
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	notesTextField.returnKeyType = UIReturnKeyDone;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain 
																			 target:self action:@selector(doneSave)];	
}

- (void) doneSave {	
	// set notes here b/c when you edit notes, then directly click save instead of done, notes doesn't get saved.
	[turnEvent setNotes: notesTextField.text];	
	[gameLogMgr turn: turnEvent];	
	[parentDelegate performSelector: updateSuccessCallBack
						 withObject: nil];			
	[self.navigationController popViewControllerAnimated:YES];	
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


- (IBAction) textFieldDoneEditing: (id) sender {
	[sender resignFirstResponder];	
	[turnEvent setNotes: notesTextField.text];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LABEL_LIST count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2  reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	if (indexPath.row == 0) {
		cell.textLabel.text = [LABEL_LIST objectAtIndex: 0];
		cell.detailTextLabel.text = [Utils valueOrDefault:[turnEvent turnType]: @""];
	} else if (indexPath.row == 1) {
		cell.textLabel.text = [LABEL_LIST objectAtIndex: 1];
		cell.detailTextLabel.text = [Utils valueOrDefault:[[turnEvent player] idString]: @""];
	} else {
	    return notesCell;				
	}
	
	return cell;
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
	if (selContext == TYPE_PROPERTY) {
		[turnEvent setTurnType:[selectedObjects objectAtIndex:0]];
	} else  if (selContext == PLAYER_PROPERTY) {
		[turnEvent setPlayer:[selectedObjects objectAtIndex:0]];
	} else {
		//[turnEvent setNotes:[selectedObjects objectAtIndex:0]];
		// see textEditingDone method for notes field
	}
	[[self tableView] reloadData];
    [selctionController clean];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		NSArray *dataSource = [TurnEvent turnTypes];
		NSString *curStatus = [turnEvent turnType];
		[self createSelectListViewController: dataSource: curStatus: TYPE_PROPERTY: @"Turn Type"];
	} else if (indexPath.row == 1) {
		NSArray *dataSource = [[gameLogMgr offensiveTeam] players];
		Player *curStatus = [turnEvent player];
		[self createSelectListViewController: dataSource: curStatus: PLAYER_PROPERTY: @"Player"];
	} 	
}

- (void) createSelectListViewController: (NSArray*) dataSource:
(id) curStatus:
(void*) propertyConst:
(NSString*) controllerTitle {
	
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
	[gameLogMgr release];
	[turnEvent release];
    [super dealloc];
}


@end

