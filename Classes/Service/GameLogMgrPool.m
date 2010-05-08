//
//  GameLogMgrPool.m
//  ulticast
//
//  Created by Richard Chang on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameLogMgrPool.h"
#import "QuickGameInfo.h"
#import "DataPushMgr.h"

long const NEW_GAME_ID = 2;
long const NO_GAME_IN_PROGRESS_ID = -1;

NSString *const IN_PROGRESS_GAME = @"IN_PROGRESS_GAME";
static GameLogMgrPool* sharedInstance = nil;


@interface GameLogMgrPool()
@property (nonatomic, retain) GameLogMgr* gameLogMgr;

@end


@implementation GameLogMgrPool


@synthesize gameLogMgr;

+ (GameLogMgrPool*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil) {
			sharedInstance = [[GameLogMgrPool alloc] init];	
			NSData* savedMgr = [[NSUserDefaults standardUserDefaults] objectForKey: IN_PROGRESS_GAME];
			if (savedMgr != nil) {
				sharedInstance.gameLogMgr = [[NSKeyedUnarchiver unarchiveObjectWithData:savedMgr] retain];
				[[NSUserDefaults standardUserDefaults] removeObjectForKey:IN_PROGRESS_GAME];  
			} 
			[DataPushMgr sharedInstance];  // start push services
		}
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

-(id) init {
	if (self = [super init]) {
	}
	return self;
}



- (GameLogMgr*) startNewGame : (QuickGameInfo*) gameInfo {	
	self.gameLogMgr = [[[GameLogMgr alloc] initWithTeams: [gameInfo myTeam]: [gameInfo opponentTeam]: NEW_GAME_ID] autorelease];
	[self.gameLogMgr setGameInfo: gameInfo];
	return gameLogMgr;	
}


- (GameLogMgr*) getGameInProgress {
	return gameLogMgr;	
}

- (BOOL) isGameInProgress {
	//	id obj = [[NSUserDefaults standardUserDefaults] objectForKey: IN_PROGRESS_GAME];
	//    return obj != nil;	
	return gameLogMgr != nil;
	//[gameLogMgr.gameId != NO_GAME_IN_PROGRESS_ID;
}

- (void) clearGameInProgress {
	[gameLogMgr release];
	gameLogMgr = nil;
	NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:IN_PROGRESS_GAME]);
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:IN_PROGRESS_GAME];  
}

- (void) saveGameInProgress: (GameLogMgr*) gLogMgr {
	self.gameLogMgr	= gLogMgr;
}

- (void) saveGameInProgress {
	if ([self isGameInProgress]) {
		NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:gameLogMgr];
		[[NSUserDefaults standardUserDefaults] setObject:archivedObject forKey:IN_PROGRESS_GAME];
	}
}



- (NSArray*) allGameLogMgrs {
    //return [gameLoggerMap allValues];
	return gameLogMgr != nil ? [NSArray arrayWithObject: gameLogMgr] : nil;
}

@end
