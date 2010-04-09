//
//  MyViewController.m
//  MyTabBar
//
//  Created by Evan Doll on 10/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "ListSelectViewController.h"
#import "GameLogMgr.h"
#import "GoalViewController.h"
#import "TurnViewController.h"
#import "CallViewController.h"

NSString *const NOTIFICATION_TIMEOUT = @"NOTIFICATION_TIMEOUT";
NSString *const NOTIFICATION_TURNOVER = @"NOTIFICATION_TURNOVER";

@interface GameViewController (private)
- (void) timeout;
- (void) addPass;
- (void) score;
- (void) turn;
- (void) showTimeoutAlert : (NSString*) buttonTitle
						  : (NSString*) msg 
						  : (NSString*) okButton
						  : (NSString*) cancelButtonMsg;
- (void) addPassForPlayer: (Player*) player;
@end


@implementation GameViewController

@synthesize gameLogMgr;
@synthesize timer;
@synthesize setupViewController;

// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
        self.title = @"Game View";
        self.tabBarItem.image = [UIImage imageNamed:@"all.png"];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Setup" style:UIBarButtonItemStylePlain 
	                                                       target:self action:@selector(setupMenu)];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain 
																				target:self action:@selector(timeoutMenu)];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyTimeout:) name:NOTIFICATION_TIMEOUT object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyTurnover:) name:NOTIFICATION_TURNOVER object:nil];

    }
    return self;
}


- (void) setupMenu {
	NSLog(@"setup menu");
	[self presentModalViewController:setupViewController animated:YES];   
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	NSString* timeoutTeam1 = [NSString stringWithFormat:@"Timeout - %@", [gameLogMgr team1Name]];
	NSString* timeoutTeam2 = [NSString stringWithFormat:@"Timeout - %@", [gameLogMgr team2Name]];	
	
	// RESUME time
	NSString* title = [alertView title];
	
	if ([title isEqualToString:timeoutTeam1]) {		
		[gameLogMgr timeoutTeam1End];	
	} else if ([title isEqualToString:timeoutTeam2]){
		[gameLogMgr timeoutTeam2End];			
	} else if ([title isEqualToString:@"Halftime"]){
		[gameLogMgr timeoutHalfTimeEnd];	
	} else if ([title isEqualToString:@"Timeout - Injury"]){
		[gameLogMgr timeoutInjuryEnd];	
	} else if ([title isEqualToString:@"End Game"]){
		if (buttonIndex == 1) {
			[gameLogMgr timeoutEndGame];
			[self updateStatusLabel:@"Game Ended"];
			return;
		} else {
			return;  // no action
		}
    }
	[self updateStatusLabel:@"Starting time"];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {	
	// when can you release these? 
    NSString* msg = @"Click to resume";
    NSString* cancelButtonMsg = @"Resume game";		
	NSString* okButtonMsg = nil;		
	NSString* buttonTitle = [actionSheet buttonTitleAtIndex: buttonIndex];
	
	if (buttonIndex == 0) {  // timeout team 1		
		[gameLogMgr timeoutTeam1];		
	} else if (buttonIndex == 1) {
		[gameLogMgr timeoutTeam2];				
	} else if (buttonIndex == 2) {
		[gameLogMgr timeoutInjury];						
	} else if (buttonIndex == 3) {
		[gameLogMgr timeoutHalfTime];				
	} else if (buttonIndex == 5) {
		// game end
		[self showTimeoutAlert:@"End Game": @"Are you sure you want to end the game?" :
								@"End Game" : @"Cancel"];		
		return;
	} else {
		return;	
	}
	[self updateStatusLabel:buttonTitle];
	[self showTimeoutAlert:buttonTitle: msg : okButtonMsg: cancelButtonMsg];
	
}

- (void) showTimeoutAlert : (NSString*) buttonTitle
						  : (NSString*) msg 
						  : (NSString*) okButtonMsg
						  : (NSString*) cancelButtonMsg {
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:buttonTitle 
														message:msg 
													   delegate:self 
													   cancelButtonTitle:cancelButtonMsg 								  
											           otherButtonTitles:okButtonMsg];
	[alertView show];
	[alertView release];				
}
- (void) timeoutMenu {
	NSLog(@"timeout menu");
	NSString* timeoutTeam1 = [NSString stringWithFormat:@"Timeout - %@", [gameLogMgr team1Name]];
	NSString* timeoutTeam2 = [NSString stringWithFormat:@"Timeout - %@", [gameLogMgr team2Name]];	

	UIActionSheet *popupQuery = [[UIActionSheet alloc]
									 initWithTitle:nil
									 delegate:self
									 cancelButtonTitle:@"Cancel"
									 destructiveButtonTitle:nil
									 otherButtonTitles:timeoutTeam1,
													   timeoutTeam2,
													   @"Timeout - Injury",
													   @"Halftime",
													   @"Home",
													   @"End Game",
													   nil];
		
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupQuery showInView:self.tabBarController.view];
        [popupQuery release];
}

