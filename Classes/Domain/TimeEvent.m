//
//  TimeEvent.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TimeEvent.h"

NSString *const TIME_START_GAME = @"START";
NSString *const TIME_END_GAME = @"END";
NSString *const TIME_HALFTIME_START = @"HALFTIME_START";
NSString *const TIME_HALFTIME_END = @"HALFTIME_END";
NSString *const TIME_INJURY_START = @"INJURY_START";
NSString *const TIME_INJURY_END = @"INJURY_END";
NSString *const TIME_TIMEOUT_START = @"TIMEOUT_START";
NSString *const TIME_TIMEOUT_END = @"TIMEOUT_END";

@interface TimeEvent (private)
-(id) initWithParams:(NSString*) tType : (Team*)t;
-(id) initWithParams:(NSString*) tType;
@end

@implementation TimeEvent

@synthesize timeType;


-(id) initWithParams:(NSString*) tType{
//	if (self = [super init]) {
//		[self setEventType:EVENT_TIMEOUT];
//		[self setTimeType: tType];
//	}
//	return self;	
	
	return [self initWithParams:tType : nil];
}

-(id) initWithParams:(NSString*) tType : (Team*)t { 
	if (self = [super init]) {
		[self setEventType:EVENT_TIMEOUT];
		[self setTimeType: tType];
		[self setTeam: t];
	}
	return self;		
}

+ (TimeEvent*) startGame {
	return [[[TimeEvent alloc] initWithParams: TIME_START_GAME] autorelease];
}

+ (TimeEvent*) endGame {
	return [[[TimeEvent alloc] initWithParams: TIME_END_GAME] autorelease];	
}
+ (TimeEvent*) halfTime {
	return [[[TimeEvent alloc] initWithParams: TIME_HALFTIME_START] autorelease];	
}

+ (TimeEvent*) halfTimeEnd {
	return [[[TimeEvent alloc] initWithParams: TIME_HALFTIME_END] autorelease];	
}

+ (TimeEvent*) injuryTimeout {
	return [[[TimeEvent alloc] initWithParams: TIME_INJURY_START] autorelease];
}

+ (TimeEvent*) injuryTimeoutEnd {
	return [[[TimeEvent alloc] initWithParams: TIME_INJURY_END] autorelease];
}

+ (TimeEvent*) timeout: (Team*) team {
	return [[[TimeEvent alloc] initWithParams: TIME_TIMEOUT_START: team] autorelease];				
}

+ (TimeEvent*) timeoutEnd: (Team*) team {
	return [[[TimeEvent alloc] initWithParams: TIME_TIMEOUT_END: team] autorelease];				
}

-(id) proxyForJson {
	NSMutableDictionary *dict = [super proxyForJson];
	[dict setValue:eventType forKey:@"eventType"];	
	[dict setValue:timeType forKey:@"timeType"];	
	[dict setValue:team forKey:@"team"];
	return dict;
}

@end
