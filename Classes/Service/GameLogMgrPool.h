//
//  GameLogMgrPool.h
//  ulticast
//
//  Created by Richard Chang on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLogMgr.h"

@interface GameLogMgrPool : NSObject {
@private	
	GameLogMgr* gameLogMgr;
	
}

+ (GameLogMgrPool*)sharedInstance;
- (GameLogMgr*) startNewGame : (QuickGameInfo*) gameInfo;
- (BOOL) isGameInProgress;
- (void) clearGameInProgress;
- (void) saveGameInProgress;  // saves the current member gameLogMgr
- (void) saveGameInProgress: (GameLogMgr*) gLogMgr;  // saves the gameLogMgr passed in.
- (NSArray*) allGameLogMgrs;
- (GameLogMgr*) getGameInProgress;

@end
