//
//  GameState.m
//  UltimateScorer
//
//  Created by Richard Chang on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"

NSString *const TUFTS = @"TUFTS";
NSString *const HARVARD = @"HARVARD";

@implementation GameState

@synthesize team1;
@synthesize team1Score;
@synthesize team2;
@synthesize team2Score;
@synthesize passes;
@synthesize offense;
@synthesize defense;
@synthesize wind;
@synthesize team1HasPossession;
@synthesize gameTimeRunning;

static NSArray* OFFENSE_OPTIONS;
static NSArray* DEFENSE_OPTIONS;
static NSArray* WIND_OPTIONS;

+ (void) initialize {
	DEFENSE_OPTIONS = [NSArray arrayWithObjects:@"3-3-1", @"3-2-1", nil];
	OFFENSE_OPTIONS = [NSArray arrayWithObjects:@"HORIZONTAL", @"VERTICAL", nil ];	
	WIND_OPTIONS = [NSArray arrayWithObjects:@"UPWIND", @"DOWNWIND", nil];
}

- (id) initWithTeams: (Team*)t1: (Team*)t2 {
	return [self initWithScores:t1 :0 :t2 :0];
}

- (id) initWithScores: (Team*)t1: (int)score1 : (Team*)t2: (int)score2 {
	if (self = [super init]) {
	    [self setTeam1:t1];
		[self setTeam1Score:score1];
		[self setTeam2:t2];
		[self setTeam2Score:score2];		
		[self setDefense: [DEFENSE_OPTIONS objectAtIndex: 0]];
		[self setOffense: [OFFENSE_OPTIONS objectAtIndex: 0]];
		[self setWind: [WIND_OPTIONS objectAtIndex: 0]];
		[self setTeam1HasPossession:YES];
		[self setGameTimeRunning: YES];
		[self setPasses:0];
	}    	
	return self;	
}

- (NSString*) team1Name {
	return [team1 name];
}

- (NSString*) team2Name {
	return [team2 name];	
}


+ (NSArray*) defenseOptions {
	return DEFENSE_OPTIONS;
}
+ (NSArray*) offenseOptions {
	return OFFENSE_OPTIONS;	
}
+ (NSArray*) windOptions {
	return WIND_OPTIONS;
}

- (NSArray*) detailsArray {
    return [NSArray arrayWithObjects:defense, offense, wind, nil];    	
}
- (void) dealloc {
	[team1 release];
	[team2 release];
	[defense release];
	[offense release];
	[wind release];
	[super dealloc];
}
@end