//- (void) timeout {
//}


- (void) callMenu {
	NSLog(@"In call menu");
}

- (void)notifyTimeout:(NSNotification *)notification {
	//id notificationSender = [notification object];
	NSLog(@"Timeout notif!!");	

    // stop timer
	
}

- (void)notifyTurnover:(NSNotification *)notification {
	//id notificationSender = [notification object];
	NSLog(@"Turnover notif!!");	
	[self turnover];
}

- (void)updateGameTime:(NSTimer *)theTimer {
	static int count = 60 * 60;  // total secs for 60 minutes    
	if ([gameLogMgr gameTimeRunning]) {
		count -= 1;
		int minutes = count / 60;
		int seconds = count % 60;
		NSString *s = [[NSString alloc]
				   initWithFormat:@"%d:%2d", minutes, seconds % 60];
		gameTimeLabel.text = s;
		[s release];
	}
}


- (void) viewDidLoad {
	NSLog(@"in viewDidLoad");	
	// set lables from gamestate
	team1NameLabel.text = [gameLogMgr team1Name];
	team1ScoreLabel.text = [NSString stringWithFormat:@"%d", [gameLogMgr team1Score]];
	team2NameLabel.text = [gameLogMgr team2Name];
	team2ScoreLabel.text = [NSString stringWithFormat:@"%d", [gameLogMgr team2Score]];	
	[self setPossessionMarker];
	
	//TODO your team!
	NSArray* players = [[gameLogMgr offensiveTeam] players];
	[pass1Button setTitle:[NSString stringWithFormat:@"%d", [[players objectAtIndex:0] number]]
				 forState:UIControlStateNormal];
	[pass2Button setTitle:[NSString stringWithFormat:@"%d", [[players objectAtIndex:1] number]]
				 forState:UIControlStateNormal];
	[pass3Button setTitle:[NSString stringWithFormat:@"%d", [[players objectAtIndex:2] number]]
				 forState:UIControlStateNormal];
	[pass4Button setTitle:[NSString stringWithFormat:@"%d", [[players objectAtIndex:3] number]]
				 forState:UIControlStateNormal];
	[pass5Button setTitle:[NSString stringWithFormat:@"%d", [[players objectAtIndex:4] number]]
				 forState:UIControlStateNormal];
	[pass6Button setTitle:[NSString stringWithFormat:@"%d", [[players objectAtIndex:5] number]]
				 forState:UIControlStateNormal];
	[pass7Button setTitle:[NSString stringWithFormat:@"%d", [[players objectAtIndex:6] number]]
				 forState:UIControlStateNormal];
	
		
	numberOfPassesLabel.text = @"0";
	gameTimeLabel.text = @"0";
    [self updateStatusLabel:@"Starting game..."];
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
									 target:self
								   selector:@selector(updateGameTime:)
								   userInfo:nil
									repeats:YES];
}

