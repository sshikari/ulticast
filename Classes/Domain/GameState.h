//
//  GameState.h
//  UltimateScorer
//
//  Created by Richard Chang on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"

extern NSString *const TUFTS;
extern NSString *const HARVARD;

@interface GameState : NSObject <NSCoding> {
	Team *team1;
	Team *team2;	
    int team1Score;
	int team2Score;	
	NSString *defense;
	NSString *offense;
	NSString *wind;
	BOOL team1HasPossession;
	BOOL gameTimeRunning;
	int passes;	
	int gameTimeLeftSecs;
	BOOL gameOver;
}

//@property (nonatomic, retain) NSString *team1Name;
//@property (nonatomic, retain) NSString *team2Name;
@property (nonatomic, retain) Team *team1;
@property (nonatomic, retain) Team *team2;

@property int team1Score;
@property int team2Score;
@property int passes;
@property int gameTimeLeftSecs;
@property BOOL team1HasPossession;
@property BOOL gameTimeRunning;
@property BOOL gameOver;
@property (nonatomic, retain) NSString *offense;
@property (nonatomic, retain) NSString *defense;
@property (nonatomic, retain) NSString *wind;


+ (NSArray*) offenseOptions;
+ (NSArray*) defenseOptions;
+ (NSArray*) windOptions;

- (NSString*) team1Name;
- (NSString*) team2Name;

- (id) initWithTeams: (Team*)team1: (Team*)team2;
- (id) initWithScores: (Team*)t1: (int)score1 : (Team*)t2: (int)score2;
- (NSArray*) detailsArray;
@end
