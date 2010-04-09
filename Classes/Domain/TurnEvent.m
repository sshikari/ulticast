//
//  TurnEvent.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TurnEvent.h"
#import "GameEvent.h"

@implementation TurnEvent

static NSArray* TURN_TYPES;

@synthesize player;
@synthesize turnType;

+ (void) initialize {
	TURN_TYPES = [[NSArray arrayWithObjects: @"Team D", @"D Block", @"Drop", @"Throw Away", @"Stall", nil] retain];	
}

+ (NSArray*) turnTypes {
	return TURN_TYPES;
}

-(id) init {
	if (self = [super init]) {
		[self setEventType:EVENT_TURN];
	}
	return self;
}

//-(id) initWithParams: (NSString*) tType: (NSString*) tName: (NSString*) plyer {
//	if (self = [super initWithParams:EVENT_TURN: tName]) {
//		[self setTurnType:tType];	
//		[self setPlayer: plyer];
//	}
//	return self;
//}

- (id)proxyForJson {
	NSMutableDictionary *dict = [super proxyForJson];
	[dict setValue:turnType forKey:@"turnType"];	
	[dict setValue:team forKey:@"team"];
	[dict setValue:player forKey:@"player"];
    return dict;
}


@end
