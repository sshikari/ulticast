//
//  GameEvent.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"


extern NSString *const EVENT_START_GAME;
extern NSString *const EVENT_END_GAME;
extern NSString *const EVENT_PASS;
extern NSString *const EVENT_FOUL;
extern NSString *const EVENT_BLOCK;
extern NSString *const EVENT_SCORE;
extern NSString *const EVENT_PICK;
extern NSString *const EVENT_DROP;
extern NSString *const EVENT_STALL;
extern NSString *const EVENT_TIMEOUT;
extern NSString *const EVENT_TURN;
extern NSString *const EVENT_CALL;

extern NSString *const TURN_DROP;
extern NSString *const TURN_TEAM_D;
extern NSString *const TURN_BLOCK;
extern NSString *const TURN_STALL;
extern NSString *const TURN_THROW_AWAY;

extern NSString *const CALL_OFF_FOUL;
extern NSString *const CALL_DEF_FOUL;
extern NSString *const CALL_PICK;

@interface GameEvent : NSObject {
    long eventId;     // unique identifier
	NSString* eventType;   // type - e.g. call, turn, score, pass
	Team *team;  
	NSDate* timestamp;    // time event occurred
	NSString* notes;
}

+ (GameEvent*) startGameEvent;
+ (GameEvent*) endGameEvent;
+ (GameEvent*) startGameEvent;
+ (GameEvent*) endGameEvent;
//+ (GameEvent*) teamEvent: (NSString*) eId : (NSString*) teamName;
//+ (GameEvent*) passEvent: (NSString*) teamName ;
//+ (GameEvent*) foulEvent: (NSString*) teamName ;
//+ (GameEvent*) dropEvent: (NSString*) teamName ;
//+ (GameEvent*) pickEvent: (NSString*) teamName ;
//+ (GameEvent*) blockEvent: (NSString*) teamName ;
//+ (GameEvent*) stallEvent: (NSString*) teamName ;
//+ (GameEvent*) scoreEvent: (NSString*) teamName ;
//+ (GameEvent*) timeoutEvent: (NSString*) teamName ;
+ (GameEvent*) startEndGameEvent: (NSString*) type ;

- (id)proxyForJson;
- (id) initWithParams: (NSString*) eType: (Team*) t;

@property long eventId;
@property (nonatomic, retain) NSString* eventType;
@property (nonatomic, retain) Team* team;
@property (nonatomic, retain) NSDate* timestamp;
@property (nonatomic, retain) NSString* notes;

@end