- (void) setPossessionMarker {
	if ([gameLogMgr team1HasPossession]) {
//		[team1HasPossession setHidden:NO];
//		[team2HasPossession setHidden:YES];
				[team1HasPossession setBackgroundColor:[UIColor blueColor]];
				[team2HasPossession setBackgroundColor:[UIColor grayColor]];
		
	} else {
//		[team1HasPossession setHidden:YES];
//		[team2HasPossession setHidden:NO];
		[team1HasPossession setBackgroundColor:[UIColor grayColor]];
		 [team2HasPossession setBackgroundColor:[UIColor blueColor]];
		
	}
}
		 

- (IBAction) addPass:(id)sender {
	[self addPassForPlayer: nil];
}

- (void) addPassForPlayer : (Player*) player{
	[gameLogMgr pass: player];
	[self updatePassesLabel];
	[self updateStatusLabel:@"Pass completed"];	
}

- (IBAction) addPass1:(id)sender {
	[self addPassForPlayer: [[gameLogMgr offensiveTeam] playerAtIndex: 0]];	
}
- (IBAction) addPass2:(id)sender {
	[self addPassForPlayer: [[gameLogMgr offensiveTeam] playerAtIndex: 1]];	
}
- (IBAction) addPass3:(id)sender {
	[self addPassForPlayer: [[gameLogMgr offensiveTeam] playerAtIndex: 2]];	
}
- (IBAction) addPass4:(id)sender {
	[self addPassForPlayer: [[gameLogMgr offensiveTeam] playerAtIndex: 3]];	
}
- (IBAction) addPass5:(id)sender {
	[self addPassForPlayer: [[gameLogMgr offensiveTeam] playerAtIndex: 4]];	
}
- (IBAction) addPass6:(id)sender {
	[self addPassForPlayer: [[gameLogMgr offensiveTeam] playerAtIndex: 5]];	
}
- (IBAction) addPass7:(id)sender {
	[self addPassForPlayer: [[gameLogMgr offensiveTeam] playerAtIndex: 6]];	
}



#pragma mark table methods
// Customize the number of rows in the table view.
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [[gameState detailsArray] count];
//}



// Customize the appearance of table view cells.
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
//    NSString *cellId = @"cellId";   //[NSString stringWithFormat:@"%d", indexPath.row];
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewStylePlain 
//									   reuseIdentifier:cellId] autorelease];
//		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//		//cell.textLabel.font = [UIFont systemFontOfSize:14.0];
//    }
//    
//    // Set up the cell...
//	cell.textLabel.text = [[gameState detailsArray] objectAtIndex:indexPath.row];	
//    return cell;
//}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	UIViewController *listSelectViewController = [self detailViewController:indexPath]; 	
//	[[self navigationController] pushViewController:listSelectViewController animated:YES];
//	NSLog(@"Pushing new view controller : %@", listSelectViewController);
//	
//}
//
//- (UIViewController*) detailViewController: (NSIndexPath *)indexPath {
//	NSArray *options;
//	NSString *propertyType;
//	switch (indexPath.row) {
//		case 0:  
//			propertyType = @"defense";
//			break;
//		case 1:  
//			propertyType = @"offense";
//			break;
//		case 2:  
//			propertyType = @"wind";			
//			break;			
//		default:
//			break;
//	}
//
//
//	SEL propertySelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [propertyType capitalizedString]]);
//	SEL optionsSelector = NSSelectorFromString([NSString stringWithFormat:@"%@Options", propertyType]);
//	options = [[GameState class] performSelector:optionsSelector];
//	
//	ListSelectViewController *listSelectViewController = [[ListSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
//	listSelectViewController.gameState = gameState;
//	listSelectViewController.options = options;
//	listSelectViewController.currentOption = [[gameState detailsArray] objectAtIndex:indexPath.row];
//	listSelectViewController.updateModelMethod = propertySelector;
//	listSelectViewController.parentTableView = mainDetailsTableView;
//	[options retain];   // TODO
//	[listSelectViewController autorelease];
//	NSLog(@"reached pushing new view controller");
//	NSLog(@"options : %@", options);
//	return listSelectViewController;
//}



