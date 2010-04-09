//
//  TimeEvent.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameEvent.h"
#import "Team.h"

extern NSString *const TIME_START_GAME;
extern NSString *const TIME_END_GAME;
extern NSString *const TIME_HALFTIME_START;
extern NSString *const TIME_HALFTIME_END;
extern NSString *const TIME_INJURY_START;
extern NSString *const TIME_INJURY_END;
extern NSString *const TIME_TIMEOUT_START;
extern NSString *const TIME_TIMEOUT_END;

@interface TimeEvent : GameEvent {
	NSString* timeType;
}

//-(id) initWithParams: (NSString*) tType;

+ (TimeEvent*) startGame;
+ (TimeEvent*) endGame;
+ (TimeEvent*) halfTime;
+ (TimeEvent*) halfTimeEnd;
+ (TimeEvent*) injuryTimeout;
+ (TimeEvent*) injuryTimeoutEnd;
+ (TimeEvent*) timeout: (Team*) team;
+ (TimeEvent*) timeoutEnd: (Team*) team;


@property (retain, nonatomic) NSString* timeType;
@end
