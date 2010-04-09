//
//  GameLogMgr.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameLogMgr.h"
#import "GameEvent.h"
#import "TurnEvent.h"
#import "DataPushMgr.h"
#import "ScoreEvent.h"
#import "TimeEvent.h"
#import "PassEvent.h"
#import "Team.h"
#import "Player.h"

@interface GameLogMgr (private)
- (id) initWith:(long) gId;
- (void) addEvent:(GameEvent*)gameEvent;
- (void) turnover;
- (NSArray*) events;
- (void) startTimeEvent: (TimeEvent*) timeEvent;
- (void) stopTimeEvent: (TimeEvent*) timeEvent;

@end


@implementation GameLogMgr

// map of game ids to loggers
static NSMutableDictionary* gameLoggerMap;

@synthesize gameId;
@synthesize gameState;
@synthesize unsentEvents;
@synthesize sentEvents;

+ (void)initialize {
    gameLoggerMap = [[NSMutableDictionary dictionary] retain];
	// TODO move this initializer.
	// right now, once you load a game logger, you may have data to push.
	[DataPushMgr sharedInstance];
}

+ (NSArray*) allGameLogMgrs {
    return [gameLoggerMap allValues];
}
+ (GameLogMgr*) newGameLogMgr {
	return nil;  // TODO	
}
	
	
+(GameLogMgr*) gameLogMgr: (long)gid {
	GameLogMgr* logMgr = [gameLoggerMap objectForKey:[NSNumber numberWithLong:gid]];
	if (logMgr == NULL) {
		NSLog(@"Adding log mgr for gameId: %d", gid);
		logMgr = [[GameLogMgr alloc] initWith: gid];
		[gameLoggerMap setObject:logMgr forKey:[NSNumber numberWithLong:gid]];	
	}
	
	[logMgr autorelease];
	return logMgr;
}

- (id) initWith:(long) gId {
	if (self = [super init]) {
		[self setGameId:gId];
		[self setUnsentEvents:[NSMutableArray array]];
		[self setSentEvents:[NSMutableArray array]];
	}
	return self;
}

#pragma mark -
#pragma mark class instance methods


/*
 
- log entry
- 
 
 
GameLogger
- game id
- gameState
   - teams
   - score
   - possession
   - time
 
 */
// init with teams, etc.
- (void) startGame {
    //[self addEvent:[GameEvent startGameEvent]];
	[self addEvent:[TimeEvent startGame]];
}

- (void) endGame {
	//[self addEvent:[GameEvent endGameEvent]];
	[self addEvent:[TimeEvent endGame]];
}

- (void) timeoutTeam1 {	
	[self stopTimeEvent: [TimeEvent timeout:[self team1]]];
}
- (void) timeoutTeam1End{		
	[self startTimeEvent: [TimeEvent timeoutEnd:[self team1]]];
}
- (void) timeoutTeam2{	
  	[self stopTimeEvent: [TimeEvent timeout:[self team2]]];
}
- (void) timeoutTeam2End{	
	[self startTimeEvent: [TimeEvent timeoutEnd:[self team2]]];	
}
- (void) timeoutInjury{	
  	[self stopTimeEvent: [TimeEvent injuryTimeout]];	
}
- (void) timeoutInjuryEnd{	
	[self startTimeEvent: [TimeEvent injuryTimeoutEnd]];	
}
- (void) timeoutHalfTime{	
  	[self stopTimeEvent: [TimeEvent halfTime]];		
}
- (void) timeoutHalfTimeEnd{	
	[self startTimeEvent: [TimeEvent halfTimeEnd]];		
}
- (void) timeoutEndGame{	
	[self stopTimeEvent: [TimeEvent endGame]];		
}

- (void) stopTimeEvent: (TimeEvent*) timeEvent {
	[timeEvent setTimestamp: [[NSDate date] retain]];
	[self addEvent:timeEvent];
	gameState.gameTimeRunning = NO;

}

- (void) startTimeEvent: (TimeEvent*) timeEvent {
	[timeEvent setTimestamp: [[NSDate date] retain]];
	[self addEvent:timeEvent];
	gameState.gameTimeRunning = YES;	
}

//- (BOOL) timeout {
//	// if time is running, stop time, return true
//	// else start time, return false.
//	BOOL gameRunningPriorToCall = gameState.gameTimeRunning;
//	gameState.gameTimeRunning = ! gameState.gameTimeRunning;
//	
//    return gameRunningPriorToCall;    		
//}

- (void) addEvent: (GameEvent*) event {
	[unsentEvents addObject: event];		
}


