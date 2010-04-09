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

@interface GameLogMgr : NSObject {
	long gameId;
	GameState *gameState;
	NSMutableArray *unsentEvents;
	NSMutableArray *sentEvents;
}

// get mgr for game id
+(GameLogMgr*) gameLogMgr: (long)gid;
+(GameLogMgr*) newGameLogMgr;
+ (NSArray*) allGameLogMgrs;


// info/state methods	
-(int) team1Score;
-(int) team2Score;
-(NSString*) team1Name;
-(NSString*) team2Name;
-(Team*) team1;
-(Team*) team2;

-(BOOL) team1HasPossession;
-(BOOL) gameTimeRunning;
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
-(NSArray*) transferUnsent;

// debug
- (void) logEvents;

@property (nonatomic, retain) GameState *gameState;
@property long gameId;
@property (nonatomic, retain) NSMutableArray* unsentEvents;
@property (nonatomic, retain) NSMutableArray* sentEvents;
@end
