//
//  ListSelectViewController.m
//  UltimateScorer
//
//  Created by Richard Chang on 2/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ListSelectViewController.h"
#import <objc/runtime.h>

@implementation ListSelectViewController

@synthesize options;
@synthesize currentOption;
@synthesize gameState;
@synthesize parentTableView;
@synthesize updateModelMethod;

//- (id)initWithStyle:(UITableViewStyle)style {
//    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
//    if (self = [super initWithStyle:style]) {
//    }
//    return self;
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"In viewDidLoad of detail view");
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	//self.navigationItem.rightBarButtonItem = [self];
   //.navigationItem.rightBarButtonItem = [myViewController editButtonItem];	
	
}


//- (void)viewWillAppear:(BOOL)animated {
//    // Update the view with current data before it is displayed.
//    [super viewWillAppear:animated];
//    
//    // Scroll the table view to the top before it appears
//    [self.tableView reloadData];
//    [self.tableView setContentOffset:CGPointZero animated:NO];
//    self.title = @"test title";
//}

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
	NSLog(@"in numRowsInSection");
    return [options count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"in cellForRow");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	NSString *val = [options objectAtIndex:indexPath.row];
	cell.textLabel.text = val;
	if ([val isEqualToString: currentOption]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;		
	}
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger optIndex = [options indexOfObject:self.currentOption];
    if (optIndex == indexPath.row) {
        return;
    }
	
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:optIndex inSection:0];
	
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentOption = [options objectAtIndex:indexPath.row];
    }
	
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
	
//	@try {
    	[gameState performSelector: updateModelMethod
				withObject: self.currentOption];		
//	} @catch (NSException *exception) {
//		NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);		
//	}

	
//	GameState * t = [[GameState alloc] init];	
//	int i=0;
//	unsigned int mc = 0;
//	Method * mlist = class_copyMethodList(object_getClass(t), &mc);
//	NSLog(@"%d methods", mc);
//	for(i=0;i<mc;i++)
//		NSLog(@"Method no #%d: %s", i, sel_getName(method_getName(mlist[i])));
	
    //[gameState.defense release];
	// update model
	// 
	
	//gameState.defense = self.currentOption;
	[parentTableView reloadData];
//	UIView *v = [[self parentViewController] view];
//    [v setNeedsDisplay]; 	
	
//    [gameState.offense release];
//	gameState.offense = self.currentOption;	
	
	// gameState.XXX needs updating
	//UltimateScorerTabAppDelegate *appDelegate = (UltimateScorerTabAppDelegate *)
	//										[[UIApplication sharedApplication] delegate];
	//[appDelegate.tabBarController.];

	
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
    [super dealloc];
	[options release];
}


@end

