//
//  GameLogMgr.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameState.h";
#import "GameEvent.h";
#import "ScoreEvent.h";
#import "TurnEvent.h";
#import "CallEvent.h";
#import "QuickGameInfo.h";

extern long const NEW_GAME_ID;
extern NSString *const IN_PROGRESS_GAME;


@interface GameLogMgr : NSObject <NSCoding> {
	long gameId;
	
	GameState *gameState;
	QuickGameInfo *gameInfo;
	
	// TODO these should be saved in db
	NSMutableArray *events;

	//	NSMutableArray *unsentEvents;
//	NSMutableArray *sentEvents;
}


- (id) initWithTeams: (Team*) homeTeam: (Team*) awayTeam: (long) gid;
- (int) tickGameTime;

// info/state methods	
-(int) team1Score;
-(int) team2Score;
-(NSString*) team1Name;
-(NSString*) team2Name;
-(Team*) team1;
-(Team*) team2;

-(BOOL) team1HasPossession;
-(BOOL) gameTimeRunning;
-(BOOL) isGameOver;
-(int) passes;
-(NSString*) possessionTeamName;
- (Team*) offensiveTeam;
- (Team*) defensiveTeam;

-(NSArray*) teamPlayerNames: (NSString*) teamName;
-(NSArray*) otherTeamPlayerNames: (NSString*) tName;

// events
-(void) pass: (Player*) player;
- (void) score : (ScoreEvent*) scoreEvent;
- (void) turn : (TurnEvent*) turnEvent;
- (void) call : (CallEvent*) callEvent;


// timeouts
- (void) timeoutTeam1;
- (void) timeoutTeam1End;
- (void) timeoutTeam2;
- (void) timeoutTeam2End;
- (void) timeoutInjury;
- (void) timeoutInjuryEnd;
- (void) timeoutHalfTime;
- (void) timeoutHalfTimeEnd;
- (void) timeoutEndGame;

// returns unsent events and tells mgr to move these msg to sent queue
//-(NSArray*) transferUnsent;

// debug
- (void) logEvents;

@property (nonatomic, retain) GameState *gameState;
@property (nonatomic, retain) QuickGameInfo *gameInfo;

@property long gameId;
@property (nonatomic, retain) NSMutableArray* events;

//@property (nonatomic, retain) NSMutableArray* unsentEvents;
//@property (nonatomic, retain) NSMutableArray* sentEvents;
@end
