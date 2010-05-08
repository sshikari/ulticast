//
//  ScoreEvent.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScoreEvent.h"

@implementation ScoreEvent

static NSArray* DISTANCE_OPTIONS;

@synthesize player;
@synthesize assister;
@synthesize distanceDescriptor;
@synthesize teamScore;

+ (void) initialize {
	DISTANCE_OPTIONS = [[NSArray arrayWithObjects: @"Sick!", @"MidField", @"Brick", nil] retain];	
}

- (id) init {
	return [self initWith: nil];	
}


- (id) initWith: (Team*) t {
	if (self = [super init]) {
		[self setEventType: EVENT_SCORE];
		[self setTeam: t];
	}
	return self;
}

//- (id) initWithParams: (NSString*) team: (int) tscore:
//					   (NSString*) play: (NSString*) assist: 
//					   (NSString*) distance: (NSString*) note {
//      if (self = [super initWithParams: EVENT_SCORE: team]) {
//		  [self setTeamScore: tscore];
//	      [self setPlayer:play];
//		  [self setAssister:assist];
//		  [self setDistanceDescriptor:distance];
//		  [self setNotes:note];
//	  }	
//      return self;	
//}

+ (NSArray*) distanceOptions {
	return DISTANCE_OPTIONS;		
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeInt:teamScore forKey:@"teamScore"];
	[aCoder encodeObject:player forKey:@"player"];
	[aCoder encodeObject:assister forKey:@"assister"];
	[aCoder encodeObject:distanceDescriptor forKey:@"distanceDescriptor"];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	teamScore = [aDecoder decodeIntForKey:@"timeType"];
	player = [[aDecoder decodeObjectForKey:@"player"] retain];
	assister = [[aDecoder decodeObjectForKey:@"assister"] retain];
	distanceDescriptor = [[aDecoder decodeObjectForKey:@"distanceDescriptor"] retain];
	return self;
}

- (id)proxyForJson {
	NSMutableDictionary *dict = [super proxyForJson];
	[dict setValue:player forKey:@"player"];
	[dict setValue:assister forKey:@"assister"];
	[dict setValue:distanceDescriptor forKey:@"distanceDescriptor"];
	[dict setValue:[NSNumber numberWithInt: teamScore] forKey:@"score"];
    return dict;
	
/*	return [NSDictionary dictionaryWithObjectsAndKeys:
			//timestamp
			@"2007-04-06T00:00:00", @"timestamp",
			eventType, @"eventType",
			teamName, @"teamName",
			[NSNull null], @"player",
			@"crapassister", @"assister",
			distanceDescriptor, @"distanceDescriptor",
			notes, @"notes",
			[NSNumber numberWithInt: teamScore], @"teamScore",
			
			nil];
 */
}

@end