- (int) passes {
	return gameState.passes;
}
- (void) pass : (Player*) player{
	gameState.passes++;
	PassEvent* passEvent = [[PassEvent alloc] init];	
	[passEvent setPlayer:player];
	[passEvent setTeam:[self offensiveTeam]];
	[self addEvent:passEvent];
	
//	[[PassEvent alloc] initWithParams: [self offensiveTeam]: player]
//    [self addEvent: ];
}

- (Team*) offensiveTeam {
	return gameState.team1HasPossession ? gameState.team1: gameState.team2;	
}

- (Team*) defensiveTeam {
	return gameState.team1HasPossession ? gameState.team2: gameState.team1;	
}

- (NSString*) possessionTeamName {
	return gameState.team1HasPossession ? [self team1Name] : [self team2Name];
		 
}


- (NSArray*) otherTeamPlayerNames: (NSString*) tName {
	if ([[gameState team1] isMyTeam:tName]) {
		return [[gameState team2] playerNames];
	} else {
		return [[gameState team1] playerNames];
	}
}

- (NSArray*) teamPlayerNames: (NSString*)tName {
	if ([[gameState team1] isMyTeam:tName]) {
		return [[gameState team1] playerNames];
	} else {
		return [[gameState team2] playerNames];
	}
}
//-(NSArray*) team1PlayerNames {
//	return [NSArray arrayWithObjects:@"Rich", @"Blake"];
//}
//-(NSArray*) team2PlayerNames {
//	return [NSArray arrayWithObjects:@"Bill", @"Hillary"];		
//}



//- (void) score {
//	if (gameState.team1HasPossession) {
//		gameState.team1Score++;
//	} else {  // team 2 scored
//		gameState.team2Score++;
//	}
//	[self addEvent:[GameEvent scoreEvent:[self possessionTeamName]]];
//	[self turnover];
//}

- (void) turn : (TurnEvent*) turnEvent {
	[turnEvent setTimestamp:[[NSDate date] retain]];
	[self addEvent:turnEvent];
	[self turnover];
}

- (void) score : (ScoreEvent*) scoreEvent {
	int newScore = 0;
	if (gameState.team1HasPossession) {
		gameState.team1Score++;
		newScore = gameState.team1Score;
	} else {  // team 2 scored
		gameState.team2Score++;
		newScore = gameState.team2Score;
	}
	[scoreEvent setTeamScore:newScore];
	[scoreEvent setTimestamp:[[NSDate date] retain]];
	[self addEvent:scoreEvent];
	[self turnover];
}

- (void) call : (CallEvent*) callEvent {
	[callEvent setTimestamp:[[NSDate date] retain]];
	[self addEvent:callEvent];
	[self turnover];
}

//- (void) foul {
//	[self addEvent:[GameEvent foulEvent:[self possessionTeamName]]];
//	[self turnover];
//}
//- (void) drop {
//	[self addEvent:[GameEvent dropEvent:[self possessionTeamName]]];
//	[self turnover];
//}
//
//
//- (void) pick {
//	[self addEvent:[GameEvent pickEvent:[self possessionTeamName]]];
//	[self turnover];
//}
//
//- (void) block {
//	[self addEvent:[GameEvent blockEvent:[self possessionTeamName]]];
//	[self turnover];	
//}
//
//- (void) stall {
//	[self addEvent:[GameEvent stallEvent:[self possessionTeamName]]];
//	[self turnover];	
//}

- (BOOL) team1HasPossession {
    return [gameState team1HasPossession];	
}

- (BOOL) gameTimeRunning {
	return gameState.gameTimeRunning;	
}


- (void) turnover {	 	
	gameState.team1HasPossession = !gameState.team1HasPossession;		
	// TODO end of drive
	gameState.passes = 0;
}

- (int) team1Score {
	return gameState.team1Score;
}

- (int) team2Score {
	return gameState.team2Score;
}

- (Team*) team1 {
	return gameState.team1;
}
- (Team*) team2 {
	return gameState.team2;
}
	 
- (NSString*) team1Name {
	return [gameState team1Name];
}

- (NSString*) team2Name {
	return [gameState team2Name];
}

-(void) logEvents {
	NSLog(@"%@", [self events]);
}

-(NSArray*) events {
   	@synchronized(self) {
		// TODO there must be a better way to combine and then make immutable an array...
		NSMutableArray* combined = [NSMutableArray arrayWithArray:unsentEvents];
		[combined addObjectsFromArray:sentEvents];		
		return [NSArray arrayWithArray:combined];
	}
	return nil;
}

// transfer unsent events to sent events list, return unsent items
-(NSArray*) transferUnsent {
   	@synchronized(self) {
		NSArray* wasUnsent =[NSArray arrayWithArray: unsentEvents];
		[sentEvents addObjectsFromArray:unsentEvents];
		[unsentEvents removeAllObjects];
		return wasUnsent;
	}
	return nil;
}

#pragma mark -
#pragma mark Singleton methods


@end
