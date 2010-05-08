//
//  Team.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Team.h"
#import "Utils.h"

@implementation Team

@synthesize teamId;
@synthesize name;
@synthesize players;


- (id) initFromDictionary: (NSDictionary*) dict {
	self = [super init];
	[self setTeamId:[[dict objectForKey: @"id"] longValue]];
	[self setName:[dict objectForKey: @"teamName"]];
	NSArray* playersArray = [Utils nilify:[dict objectForKey:@"players"]];
	if (playersArray != nil && playersArray.count != 0) {		
		NSArray *playersUnsorted = [Utils fromJSON:playersArray: Player.class];
		[self setPlayers: [playersUnsorted sortedArrayUsingSelector:@selector(compare:)]];	
	}
	return self;
}

- (id) initWithName: (NSString*) n {
	if (self = [super init]) {
		[self setName: n];	
	}
	return self;
}

- (Player*) playerAtIndex: (int) i {
    return [players objectAtIndex: i];	
}

- (NSArray*) playerNames {
	NSMutableArray* names = [NSMutableArray arrayWithCapacity:[players count]];
	for (int i=0; i<[players count]; i++) {
		[names addObject:[[players objectAtIndex:i] firstName] ];
	}
	return names; //TODO... this breaks... why? autorelease];
}

- (BOOL) isMyTeam: (NSString*) n {
	return [name isEqualToString:n];
}

- (NSString*) description {
    return name;	
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeInt:teamId forKey:@"team1"];
	[aCoder encodeObject:name forKey:@"name"];
	[aCoder encodeObject:players forKey:@"players"];		
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	teamId = [aDecoder decodeIntForKey:@"team1"];
	name = [[aDecoder decodeObjectForKey:@"name"] retain];
	players = [[aDecoder decodeObjectForKey:@"players"] retain];
	return self;	
}

- (id)proxyForJson {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setValue:[NSNumber numberWithInt: teamId] forKey:@"teamId"];
	[dict setValue:name forKey:@"name"];
	//[dict setValue:players forKey:@"players"];
	return dict;	
}


@end
