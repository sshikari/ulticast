//
//  MyViewController.m
//  MyTabBar
//
//  Created by Evan Doll on 10/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "ListSelectViewController.h"
#import "GameLogMgrPool.h"
#import "GoalViewController.h"
#import "TurnViewController.h"
#import "CallViewController.h"
#import "FirstMenuViewController.h"

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
- (void) prepareUndoManager;
- (void) saveCurrentState: (NSData*) previousState;
- (void) saveCurrentState;

@end


@implementation GameViewController

@synthesize gameLogMgr;
@synthesize undoManager;
@synthesize timer;
@synthesize setupViewController;

// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil gameLogMgr:(GameLogMgr*) gLogMgr{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.gameLogMgr = gLogMgr;
        // Custom initialization
        self.title = @"Game View";
        self.tabBarItem.image = [UIImage imageNamed:@"all.png"];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Setup" style:UIBarButtonItemStylePlain 
	                                                       target:self action:@selector(setupMenu)];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain 
																				target:self action:@selector(timeoutMenu)];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyTimeout:) name:NOTIFICATION_TIMEOUT object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyTurnover:) name:NOTIFICATION_TURNOVER object:nil];

		SetupViewController *setpViewController = [[SetupViewController alloc] initWithNibName:@"SetupView" bundle:nil];
		setpViewController.gameState = [gameLogMgr gameState];  // TODO kinda clumsy, refactor

		UINavigationController *setupNavController = [[UINavigationController alloc] initWithRootViewController:setpViewController];
		setupViewController = setupNavController;
		
		[self prepareUndoManager];
		NSLog(@"------- setting state for first undo ------------");
		NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:gameLogMgr];
		[undoManager registerUndoWithTarget:self selector:@selector(undoEvent:) object:archivedObject];
		
    }
		
    return self;
}


- (void) setupMenu {
	NSLog(@"setup menu");
	[self presentModalViewController:setupViewController animated:YES];
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	NSString* timeoutTeam1 = [NSString stringWithFormat:@"Timeout - %@", [gameLogMgr team1Name]];
	NSString* timeoutTeam2 = [NSString stringWithFormat:@"Timeout - %@", [gameLogMgr team2Name]];	
	
	// RESUME time
	NSString* title = [alertView title];
	
	if ([title isEqualToString:timeoutTeam1]) {		
		[self saveCurrentState];
		[gameLogMgr timeoutTeam1End];	
	} else if ([title isEqualToString:timeoutTeam2]){
		[self saveCurrentState];
		[gameLogMgr timeoutTeam2End];			
	} else if ([title isEqualToString:@"Halftime"]){
		[self saveCurrentState];		
		[gameLogMgr timeoutHalfTimeEnd];	
	} else if ([title isEqualToString:@"Timeout - Injury"]){
		[self saveCurrentState];
		[gameLogMgr timeoutInjuryEnd];	
	} else if ([title isEqualToString:@"End Game"]){
		if (buttonIndex == 1) {
			[self saveCurrentState];
			[gameLogMgr timeoutEndGame];
			[[GameLogMgrPool sharedInstance] clearGameInProgress];
			self.gameLogMgr = nil;
			[self updateStatusLabel:@"Game Ended"];
			[self.navigationController popToRootViewControllerAnimated:YES];
			[self.undoManager removeAllActions];
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
		[self saveCurrentState];
		[gameLogMgr timeoutTeam1];		
	} else if (buttonIndex == 1) {
		[self saveCurrentState];
		[gameLogMgr timeoutTeam2];				
	} else if (buttonIndex == 2) {
		[self saveCurrentState];
		[gameLogMgr timeoutInjury];
	} else if (buttonIndex == 3) {
		[self saveCurrentState];
		[gameLogMgr timeoutHalfTime];
	} else if (buttonIndex == 4) {
		//FirstMenuViewController *firstMenuController = [[FirstMenuViewController alloc] initWithNibName:@"FirstMenuViewController" bundle:nil];	
		//[[self navigationController] pushViewController:firstMenuController animated:YES];
		//[firstMenuController release];
		[[GameLogMgrPool sharedInstance] saveGameInProgress: gameLogMgr];
		[self.navigationController popToRootViewControllerAnimated:YES];
		return;
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
        [popupQuery showInView:self.navigationController.view];
        [popupQuery release];
}


- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self resignFirstResponder];
}


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
	//static int count = 60 * 60;  // total secs for 60 minutes    
	
	if ([gameLogMgr gameTimeRunning]) {
		int secsLeft = [gameLogMgr tickGameTime];
		int minutes = secsLeft / 60;
		
		int seconds = secsLeft % 60;
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
	
	//TODO might have less than 7 players on your team.
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
			
	
	
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
											 target:self
										   selector:@selector(updateGameTime:)
										   userInfo:nil
											repeats:YES];
	
	[self updatePassesLabel];
	[self updateGameTime: timer];
    //[self updateStatusLabel:@"Starting game..."];
	
}





