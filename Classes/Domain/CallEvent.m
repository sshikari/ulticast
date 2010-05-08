//
//  CallEvent.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CallEvent.h"
#import "GameEvent.h"

@implementation CallEvent
@synthesize caller;
@synthesize fouler;
@synthesize callType;
@synthesize contested;

static NSArray* CALL_TYPES;

-(id) init {
	if (self = [super init]) {
		[self setEventType:EVENT_CALL];	
	}
	return self;
}

//-(id) initWithParams: (NSString*) cType: (NSString*) tName: (NSString*) plyer {
//	if (self = [super initWithParams:EVENT_CALL: tName]) {
//		[self setCallType:cType];	
//		[self setPlayer: plyer];
//	}
//	return self;
//}

+ (void) initialize {
	CALL_TYPES = [[NSArray arrayWithObjects: @"Defensive Foul", @"Offensive Foul", nil] retain];	
}

+ (NSArray*) callTypes {
	return CALL_TYPES;
}

- (BOOL) isDefensiveCall {
	return [CallEvent isDefensiveCall:callType];	
}

+ (BOOL) isDefensiveCall: (NSString*) callType {
	if ([[CALL_TYPES objectAtIndex:0] isEqualToString: callType]) {  // add || statements for more call types
		return YES;	
	} else if ([[CALL_TYPES objectAtIndex:1] isEqualToString: callType]) {
		return FALSE;
	} else {
		return FALSE;
	}	
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeBool:contested forKey:@"contested"];
	[aCoder encodeObject:caller forKey:@"caller"];
	[aCoder encodeObject:fouler forKey:@"fouler"];
	[aCoder encodeObject:callType forKey:@"callType"];	
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	contested = [aDecoder decodeBoolForKey:@"contested"];
	caller = [[aDecoder decodeObjectForKey:@"caller"] retain];
	fouler = [[aDecoder decodeObjectForKey:@"fouler"] retain];
	callType = [[aDecoder decodeObjectForKey:@"callType"] retain];
	return self;
}


- (id)proxyForJson {
	NSMutableDictionary *dict = [super proxyForJson];
	[dict setValue:callType forKey:@"callType"];	
	[dict setValue:[NSNumber numberWithBool: contested] forKey:@"contested"];
	[dict setValue:caller forKey:@"caller"];
	[dict setValue:fouler forKey:@"fouler"];
    return dict;
}

@end
