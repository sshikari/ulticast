//
//  MyViewController.h
//  MyTabBar
//
//  Created by Evan Doll on 10/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameLogMgr.h";
#import "GameState.h";
#import "SetupViewController.h";
extern NSString *const NOTIFICATION_TIMEOUT;
extern NSString *const NOTIFICATION_TURNOVER;


@interface GameViewController : UIViewController<UIActionSheetDelegate> {
    NSTimer *timer;	
	UINavigationController *setupViewController;
	GameLogMgr *gameLogMgr;
	NSUndoManager *undoManager;
	
    IBOutlet UILabel *team1NameLabel;
	IBOutlet UILabel *team2NameLabel;
    IBOutlet UILabel *team1ScoreLabel;
	IBOutlet UILabel *team2ScoreLabel;
	IBOutlet UIButton *team1RecordScoreButton;
	IBOutlet UIButton *team2RecordScoreButton;	
	IBOutlet UIButton *team1PossessionButton;
	IBOutlet UIButton *team2PossessionButton;	
	IBOutlet UIButton *commentButton;
	
	
	IBOutlet UIButton *pass1Button;	
	IBOutlet UIButton *pass2Button;	
	IBOutlet UIButton *pass3Button;	
	IBOutlet UIButton *pass4Button;
	IBOutlet UIButton *pass5Button;	
	IBOutlet UIButton *pass6Button;	
	IBOutlet UIButton *pass7Button;	
	
	IBOutlet UILabel *lastScoreTimeLabel;
	IBOutlet UILabel *gameTimeLabel;

	IBOutlet UILabel *numberOfPassesLabel;
	IBOutlet UIButton *addPassButton;

	IBOutlet UIButton *scoreButton;
	IBOutlet UIButton *foulButton;
	IBOutlet UIButton *blockButton;
	IBOutlet UIButton *timeoutButton;
	IBOutlet UIButton *dropButton;
	IBOutlet UILabel *statusLabel;
	IBOutlet UIButton *team1HasPossession;
	IBOutlet UIButton *team2HasPossession;	
	IBOutlet UITableView *mainDetailsTableView;
}

- (IBAction) showCommentScreen:(id)sender;
- (IBAction) addPass1:(id)sender;
- (IBAction) addPass2:(id)sender;
- (IBAction) addPass3:(id)sender;
- (IBAction) addPass4:(id)sender;
- (IBAction) addPass5:(id)sender;
- (IBAction) addPass6:(id)sender;
- (IBAction) addPass7:(id)sender;
- (IBAction) undoButton:(id)sender;

- (IBAction) addPass:(id)sender;

//- (IBAction) block:(id)sender;
//- (IBAction) foul:(id)sender;
//- (IBAction) drop:(id)sender;
//- (IBAction) score:(id)sender;
//- (IBAction) timeout:(id)sender;

- (IBAction) call:(id)sender;
- (IBAction) turn:(id)sender;

- (IBAction) tappedTeam1:(id)sender;
- (IBAction) tappedTeam2:(id)sender;

- (void) updateStatusLabel:(NSString*) str;
- (void) updatePassesLabel;
- (void) updateScoresLabels;

- (void) setPossessionMarker;
- (void) updateGameTime:(NSTimer *)theTimer;
- (void) turnover;
- (void) timeStop;
- (void) callMenu;
- (void) setupMenu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil gameLogMgr:(GameLogMgr*) gLogMgr;

@property (nonatomic, retain) NSUndoManager *undoManager;
@property (nonatomic, retain) GameLogMgr *gameLogMgr;
@property (nonatomic, retain) UINavigationController *setupViewController;
@property (nonatomic, retain) NSTimer *timer;

@end
