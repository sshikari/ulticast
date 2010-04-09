//
//  GameEvent.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameEvent.h"
#import "PassEvent.h"
#import "ScoreEvent.h"
#import "TurnEvent.h"
#import "CallEvent.h"
#import "Team.h"

NSString *const EVENT_START_GAME = @"START_GAME";
NSString *const EVENT_END_GAME = @"END_GAME";
NSString *const EVENT_FOUL = @"FOUL";
NSString *const EVENT_PASS = @"PASS";
NSString *const EVENT_SCORE = @"SCORE";
NSString *const EVENT_BLOCK = @"BLOCK";
NSString *const EVENT_DROP = @"DROP";
NSString *const EVENT_PICK = @"PICK";
NSString *const EVENT_STALL = @"STALL";
NSString *const EVENT_TIMEOUT = @"TIME";


NSString *const EVENT_TURN = @"TURN";
NSString *const EVENT_CALL = @"CALL";

NSString *const CALL_OFF_FOUL = @"OFF_FOUL";
NSString *const CALL_DEF_FOUL = @"DEF_FOUL";
NSString *const CALL_PICK = @"PICK";

NSString *const TURN_DROP = @"DROP";
NSString *const TURN_TEAM_D = @"TEAM_D";
NSString *const TURN_BLOCK = @"BLOCK";
NSString *const TURN_STALL = @"STALL";
NSString *const TURN_THROW_AWAY = @"THROW_AWAY";


@implementation GameEvent

@synthesize eventId;
@synthesize eventType;
@synthesize team;
@synthesize timestamp;
@synthesize notes;

static NSDateFormatter *DATE_FORMAT;

+ (void) initialize {
	DATE_FORMAT = [[NSDateFormatter alloc] init];
	[DATE_FORMAT setDateFormat: @"yyyy-MM-dd HH:mm:ss"]; // 2009-02-01 19:50:41
}

- (id) initWithParams: (NSString*) eType: (Team*) t {
    if (self = [super init]) {
		[self setEventType: eType];
		[self setTeam: t];
		[self setTimestamp: [NSDate date]];
	}
	return self;
}

- (id) init: (NSString*) eType {
	return [self initWithParams:eType: nil];
}


+ (GameEvent*) startGameEvent {
	return [GameEvent startEndGameEvent:EVENT_START_GAME];
}

+ (GameEvent*) endGameEvent {
	return [GameEvent startEndGameEvent:EVENT_END_GAME];
}

+ (GameEvent*) teamEvent: (NSString*) eId : (Team*) team {
	GameEvent* ev = [[GameEvent alloc] initWithParams: eId: team];
	[ev autorelease];
	return ev;
}

//+ (GameEvent*) passEvent: (Team*) teamName {
//    return [[[PassEvent alloc] initWithParams:teamName : nil] autorelease];
//}

//+ (GameEvent*) foulEvent: (NSString*) teamName {
//	return [[[CallEvent alloc] initWithParams:EVENT_FOUL: team: nil] autorelease];
//}
//
//+ (GameEvent*) dropEvent: (NSString*) teamName {
//	return [[[TurnEvent alloc] initWithParams: TURN_DROP : teamName:nil] autorelease];	
//}
//
//+ (GameEvent*) pickEvent: (NSString*) teamName {
//	return [[[TurnEvent alloc] initWithParams: TURN_THROW_AWAY:teamName :nil] autorelease];	
//}
//
//+ (GameEvent*) blockEvent: (NSString*) teamName {
//	return [[[TurnEvent alloc] initWithParams: TURN_BLOCK:teamName: nil] autorelease];	
//}

//+ (GameEvent*) stallEvent: (NSString*) teamName {
//	return [[[TurnEvent alloc] initWithParams: TURN_STALL : teamName:nil] autorelease];	
//}

//+ (GameEvent*) scoreEvent: (NSString*) teamName {
//	return [[[ScoreEvent alloc] initWithParams: teamName: 0: nil: nil: nil: nil] autorelease];		
//}
//
//+ (GameEvent*) timeoutEvent: (Team*) team {
//	return [GameEvent teamEvent:EVENT_TIMEOUT: team];
//}

+ (GameEvent*) startEndGameEvent: (NSString*) type {
	GameEvent* ev = [[GameEvent alloc] init: type];
	[ev autorelease];
	return ev;
}


- (NSString*) description {
	return [NSString stringWithFormat: @"event type[%@], teamName[%@]\n", eventType, [team name]];	
}


- (id)proxyForJson {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setValue: [DATE_FORMAT stringFromDate:timestamp] forKey:@"timestamp"];
	[dict setValue:eventType forKey:@"eventType"];
	[dict setValue:notes forKey:@"notes"];
    return dict;
}


@end