- (void) prepareUndoManager {
	NSUndoManager *anUndoManager = [[NSUndoManager alloc] init];
	self.undoManager = anUndoManager;
	[anUndoManager release];
	
	[undoManager setLevelsOfUndo:10];
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:undoManager];
	[dnc addObserver:self selector:@selector(undoManagerDidRedo:) name:NSUndoManagerDidRedoChangeNotification object:undoManager];	
}

- (void) undoEvent: (NSData*) previousState {
	self.gameLogMgr = (GameLogMgr*) [NSKeyedUnarchiver unarchiveObjectWithData:previousState];
	NSLog(@"executing callback for UNDO, game id : %d, score: %d to %d ", [gameLogMgr gameId], [gameLogMgr team1Score], [gameLogMgr team2Score]);
}

- (void) saveCurrentState {
	NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:gameLogMgr];
	[self saveCurrentState: archivedObject];
}

- (void) saveCurrentState: (NSData*) previousState {

	if ([undoManager isUndoing] || [undoManager isRedoing]) {
		// will be called with previous state, add under for CURRENT state
		NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:gameLogMgr];
		[undoManager registerUndoWithTarget:self selector:@selector(saveCurrentState:) object:archivedObject];						
	} else {
		// just a saving of state, save with passed in previous state
		[undoManager registerUndoWithTarget:self selector:@selector(saveCurrentState:) object:previousState];
	}

	self.gameLogMgr = (GameLogMgr*) [NSKeyedUnarchiver unarchiveObjectWithData:previousState];
}



- (void)undoManagerDidUndo:(NSNotification *)notification {
	NSLog(@"did undo");
	[self viewDidLoad];
}


- (void)undoManagerDidRedo:(NSNotification *)notification {
	NSLog(@"did REdo");
	[self viewDidLoad];
}





- (void) setPossessionMarker {
	if ([gameLogMgr team1HasPossession]) {
				[team1HasPossession setBackgroundColor:[UIColor blueColor]];
				[team2HasPossession setBackgroundColor:[UIColor grayColor]];
		
	} else {
		[team1HasPossession setBackgroundColor:[UIColor grayColor]];
		 [team2HasPossession setBackgroundColor:[UIColor blueColor]];
		
	}
}
		 
- (IBAction) undoButton:(id)sender {
	NSLog(@"Undo pressed");	
	
}


- (IBAction) addPass:(id)sender {
	[self addPassForPlayer: nil];
}

- (void) addPassForPlayer : (Player*) player{
	[self saveCurrentState];
	[gameLogMgr pass: player];
	[self updatePassesLabel];
	NSString* status = player == nil 
						? @"Pass completed" 
					    : [NSString stringWithFormat:@"Pass completed to %@", [player nickname]];
	[self updateStatusLabel: status];
	//[status release];
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



#pragma mark event methods


- (IBAction) call:(id)sender {
	NSLog(@"call button");	
	CallViewController* callViewController = [[CallViewController alloc] initWithNibName:@"CallViewController" bundle:nil];
	[callViewController prep: gameLogMgr: @selector(updateCall:): self];
	
	[[self navigationController] pushViewController:callViewController animated:YES];
	[callViewController release];
}


- (void) updateCall :(CallEvent*) callEvent{
	[self saveCurrentState];
	[gameLogMgr call: callEvent];
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
	[turnViewController prep: gameLogMgr: @selector(updateTurn:): self];
	
	[[self navigationController] pushViewController:turnViewController animated:YES];
	[turnViewController release];
}

- (void) updateTurn : (TurnEvent*) turnEvent{
	[self saveCurrentState];
	[gameLogMgr turn: turnEvent];
	[self turnover];
	[self updateStatusLabel:@"Turnover"];
}


- (IBAction) score:(id)sender{
	[self score];
}

- (void) score {
	GoalViewController* goalViewController = [[GoalViewController alloc] initWithNibName:@"GoalViewController" bundle:nil];
	[goalViewController prep: gameLogMgr: @selector(updateScore:): self];
	
	[[self navigationController] pushViewController:goalViewController animated:YES];
	[goalViewController release];	
}

- (void) updateScore : (ScoreEvent*) scoreEvent{
	// add score to team with possession
	//	[gameLogMgr score];
	[self saveCurrentState];
	[gameLogMgr score:scoreEvent];
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
	statusLabel.text = [NSString stringWithFormat:@"%@", str];	
}

- (void) updatePassesLabel {
	numberOfPassesLabel.text = [NSString stringWithFormat:@"%d passes", [gameLogMgr passes]];	
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
	[timer invalidate];
	[[GameLogMgrPool sharedInstance] saveGameInProgress: gameLogMgr];

	[gameLogMgr release];
	[setupViewController release];
    [super dealloc];
}


@end