//- (IBAction) scoreForTeam1:(id)sender {
//	if (gameState.team1HasPossession) {
//		gameState.team1Score++;
//		team1ScoreLabel.text = [NSString stringWithFormat:@"%d", gameState.team1Score];	
//		lastScoreTimeLabel.text = gameTimeLabel.text;
//	} else { // change possession
//		[self turnover];
//	}
//}
//
//- (IBAction) scoreForTeam2:(id)sender {
//	if (! gameState.team1HasPossession) {
//		gameState.team2Score++;
//		team2ScoreLabel.text = [NSString stringWithFormat:@"%d", gameState.team2Score];		
//		lastScoreTimeLabel.text = gameTimeLabel.text;
//	} else { // change possession
//		[self turnover];
//	}
//}


#pragma mark event methods


- (IBAction) call:(id)sender {
	NSLog(@"call button");	
	CallViewController* callViewController = [[CallViewController alloc] initWithNibName:@"CallViewController" bundle:nil];
	[callViewController prep: gameLogMgr: @selector(updateCall): self];
	
	[[self navigationController] pushViewController:callViewController animated:YES];
	[callViewController release];
}


- (void) updateCall {
	[self turnover];
	//[self call];
	[self updateStatusLabel:@"CALL"];
}

- (IBAction) tappedTeam1:(id)sender {
	if ([gameLogMgr team1HasPossession]) {
		[self score];
	} else {
		[self turn];
	}
}
- (IBAction) tappedTeam2:(id)sender {
	if ([gameLogMgr team1HasPossession]) {
		[self turn];
	} else {
		[self score];
	}
}



- (IBAction) turn:(id)sender {
	[self turn];
}

- (void) turn {
	NSLog(@"turn button");	
	TurnViewController* turnViewController = [[TurnViewController alloc] initWithNibName:@"TurnViewController" bundle:nil];
	[turnViewController prep: gameLogMgr: @selector(updateTurn): self];
	
	[[self navigationController] pushViewController:turnViewController animated:YES];
	[turnViewController release];
	
}

- (void) updateTurn {
	[self turnover];
	[self updateStatusLabel:@"Turnover"];
}


- (IBAction) score:(id)sender{
	[self score];
}

- (void) score {
	GoalViewController* goalViewController = [[GoalViewController alloc] initWithNibName:@"GoalViewController" bundle:nil];
	[goalViewController prep: gameLogMgr: @selector(updateScore): self];
	
	[[self navigationController] pushViewController:goalViewController animated:YES];
	[goalViewController release];	
}

- (void) updateScore {
	// add score to team with possession
	//	[gameLogMgr score];
	[self updateScoresLabels];
	lastScoreTimeLabel.text = gameTimeLabel.text;
	// prompt user to line change
	[self turnover];	
	[self updateStatusLabel:@"Scored"];	
}

- (void) updateScoresLabels {
	team1ScoreLabel.text = [NSString stringWithFormat:@"%d", [gameLogMgr team1Score]];	
	team2ScoreLabel.text = [NSString stringWithFormat:@"%d", [gameLogMgr team2Score]];		
}

//- (IBAction) timeout:(id)sender{	
//	[self timeout];
//}


// end event methods

- (void) updateStatusLabel:(NSString*) str {
	[gameLogMgr logEvents];
	statusLabel.text = [NSString stringWithFormat:@"%@", str];	
}

- (void) updatePassesLabel {
	numberOfPassesLabel.text = [NSString stringWithFormat:@"%d passes", [gameLogMgr passes]];	
	//addPassButton.titleLabel.text = [NSString stringWithFormat:@"%d passes", [gameLogMgr passes]];	

}
- (void) turnover {	 
	//[gameLogMgr turnover];
	[self setPossessionMarker];
	[self updatePassesLabel];		
}

- (void) timeStop {
	
}	

//- (IBAction) changePossessionToTeam1:(id)sender {
//}
//- (IBAction) changePossessionToTeam2:(id)sender {
//}
- (IBAction) showCommentScreen:(id)sender {
}

- (void)dealloc {
    [super dealloc];
	[gameLogMgr release];
}


@end
