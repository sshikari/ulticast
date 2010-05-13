//
//  LoginViewController.m
//  ulticast
//
//  Created by Richard Chang on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "FirstMenuViewController.h"
#import "AuthenticationMgr.h"
#import "Utils.h"
#import "FBConnect/FBConnect.h"
#import "Constants.h"

@interface LoginViewController(private)
- (void) loginSucceeded;
- (void) disableLabel:(UILabel *)label andTextField:(UITextField *)textField;
- (void) login;
@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Ulticast";
	passwordField.secureTextEntry = YES;
	
	fbSession = [[FBSession sessionForApplication:@"380fac2e76c7718bf1b802c7664db89b"
												secret:@"a1ebc3b7f496981808c1e04ff14329e2" 
									   delegate:self] retain];

//	[self disableLabel:usernameLabel andTextField:usernameField];
//	[self disableLabel:passwordLabel andTextField:passwordField];

	// this is the manual way to add their button	
	//	FBLoginButton* button = [[[FBLoginButton alloc] init] autorelease];
	//	[self.view addSubview:button];
}

- (void) session: (FBSession*)session didLogin:(FBUID)uid {
	// gets the fb user's name
	NSString *fql = [NSString stringWithFormat:@"select uid, name from user where uid==%lld", uid];
	NSDictionary *params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
}

- (void)request:(FBRequest*)request didLoad:(id)result {
	NSArray* results = result;
	NSDictionary *users = [results objectAtIndex:0];
	NSString* loginName = [users objectForKey: @"name"];
    NSLog(@"FB connect worked!!! user: %@ logged in", loginName);	
	
}

- (void)disableLabel:(UILabel *)label andTextField:(UITextField *)textField {
    [label setTextColor:kDisabledTextColor];
    [textField setTextColor:kDisabledTextColor];
    [textField setEnabled:NO];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//self.navigationController.navigationBarHidden = YES;
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationBarHidden = NO;

}

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


- (IBAction) fbButtonClicked:(id) sender {
	FBLoginDialog* dialog = [[FBLoginDialog alloc] initWithSession:fbSession]; 
	[dialog show];	
	[dialog release];
}

- (IBAction) clearButtonClicked:(id) sender {
    usernameField.text = @"";
	passwordField.text = @"";
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}

- (IBAction) loginButtonClicked:(id) sender {
	[self login];		
}

- (void) login {
	[loginIndicator startAnimating];
	// TODO, make asynchronous?
	BOOL success = [[AuthenticationMgr sharedInstance] login: usernameField.text : passwordField.text];
	if (success) {
		[self loginSucceeded];	
	} else {
		[Utils showTimeoutAlert:self :@"Login Failed" :@"Login or password incorrect" :nil :@"Continue"];		
	}
	
	[loginIndicator stopAnimating];	
}

- (void) loginSucceeded {
	FirstMenuViewController *firstMenuController = [[FirstMenuViewController alloc] initWithNibName:@"FirstMenuViewController" bundle:nil];	
	[[self navigationController] pushViewController:firstMenuController animated:YES];
	[firstMenuController release];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (IBAction) textFieldDoneEditing: (id) sender {
	[sender resignFirstResponder];
	if (sender == usernameField)
		[passwordField becomeFirstResponder];
	else 
		[self login];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (indexPath.row == 0) {
		return usernameCell;
	} else if (indexPath.row == 1) {
		return passwordCell;	
	} 
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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
//	[fbSession.delegates removeObject: self]; 
	[loginTable release];	
	[usernameLabel release];
	[usernameField release];
	[usernameCell release];		
	[passwordLabel release];
	[passwordField release];
	[passwordCell release];	
	[loginIndicator release];	
	[fbButton release];
    [super dealloc];
}


@end

