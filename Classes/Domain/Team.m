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

@synthesize myTeam;
@synthesize name;
@synthesize players;


- (id) initFromDictionary: (NSDictionary*) dict {
	self = [super init];
	self = [super initFromDictionary:dict];
	[self setName:[dict objectForKey: @"name"]];
	[self setMyTeam: [[dict objectForKey:@"is_my_team"] boolValue] ];
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
	return names;
}

- (BOOL) isMyTeam: (NSString*) n {
	return [name isEqualToString:n];
}

- (NSString*) description {
    return name;	
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[super encodeWithCoder:aCoder];
	[aCoder encodeObject:name forKey:@"name"];
	[aCoder encodeObject:players forKey:@"players"];		
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	[super initWithCoder:aDecoder];
	name = [[aDecoder decodeObjectForKey:@"name"] retain];
	players = [[aDecoder decodeObjectForKey:@"players"] retain];
	return self;	
}

- (id)proxyForJson {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setValue:name forKey:@"name"];
	//[dict setValue:players forKey:@"players"];
	return dict;	
}


@end
