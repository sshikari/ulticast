//
//  CallViewController.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CallViewController.h"
#import "SelectionListViewController.h"
#import "Utils.h"


#define TYPE_PROPERTY ((void *)1000)
#define CALLER_PROPERTY ((void *)900)
#define FOULER_PROPERTY ((void *)800)
#define NOTES_PROPERTY ((void *)700)

@interface CallViewController (private)
- (void) createSelectListViewController: (NSArray*) dataSource: (id) curStatus:
										 (void*) propertyConst: (NSString*) controllerTitle;

- (NSArray*) callerOptionsForCallType;
- (NSArray*) foulerOptionsForCallType;

@end


@implementation CallViewController

@synthesize gameLogMgr;
@synthesize callEvent;

static NSArray* LABEL_LIST;

+ (void) initialize {
	LABEL_LIST = [NSArray arrayWithObjects: @"Call Type", @"Contested", @"Caller", @"Fouler", @"Notes", nil];
	[LABEL_LIST retain];
}

- (void) prep: (GameLogMgr*) gMgr: (SEL) updatedSuccess: (id) parDelegate {
	[self setGameLogMgr:gMgr];
	callEvent = [[CallEvent alloc] init];
	[callEvent setTeam:[gameLogMgr offensiveTeam]];
	
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
	[callEvent setNotes: notesTextField.text];
	[parentDelegate performSelector: updateSuccessCallBack
						 withObject: callEvent];
	[self.navigationController popViewControllerAnimated:YES];	
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
		cell.textLabel.text = [LABEL_LIST objectAtIndex: indexPath.row];
		cell.detailTextLabel.text = [Utils valueOrDefault:[callEvent callType]: @""];
	} else if (indexPath.row == 1) {
		cell.textLabel.text = [LABEL_LIST objectAtIndex: indexPath.row];
		return contestedCell;
	} else if (indexPath.row == 2) {
		cell.textLabel.text = [LABEL_LIST objectAtIndex: indexPath.row];
		cell.detailTextLabel.text = [Utils valueOrDefault:[[callEvent caller] idString]: @""];
	} else if (indexPath.row == 3) {
		cell.textLabel.text = [LABEL_LIST objectAtIndex: indexPath.row];
		cell.detailTextLabel.text = [Utils valueOrDefault:[[callEvent fouler] idString]: @""];
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
		// if call type changes from defensive to offensive or vice versa, clear fouler and caller options	
		if (([callEvent isDefensiveCall] && ! [CallEvent isDefensiveCall:[selectedObjects objectAtIndex:0]])
			|| (! [callEvent isDefensiveCall] && [CallEvent isDefensiveCall:[selectedObjects objectAtIndex:0]])) {
			[callEvent setCaller: nil];
			[callEvent setFouler: nil];
		}
		[callEvent setCallType:[selectedObjects objectAtIndex:0]];
	} else  if (selContext == CALLER_PROPERTY) {
		[callEvent setCaller:[selectedObjects objectAtIndex:0]];
	} else  if (selContext == FOULER_PROPERTY) {
		[callEvent setFouler:[selectedObjects objectAtIndex:0]];
	} else {
		//[callEvent setNotes:[selectedObjects objectAtIndex:0]];
		// see textEditingFieldDone for notes field
	}
	[[self tableView] reloadData];
    [selctionController clean];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		NSArray *dataSource = [CallEvent callTypes];
		NSString *curStatus = [callEvent callType];
		[self createSelectListViewController: dataSource: curStatus: TYPE_PROPERTY: @"Call Type"];
	} else if (indexPath.row == 2) {
		if([[callEvent callType] length] != 0) {
			NSArray *dataSource = [self callerOptionsForCallType];
			Player *curStatus = [callEvent caller];
			[self createSelectListViewController: dataSource: curStatus: CALLER_PROPERTY: @"Caller"];			
		}
	} else if (indexPath.row == 3) {
		if([[callEvent callType] length] != 0) {
			NSArray *dataSource = [self foulerOptionsForCallType];
			Player *curStatus = [callEvent fouler];
			[self createSelectListViewController: dataSource: curStatus: FOULER_PROPERTY: @"Fouler"];
		}
	} 	
}

- (NSArray*) callerOptionsForCallType {
	if ([CallEvent isDefensiveCall: [callEvent callType]]) {
		return [[gameLogMgr offensiveTeam] players];
	} else {
		return [[gameLogMgr defensiveTeam] players];
	}
}

- (NSArray*) foulerOptionsForCallType {
	if ([CallEvent isDefensiveCall: [callEvent callType]]) {
	    return [[gameLogMgr defensiveTeam] players];
	} else {
		return [[gameLogMgr offensiveTeam] players];
	}
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

- (IBAction) textFieldDoneEditing: (id) sender {
	[sender resignFirstResponder];	
	[callEvent setNotes: notesTextField.text];
}


- (IBAction) contestedValueChanged: (id) sender {
	[callEvent setContested: [contestedSwitch isOn]];
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
	[callEvent release];
    [super dealloc];
}


@end

