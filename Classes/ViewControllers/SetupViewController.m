//
//  SetupViewController.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 2/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetupViewController.h"
#import "ListSelectViewController.h"

@interface SetupViewController(private)
- (NSString*) labelForRow: (int) row;
- (UIViewController*) detailViewController: (NSIndexPath *)indexPath;

@end


@implementation SetupViewController

@synthesize gameState;
@synthesize setupTableView;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain 
																				 target:self action:@selector(backToGame)];

    }
    return self;
}

- (void) backToGame {
	NSLog(@"back to game");	
	[self dismissModalViewControllerAnimated:YES];

}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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
    return [[gameState detailsArray] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    NSString *cellId = @"cellId";   //[NSString stringWithFormat:@"%d", indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
									   reuseIdentifier:cellId] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		//cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    // Set up the cell...
	cell.detailTextLabel.text = [[gameState detailsArray] objectAtIndex:indexPath.row];
	cell.textLabel.text = [self labelForRow:indexPath.row]; 	
    return cell;
}

- (NSString*) labelForRow: (int) row {
	NSString *propertyType;
	switch (row) {
		case 0:  
			propertyType = @"defense";
			break;
		case 1:  
			propertyType = @"offense";
			break;
		case 2:  
			propertyType = @"wind";			
			break;			
		default:
			break;
	}
	
	return propertyType;
}
						   

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	//UITableViewCell *selectedCell = [self.callsTableView cellForRowAtIndexPath:indexPath];
	//selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
	
	// foul, drop, pick, stall -> turnover
	// time out - stop time
	
//	NSString *selectedCall = [calls objectAtIndex:indexPath.row];
//	@try {
//		if ([selectedCall isEqualToString: @"Timeout"]) {
//			// send notification to stop time		
//			[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIMEOUT object:nil];		
//		} else {
//			// change possession
//			[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TURNOVER object:nil];
//		}
//	}
//	@catch (NSException * exception) {
//		NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
//	}
//	
//	// swap to gameView 
//	//[self viewWillDisappear:YES];
//	[self dismissModalViewControllerAnimated:YES];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIViewController *listSelectViewController = [self detailViewController:indexPath]; 	
	[[self navigationController] pushViewController:listSelectViewController animated:YES];
	NSLog(@"Pushing new view controller : %@", listSelectViewController);
	
}

- (UIViewController*) detailViewController: (NSIndexPath *)indexPath {
	NSArray *options;
	NSString *propertyType = [self labelForRow:indexPath.row];	
	
	SEL propertySelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [propertyType capitalizedString]]);
	SEL optionsSelector = NSSelectorFromString([NSString stringWithFormat:@"%@Options", propertyType]);
	options = [[GameState class] performSelector:optionsSelector];
	
	ListSelectViewController *listSelectViewController = [[ListSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
	listSelectViewController.gameState = gameState;
	listSelectViewController.options = options;
	listSelectViewController.currentOption = [[gameState detailsArray] objectAtIndex:indexPath.row];
	listSelectViewController.updateModelMethod = propertySelector;
	listSelectViewController.parentTableView = setupTableView;
	[options retain];   // TODO
	[listSelectViewController autorelease];
	NSLog(@"reached pushing new view controller");
	NSLog(@"options : %@", options);
	[propertyType release];
	return listSelectViewController;
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
}


@end
