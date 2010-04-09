//
//  GoalViewController.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GoalViewController.h"
#import "SelectionListViewController.h"
#import "Utils.h"
#import "Player.h"

#define SCORER_PROPERTY ((void *)1000)
#define ASSISTER_PROPERTY ((void *)900)
#define DISTANCE_PROPERTY ((void *)800)
#define NOTES_PROPERTY ((void *)700)


@interface GoalViewController (private)
- (void) createSelectListViewController: (NSArray*) dataSource: (id) curStatus:
(void*) propertyConst: (NSString*) controllerTitle;
@end


@implementation GoalViewController

@synthesize gameLogMgr;
@synthesize scoreEvent;
@synthesize scoreSaved;

static NSArray* LABEL_MAP;



/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
 }
 */
+ (void) initialize {
	LABEL_MAP = [NSArray arrayWithObjects: @"score", @"assist", @"distance", @"notes", nil];
	[LABEL_MAP retain];
}

- (void) prep: (GameLogMgr*) gMgr: (SEL) updatedSuccess: (id) parDelegate {   // TODO: hack
    	[self setGameLogMgr:gMgr];
		scoreEvent = [[ScoreEvent alloc] init];
		[scoreEvent setTeam:[gameLogMgr offensiveTeam]];
	
	updateSuccessCallBack = updatedSuccess;
	parentDelegate = parDelegate;
	    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	notesTextField.returnKeyType = UIReturnKeyDone;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain 
																									 target:self action:@selector(doneSave)];

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
    return [LABEL_MAP count];
}


- (IBAction) textFieldDoneEditing: (id) sender {
	[sender resignFirstResponder];	
	[scoreEvent setNotes: notesTextField.text];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2  reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	//cell.detailTextLabel.text = [[gameState detailsArray] objectAtIndex:indexPath.row];
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Scorer";
		cell.detailTextLabel.text = [Utils valueOrDefault:[[scoreEvent player] idString]: @""];
	} else if (indexPath.row == 1) {
	    cell.textLabel.text = @"Assister";
		cell.detailTextLabel.text = [Utils valueOrDefault:[[scoreEvent assister] idString]: @""];
	} else if (indexPath.row == 2) {
		cell.textLabel.text = @"Distance";
		cell.detailTextLabel.text = [Utils valueOrDefault:[scoreEvent distanceDescriptor]: @""];
 	} else {
		//notesTextField.text = sc
	    return notesCell;				
	}
	
	return cell;
	
//	}
}


- (void)selectionTableViewController:(SelectionListViewController *)selctionController 
						 completedSelectionsWithContext:(void *)selContext 
						 selectedObjects:(NSArray *)selectedObjects 
						 haveChanges:(BOOL)isChanged {
    if (!isChanged) {
        [selctionController clean];
        return;
    }
	
//    BlogDataManager *dataManager = [BlogDataManager sharedDataManager];
//    [[dataManager currentBlog] setObject:[selectedObjects objectAtIndex:0] forKey:kPostsDownloadCount];
//    noOfPostsTextField.text = [selectedObjects objectAtIndex:0];
	
	NSLog(@"selected : %@", [selectedObjects objectAtIndex:0]);
	if (selContext == SCORER_PROPERTY) {
		[scoreEvent setPlayer:[selectedObjects objectAtIndex:0]];
	} else  if (selContext == ASSISTER_PROPERTY) {
		[scoreEvent setAssister:[selectedObjects objectAtIndex:0]];
	} else  if (selContext == DISTANCE_PROPERTY) {
		[scoreEvent setDistanceDescriptor:[selectedObjects objectAtIndex:0]];
	} else {
		//[scoreEvent setNotes:[selectedObjects objectAtIndex:0]];
		// see textEditingDone for notes field
	}
	[[self tableView] reloadData];
    [selctionController clean];
}



- (NSString*) labelForRow: (int) row {
	return [LABEL_MAP objectAtIndex: row];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	/* scorers	
	   assisters
			- players on team
	   
	*/
	if (indexPath.row == 0) {
		NSArray *dataSource = [[gameLogMgr offensiveTeam] players];
		Player *curStatus = [scoreEvent player];
		[self createSelectListViewController: dataSource: curStatus: SCORER_PROPERTY: @"Scorer"];
	} else if (indexPath.row == 1) {
		NSArray *dataSource = [[gameLogMgr offensiveTeam] players];

		Player *curStatus = [scoreEvent assister];
		[self createSelectListViewController: dataSource: curStatus: ASSISTER_PROPERTY: @"Assister"];		
	} else if (indexPath.row == 2) {
		NSArray *dataSource = [ScoreEvent distanceOptions];
		NSString *curStatus = [scoreEvent distanceDescriptor];
		[self createSelectListViewController: dataSource: curStatus: DISTANCE_PROPERTY: @"Distance"];		
	}
	
}

- (void) createSelectListViewController: (NSArray*) dataSource: (id) curStatus:
										 (void*) propertyConst: (NSString*) controllerTitle {

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

- (void) doneSave {
	// set notes here b/c when you edit notes, then directly click save instead of done, notes doesn't get saved.
	[scoreEvent setNotes: notesTextField.text];
	
	[gameLogMgr score: scoreEvent];	
	scoreSaved = YES;
	[parentDelegate performSelector: updateSuccessCallBack
					withObject: nil];		

	[self.navigationController popViewControllerAnimated:YES];	
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


//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//	
//    if (textField == blogURLTextField) {
//        [userNameTextField becomeFirstResponder];
//    } else if (textField == userNameTextField) {
//        [passwordTextField becomeFirstResponder];
//    }
//	
//    return YES;
//}

- (void)dealloc {
	[gameLogMgr release];
	[scoreEvent release];
    [super dealloc];
}


@end

