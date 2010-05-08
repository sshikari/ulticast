//
//  MyTabBarAppDelegate.m
//  MyTabBar
//
//  Created by Evan Doll on 10/16/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "UltimateScorerTabAppDelegate.h"
#import "GameViewController.h"
#import "GameState.h";
#import "FirstMenuViewController.h"
#import "LoginViewController.h"
#import "AuthenticationMgr.h"
#import "GameLogMgrPool.h"

@implementation UltimateScorerTabAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize firstMenuNavController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

//    tabBarController = [[UITabBarController alloc] init];
//
//	// Test data
//	Team *harvard = [[Team alloc] initWithName:@"Harvard"];
//	Team *tufts = [[Team alloc] initWithName:@"Tufts"];
//	Player *bill = [[Player alloc] initWith: 21: @"Bill"];
//	Player *hillary = [[Player alloc] initWith: 22: @"Hillary"];
//	
//	Player *blake = [[Player alloc] initWith: 11: @"Blake"];
//	Player *rich = [[Player alloc] initWith: 12: @"Rich"];
//	
//	NSArray* hPlayers = [NSArray arrayWithObjects:bill, hillary, 
//												  [[Player alloc] initWith: 23: @"P23"],
//												  [[Player alloc] initWith: 24: @"P24"],
//												  [[Player alloc] initWith: 25: @"P25"],
//												  [[Player alloc] initWith: 26: @"P26"],
//												  [[Player alloc] initWith: 27: @"P27"],
//												  nil];
//	NSArray* tPlayers = [NSArray arrayWithObjects:rich, blake, 
//						 [[Player alloc] initWith: 13: @"P13"],
//						 [[Player alloc] initWith: 14: @"P14"],
//						 [[Player alloc] initWith: 15: @"P15"],
//						 [[Player alloc] initWith: 16: @"P16"],
//						 [[Player alloc] initWith: 17: @"P17"],
//						 nil];
//	[tufts setPlayers: tPlayers];
//	[harvard setPlayers: hPlayers];
//
//    
//	GameLogMgr *gameLogMgr = [GameLogMgr newGameLogMgr: harvard : tufts];
		
			
    // Create a few view controllers
//	GameViewController *gameViewController = [[GameViewController alloc] initWithNibName:@"GameView" bundle:nil];
//	gameViewController.gameLogMgr = gameLogMgr;
//	
//	SetupViewController *setupViewController = [[SetupViewController alloc] initWithNibName:@"SetupView" bundle:nil];
//	setupViewController.gameState = [gameLogMgr gameState];
//	
//    UIViewController *lineViewController = [[UIViewController alloc] init];
//    lineViewController.title = @"LINE";
//    lineViewController.tabBarItem.image = [UIImage imageNamed:@"search.png"];
//    lineViewController.view.backgroundColor = [UIColor blueColor];
//    
//    // Add them as children of the tab bar controller
//	UINavigationController *gameNavController = [[UINavigationController alloc] initWithRootViewController:gameViewController];
//
//	UINavigationController *setupNavController = [[UINavigationController alloc] initWithRootViewController:setupViewController];
//	gameViewController.setupViewController = setupNavController;


//    [tabBarController setViewControllers: [NSArray arrayWithObjects: gameNavController, lineViewController, nil] 
//							   animated : YES];
//
//    // Don't forget memory management
//    [gameViewController release];
//    [gameNavController release];
//    [lineViewController release];
//    [setupViewController release];
	
		
//	FirstMenuViewController *firstMenuController = [[FirstMenuViewController alloc] initWithNibName:@"FirstMenuViewController" bundle:nil];	
//	firstMenuNavController = [[UINavigationController alloc] initWithRootViewController:firstMenuController];
//	[window addSubview:firstMenuNavController.view];

	
	UIViewController *firstView = nil;
	
	//if ([[AuthenticationMgr sharedInstance] isLoggedIn]) {
	//	firstView = [[FirstMenuViewController alloc] initWithNibName:@"FirstMenuViewController" bundle:nil];
	//} else {
		firstView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	//}
	
	firstMenuNavController = [[UINavigationController alloc] initWithRootViewController:firstView];
	[firstView release];
	if ([[AuthenticationMgr sharedInstance] isLoggedIn]) {
		FirstMenuViewController *mainMenu = [[FirstMenuViewController alloc] initWithNibName:@"FirstMenuViewController" bundle:nil];
		[firstMenuNavController pushViewController:mainMenu animated:YES];
		[mainMenu release];
	}
	[window addSubview:firstMenuNavController.view];

    // Add the tab bar controller's view to the window
    [window makeKeyAndVisible];
}

- (void) applicationWillTerminate:(UIApplication *)application {
	[[GameLogMgrPool sharedInstance] saveGameInProgress];
	[[AuthenticationMgr sharedInstance] saveUserInfo];
}

- (void)dealloc {
    [tabBarController release];
	[firstMenuNavController release];
    [window release];	
    [super dealloc];
}


@end
