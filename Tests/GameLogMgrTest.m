//
//  GameLogMgrTest.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameLogMgrTest.h"
//#import "GameLogMgr.h"
#import "ScoreEvent.h"
#import "Player.h"
#import "JSON.h"

@interface GameLogMgrTest (private)
- (NSArray*) createPlayers: (NSString*) prefix: (int) num; 


@end

@implementation GameLogMgrTest

- (void) setUp {
   	
}


- (NSArray*) createPlayers: (NSString*) prefix: (int) num {
	NSMutableArray* names = [NSMutableArray arrayWithCapacity:num];
	for (int i=0; i<num; i++) {
		Player *p = [[Player alloc] init];
		[p setShortName: [NSString stringWithFormat:@"%@-%d", prefix, i]];
		[names addObject: p];
		[p release];
	}
	return [names autorelease];
}

- (void) testSomething {
	NSLog(@"testing");
	
	Team *homeTeam = [[Team alloc] initWithName:@"Harvard"];
	[homeTeam setPlayers: [self createPlayers: @"harvard": 7]];

	Team *awayTeam = [[Team alloc] initWithName:@"Tufts"];
	[awayTeam setPlayers: [self createPlayers: @"tufts": 7]];

//	GameLogMgr* mgr = [GameLogMgr newGameLogMgr: homeTeam: awayTeam];
//    [mgr startGame]; 	
	
//	[mgr pass:(Player * )player
//	[mgr endGam e];
	
//	 ScoreEvent *ev = [[ScoreEvent alloc] initWith: homeTeam];
// 	 NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//
//	[dict setObject:ev forKey:@"event"];
//	 NSLog(@"%@", [dict JSONRepresentation]);
//	 
//	NSMutableArray *array = [NSMutableArray array];
//	[array addObject: ev];
//	NSLog(@"%@", [array JSONRepresentation]);
	
	//GameLogMgr *mgr = [GameLogMgr newGameLogMgr];	
	//GameLogMgr *mgr = [[GameLogMgr alloc] init];  // add self to log mgr map, null/0 id
	// new game event sent to server?
	
	/**
	 team selection
		- My Teams/Division list
		- create team
			- name, location
			- add/create players
				- list of players
	 Players
		- shortname, first, last, position
		- list of teams
	 
	 */
	
//	TeamDataMgr *teamMgr = [TeamDataMgr sharedInstance];
//	teamMgr getTeamByName
//			
//	[mgr startGame];
//	
//	ScoreEvent *event = [[ScoreEvent alloc] init];
//	[event setTeamName:@"Harvard"];
//	[mgr score: event];
//	NSLog(@"%d", [mgr team1Score]);	
	
}

@end
